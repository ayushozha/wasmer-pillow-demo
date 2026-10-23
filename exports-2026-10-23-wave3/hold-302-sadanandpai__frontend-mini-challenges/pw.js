// usage: PLAYWRIGHT_MODULE=<playwright dir> CHROME_PATH=<chromium> node pw.js http://127.0.0.1:PORT
// Only 127.0.0.1 is allowed; every other origin is blocked and counted. Each URL: fresh direct load, then reload.
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const base = process.argv[2], B = base + '/frontend-mini-challenges';
const urls = [
  ['portal (root redirect)', base + '/', '#root'],
  ['portal JS list', B + '/#/javascript', '#root'],
  ['portal leaderboard', B + '/#/leaderboard', '#root'],
  ['CSS accordion', B + '/css/src/challenges/accordion/', 'body'],
  ['JS 25-5-clock', B + '/javascript/src/challenges/25-5-clock/', 'body'],
  ['CSS dialog (index.html form, not linked by the portal)', B + '/css/src/challenges/dialog/index.html', 'body'],
  ['JS atm-simulator', B + '/javascript/src/challenges/atm-simulator/', 'body'],
  ['React counter', B + '/react/#/counter', '#root'],
  ['React anagram-checker', B + '/react/#/anagram-checker', '#root'],
  ['Vue counter', B + '/vue/#/counter', '#app'],
  ['Vue accordion', B + '/vue/#/accordion', '#app'],
  ['Angular counter', B + '/angular/#/counter', 'app-root'],
  ['Angular todo-list', B + '/angular/#/todo-list', 'app-root'],
];
(async () => {
  const b = await chromium.launch({ executablePath: process.env.CHROME_PATH });
  const blockedAll = new Map();
  for (const [name, url, sel] of urls) {
    const ctx = await b.newContext(); const blocked = new Map(), errs = [], bad = [];
    await ctx.route('**/*', r => { const u = new URL(r.request().url());
      if (u.hostname === '127.0.0.1') return r.continue();
      blocked.set(u.origin, (blocked.get(u.origin) || 0) + 1); blockedAll.set(u.origin, (blockedAll.get(u.origin) || 0) + 1); return r.abort(); });
    const p = await ctx.newPage();
    p.on('pageerror', e => errs.push('pageerror: ' + e.message.slice(0, 160)));
    p.on('console', m => { if (m.type() === 'error') errs.push('console.error: ' + m.text().slice(0, 160)); });
    p.on('response', r => { if (r.status() >= 400 && new URL(r.url()).hostname === '127.0.0.1') bad.push(r.status() + ' ' + r.url().replace(base, '')); });
    const snap = async () => p.evaluate(s => { const el = document.querySelector(s);
      return { path: location.pathname + location.hash, title: document.title, children: el ? el.children.length : -1,
        text: (el ? el.innerText : '').replace(/\s+/g, ' ').trim().slice(0, 70), links: document.querySelectorAll('a[href]').length }; }, sel);
    let r1 = await p.goto(url, { waitUntil: 'networkidle' }); await p.waitForTimeout(800); const s1 = await snap();
    let r2 = await p.reload({ waitUntil: 'networkidle' }); await p.waitForTimeout(800); const s2 = await snap();
    console.log(`== ${name}: ${url.replace(base, '')}`);
    console.log(`  load   -> ${r1 && r1.status()} ${JSON.stringify(s1)}`);
    console.log(`  reload -> ${r2 && r2.status()} ${JSON.stringify(s2)}`);
    console.log(`  same-origin >=400: ${bad.length ? bad.join(', ') : 'none'}`);
    console.log(`  blocked origins: ${[...blocked].map(([o, n]) => o + ' (' + n + ')').join(', ') || 'none'}`);
    console.log(`  console/page errors (${errs.length}): ${errs.filter(e => !/ERR_FAILED|net::/.test(e)).join(' | ') || 'only blocked-request errors or none'}`);
    if (name === 'portal JS list') await p.screenshot({ path: __dirname + '/shot-portal.png' });
    if (name === 'React counter') await p.screenshot({ path: __dirname + '/shot-react-counter.png' });
    await ctx.close();
  }
  console.log('ALL blocked origins: ' + [...blockedAll].map(([o, n]) => o + ' (' + n + ')').join(', '));
  await b.close();
})().catch(e => { console.error(e); process.exit(1); });
