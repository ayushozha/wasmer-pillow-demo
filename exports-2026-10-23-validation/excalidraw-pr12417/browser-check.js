// Playwright check: load /, wait for canvas, draw a rectangle, confirm element in localStorage.
const { chromium } = require('/opt/node-tools/node_modules/playwright');
const BASE = process.argv[2] || 'http://127.0.0.1:3903';
const OUT = process.argv[3];
(async () => {
  const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
  const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
  const blocked = {}; const consoleErrors = []; const pageErrors = []; const failed = []; const local = {};
  await page.route('**/*', (route) => {
    const u = new URL(route.request().url());
    if (u.hostname === '127.0.0.1' || u.protocol === 'data:' || u.protocol === 'blob:') return route.continue();
    blocked[u.origin] = (blocked[u.origin] || 0) + 1; return route.abort();
  });
  page.on('console', (m) => { if (m.type() === 'error') consoleErrors.push(m.text()); });
  page.on('pageerror', (e) => pageErrors.push(String(e)));
  page.on('response', (r) => { const u = new URL(r.url()); if (u.hostname === '127.0.0.1') { local[r.status()] = (local[r.status()] || 0) + 1; if (r.status() >= 400) failed.push(r.status() + ' ' + r.url()); } });
  const resp = await page.goto(BASE + '/', { waitUntil: 'load' });
  console.log('goto / status', resp.status());
  await page.waitForSelector('canvas.interactive, canvas', { timeout: 30000 });
  await page.waitForTimeout(1500);
  console.log('title', await page.title());
  console.log('canvases', await page.locator('canvas').count());
  const before = await page.evaluate(() => localStorage.getItem('excalidraw'));
  console.log('localStorage excalidraw before:', before);
  await page.mouse.click(640, 400); // focus canvas
  await page.keyboard.press('r');
  await page.mouse.move(400, 300); await page.mouse.down();
  await page.mouse.move(500, 380, { steps: 5 }); await page.mouse.move(600, 450, { steps: 5 });
  await page.mouse.up();
  await page.waitForTimeout(1500); // excalidraw saves to localStorage debounced
  await page.keyboard.press('Escape'); await page.waitForTimeout(1500);
  const after = await page.evaluate(() => localStorage.getItem('excalidraw'));
  let els = []; try { els = JSON.parse(after || '[]'); } catch (e) {}
  console.log('localStorage excalidraw elements:', els.length, JSON.stringify(els.map((e) => ({ type: e.type, w: e.width, h: e.height, isDeleted: e.isDeleted }))));
  const sw = await page.evaluate(async () => { if (!navigator.serviceWorker) return 'no-api'; const r = await navigator.serviceWorker.getRegistrations(); return r.map((x) => x.active ? x.active.scriptURL : (x.installing || x.waiting || {}).scriptURL); });
  console.log('service worker registrations:', JSON.stringify(sw));
  if (OUT) await page.screenshot({ path: OUT });
  console.log('local responses by status:', JSON.stringify(local));
  console.log('local failed (>=400):', JSON.stringify(failed));
  console.log('blocked external origins:', JSON.stringify(blocked));
  console.log('console errors (' + consoleErrors.length + '):'); consoleErrors.forEach((e) => console.log('  ' + e.slice(0, 300)));
  console.log('page errors (' + pageErrors.length + '):'); pageErrors.forEach((e) => console.log('  ' + e.slice(0, 300)));
  console.log('RESULT rectangle_created=' + (els.some((e) => e.type === 'rectangle' && !e.isDeleted)));
  await browser.close();
})().catch((e) => { console.log('SCRIPT ERROR', e); process.exit(1); });
