// usage: PLAYWRIGHT_MODULE=<playwright dir> CHROME_PATH=<chromium binary> node pw.js http://127.0.0.1:<port>
// Only 127.0.0.1 is allowed; every other origin is blocked and counted. Service workers blocked.
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
  p.on('console', m => { if (m.type() === 'error' || m.type() === 'warning') errors.push('console.' + m.type() + ': ' + m.text()); });
  p.on('response', r => { if (r.status() >= 400) bad.push(r.status() + ' ' + r.url()); });
  let r = await p.goto(base + '/', { waitUntil: 'networkidle' });
  console.log('GET / ->', r.status(), 'title=', JSON.stringify(await p.title()),
    'cheatsheet cards linking to .html:', await p.locator('a[href$=".html"]').count());
  await p.screenshot({ path: __dirname + '/shot-index.png' });
  // client-side search: Fuse.js + /search.json, opened with the #mysearch-trigger button
  await p.click('#mysearch-trigger'); await p.waitForTimeout(800);
  console.log('search opened, empty query: results=', await p.locator('#mysearch-list li').count());
  await p.locator('#mysearch-input').pressSequentially('python', { delay: 50 }); await p.waitForTimeout(800);
  const res = await p.evaluate(() => [...document.querySelectorAll('#mysearch-list li a')].slice(0, 5).map(a => a.getAttribute('href') + ' ' + a.innerText.split('\n')[0].trim()));
  console.log('search "python": results=', await p.locator('#mysearch-list li').count(), 'top=', JSON.stringify(res), 'url=', p.url().replace(base, ''));
  await p.screenshot({ path: __dirname + '/shot-search.png' });
  // follow the first result
  const first = await p.locator('#mysearch-list li.active a').first().getAttribute('href');
  r = await p.goto(base + first, { waitUntil: 'networkidle' });
  console.log('open first result', first, '->', r.status(), JSON.stringify(await p.title()));
  // /golang must redirect to /go (nginx.conf: rewrite ^/golang$ /go permanent)
  r = await p.goto(base + '/golang', { waitUntil: 'networkidle' });
  const chain = []; for (let q = r.request().redirectedFrom(); q; q = q.redirectedFrom()) chain.unshift(q.url().replace(base, '') + ' -> ' + (await q.response()).status());
  console.log('GET /golang: chain=', JSON.stringify(chain), 'final', p.url().replace(base, ''), r.status(), JSON.stringify(await p.title()),
    'h2 sections:', await p.locator('.h2-wrap h2').count(), 'code blocks:', await p.locator('pre code').count());
  await p.screenshot({ path: __dirname + '/shot-golang.png' });
  r = await p.goto(base + '/css', { waitUntil: 'networkidle' });
  console.log('GET /css: final', p.url().replace(base, ''), r.status(), JSON.stringify(await p.title()));
  r = await p.goto(base + '/css.html', { waitUntil: 'networkidle' });
  console.log('GET /css.html: final', p.url().replace(base, ''), r.status(), JSON.stringify(await p.title()));
  console.log('responses >= 400 from 127.0.0.1:', JSON.stringify(bad.filter(x => x.includes('127.0.0.1'))));
  console.log('blocked origins:', JSON.stringify([...blocked]));
  console.log('console errors/warnings + page errors (' + errors.length + '):'); errors.forEach(e => console.log('  ' + e.slice(0, 200)));
  await b.close();
})().catch(e => { console.error('FAILED', e); process.exit(1); });
