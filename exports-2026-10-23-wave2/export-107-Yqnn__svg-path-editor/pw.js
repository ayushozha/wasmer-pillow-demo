// usage: PLAYWRIGHT_MODULE=<playwright dir> CHROME_PATH=<chromium 1194 binary> node pw.js http://127.0.0.1:3931   (Playwright; only 127.0.0.1 allowed, all other origins blocked and recorded)
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const base = process.argv[2];
(async () => {
  const b = await chromium.launch({ executablePath: process.env.CHROME_PATH });
  const ctx = await b.newContext({ serviceWorkers: 'block' });
  const blocked = new Map(), errors = [], bad = [];
  await ctx.route('**/*', r => { const u = new URL(r.request().url());
    if (u.hostname === '127.0.0.1') return r.continue();
    blocked.set(u.origin, (blocked.get(u.origin) || 0) + 1); return r.abort(); });
  const p = await ctx.newPage();
  p.on('pageerror', e => errors.push('pageerror: ' + e.message));
  p.on('console', m => { if (m.type() === 'error') errors.push('console.error: ' + m.text()); });
  p.on('response', r => { if (r.status() >= 400) bad.push(r.status() + ' ' + r.url()); });
  const resp = await p.goto(base + '/', { waitUntil: 'networkidle' });
  console.log('GET / ->', resp.status(), 'title=', await p.title());
  await p.waitForSelector('svg[app-canvas] path', { timeout: 15000 });
  const info = await p.evaluate(() => {
    const svg = document.querySelector('svg[app-canvas]');
    const paths = [...svg.querySelectorAll('path')];
    const bb = svg.getBoundingClientRect();
    return { viewBox: svg.getAttribute('viewBox'), svgSize: [Math.round(bb.width), Math.round(bb.height)],
      paths: paths.length, firstD: (paths[0] && paths[0].getAttribute('d') || '').slice(0, 60),
      commandRows: document.querySelectorAll('[id^=svg_command_row_]').length,
      pathTextarea: (document.querySelector('textarea') || {}).value?.slice(0, 60) };
  });
  console.log('editor canvas:', JSON.stringify(info));
  // edit flow: replace the path text and confirm the canvas updates
  const ta = p.locator('textarea').first();
  await ta.fill('M 0 0 L 10 10 L 20 0 Z'); await ta.press('Tab'); await p.waitForTimeout(500);
  const after = await p.evaluate(() => ({ rows: document.querySelectorAll('[id^=svg_command_row_]').length,
    d: document.querySelector('svg[app-canvas] path').getAttribute('d') }));
  console.log('after editing path to "M 0 0 L 10 10 L 20 0 Z":', JSON.stringify(after));
  await p.screenshot({ path: __dirname + '/shot-editor.png' });
  // shared-link flow: a fresh browser opening /#P=<path> (import.component.ts reads location.hash) imports that path
  const p2 = await (await b.newContext({ serviceWorkers: 'block' })).newPage();
  await p2.route('**/*', r => new URL(r.request().url()).hostname === '127.0.0.1' ? r.continue() : r.abort());
  await p2.goto(base + '/#P=M_0_0_L_10_10_L_20_0_Z', { waitUntil: 'networkidle' });
  await p2.waitForSelector('svg[app-canvas] path', { timeout: 15000 }); await p2.waitForTimeout(500);
  console.log('fresh load of /#P=M_0_0_L_10_10_L_20_0_Z:', JSON.stringify(await p2.evaluate(() => ({
    d: document.querySelector('svg[app-canvas] path').getAttribute('d'), rows: document.querySelectorAll('[id^=svg_command_row_]').length, hashAfter: location.hash }))));
  console.log('HTTP >=400 responses:', bad.length ? bad : 'none');
  console.log('blocked non-127.0.0.1 origins:', JSON.stringify([...blocked]));
  console.log('page/console errors (' + errors.length + '):'); errors.forEach(e => console.log('  ' + e.slice(0, 200)));
  await b.close();
})().catch(e => { console.log('FAILED', e.message); process.exit(1); });
