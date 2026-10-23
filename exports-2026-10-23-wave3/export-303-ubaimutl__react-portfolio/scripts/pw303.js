// usage: PLAYWRIGHT_MODULE=<playwright dir> CHROME_PATH=<chromium 1194> node pw303.js http://127.0.0.1:PORT
// Only 127.0.0.1 is allowed; every other origin is blocked and counted (fonts, picsum images, EmailJS API).
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const base = process.argv[2];
(async () => {
  const b = await chromium.launch({ executablePath: process.env.CHROME_PATH });
  const ctx = await b.newContext();
  const blocked = new Map(), errors = [], local404 = [];
  await ctx.route('**/*', r => { const u = new URL(r.request().url());
    if (u.hostname === '127.0.0.1') return r.continue();
    blocked.set(u.origin, (blocked.get(u.origin) || 0) + 1); return r.abort(); });
  const p = await ctx.newPage();
  p.on('pageerror', e => errors.push('pageerror: ' + e.message));
  p.on('response', r => { if (r.url().startsWith(base) && r.status() >= 400) local404.push(r.status() + ' ' + r.url().slice(base.length)); });
  const h1 = () => p.evaluate(() => Array.from(document.querySelectorAll('h1')).map(e => e.innerText.trim().replace(/\s+/g, ' ')).join(' | '));
  for (const path of ['/', '/about', '/portfolio', '/contact']) {
    const r = await p.goto(base + path, { waitUntil: 'load' }); await p.waitForTimeout(700);
    console.log(`[direct load] ${path} -> HTTP ${r.status()} title="${await p.title()}" h1="${await h1()}"`);
  }
  await p.goto(base + '/', { waitUntil: 'load' }); await p.waitForTimeout(500);
  for (const [label, to] of [['Portfolio', '/portfolio'], ['About', '/about'], ['Contact', '/contact']]) {
    await p.click('.menu__button'); await p.waitForTimeout(500);
    await p.click(`a[href="${to}"]`); await p.waitForTimeout(800);
    console.log(`[nav click] ${label} -> path=${new URL(p.url()).pathname} h1="${await h1()}"`);
  }
  const rr = await p.reload({ waitUntil: 'load' }); await p.waitForTimeout(700);
  console.log(`[reload] ${new URL(p.url()).pathname} -> HTTP ${rr.status()} h1="${await h1()}"`);
  await p.fill('input[name=name]', 'Test'); await p.fill('input[name=email]', 'test@example.com'); await p.fill('textarea[name=message]', 'hello');
  await p.click('button[type=submit]'); await p.waitForTimeout(1500);
  const alert = await p.evaluate(() => (document.querySelector('.co_alert') || {}).innerText || '(no alert)');
  console.log(`[contact submit, placeholder EmailJS IDs, external network blocked] alert="${alert.trim().replace(/\s+/g, ' ')}"`);
  const r404 = await p.goto(base + '/does-not-exist', { waitUntil: 'load' });
  console.log(`[direct load] /does-not-exist -> HTTP ${r404.status()}`);
  console.log('blocked external origins: ' + JSON.stringify(Object.fromEntries(blocked)));
  console.log('same-origin >=400 responses: ' + JSON.stringify(local404));
  console.log('page errors: ' + JSON.stringify(errors));
  await b.close();
})();
