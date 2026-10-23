// Follow-up: add a text element and record which font URLs are requested (CDN vs local fallback "/").
const { chromium } = require('/opt/node-tools/node_modules/playwright');
(async () => {
  const b = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
  const p = await b.newPage({ viewport: { width: 1280, height: 800 } });
  const reqs = [];
  await p.route('**/*', (r) => { const u = new URL(r.request().url()); if (u.hostname === '127.0.0.1') return r.continue(); reqs.push('BLOCKED ' + r.request().url()); return r.abort(); });
  p.on('response', (r) => { if (/woff2/.test(r.url())) reqs.push(r.status() + ' ' + r.url()); });
  await p.goto('http://127.0.0.1:3903/'); await p.waitForSelector('canvas'); await p.waitForTimeout(1500);
  await p.mouse.click(640, 400); await p.keyboard.press('t'); await p.mouse.click(500, 300);
  await p.keyboard.type('Hello Wasmer'); await p.keyboard.press('Escape'); await p.waitForTimeout(3000);
  const els = JSON.parse(await p.evaluate(() => localStorage.getItem('excalidraw')) || '[]');
  console.log('elements:', JSON.stringify(els.map((e) => ({ type: e.type, text: e.text, fontFamily: e.fontFamily }))));
  console.log('font requests (' + reqs.filter((r) => /woff2/.test(r)).length + '):'); reqs.filter((r) => /woff2/.test(r)).forEach((r) => console.log('  ' + r));
  await b.close();
})().catch((e) => { console.log('SCRIPT ERROR', e); process.exit(1); });
