"""Capture a real locally served Flutter web app via Chrome DevTools.
Requires: websocket-client; Chrome started with remote-debugging-port=9223.
No synthetic UI or evidence images are generated.
"""
import base64, json, time, urllib.request, sys
sys.stdout.reconfigure(encoding='utf-8')
from pathlib import Path
import websocket

class Browser:
    def __init__(self):
        pages = json.load(urllib.request.urlopen('http://127.0.0.1:9223/json'))
        self.ws = websocket.create_connection(next(p['webSocketDebuggerUrl'] for p in pages if p['type'] == 'page'), origin='http://localhost:9223')
        self.seq = 0
    def call(self, method, params=None):
        self.seq += 1
        self.ws.send(json.dumps({'id': self.seq, 'method': method, 'params': params or {}}))
        while True:
            result = json.loads(self.ws.recv())
            if result.get('id') == self.seq:
                if 'error' in result: raise RuntimeError(result['error'])
                return result.get('result', {})
    def js(self, expression):
        result = self.call('Runtime.evaluate', {'expression': expression, 'returnByValue': True})
        if 'exceptionDetails' in result: raise RuntimeError(result['exceptionDetails'])
        return result.get('result', {}).get('value')
    def shot(self, name):
        time.sleep(1)
        data = self.call('Page.captureScreenshot', {'format': 'png', 'captureBeyondViewport': False})
        Path('docs/screenshots').mkdir(parents=True, exist_ok=True)
        Path(f'docs/screenshots/{name}.png').write_bytes(base64.b64decode(data['data']))
    def click(self, x, y):
        for event in ['mousePressed', 'mouseReleased']:
            self.call('Input.dispatchMouseEvent', {'type': event, 'x': x, 'y': y, 'button': 'left', 'clickCount': 1})
        time.sleep(.6)
    def text(self, label):
        result = self.js("""(() => {const label = %s;
          const nodes = [...document.querySelectorAll('flt-semantics')].filter(e =>
            (e.textContent === label || e.getAttribute('aria-label') === label) &&
            e.getBoundingClientRect().width > 0);
          const e = nodes.find(e => e.getAttribute('role') === 'button') || nodes.at(-1);
          return e ? e.getBoundingClientRect().toJSON() : null;})()""" % json.dumps(label))
        if not result: raise RuntimeError('Missing actual UI label: '+label)
        self.click(result['x']+result['width']/2, result['y']+result['height']/2)

if __name__ == '__main__':
    b=Browser()
    b.call('Page.enable')
    b.call('Runtime.enable')
    b.call('Emulation.setDeviceMetricsOverride', {'width': 1280, 'height': 1000, 'deviceScaleFactor': 1, 'mobile': False})
    b.call('Page.navigate', {'url': 'http://127.0.0.1:8765'})
    time.sleep(10)
    b.js("document.querySelector('flt-semantics-placeholder')?.click()")
    time.sleep(2)
    b.shot('01-home-desktop')
    print(b.js('document.body.innerText'))
    Path('build/web-dom.html').write_text(b.js('document.body.innerHTML'),encoding='utf-8')
