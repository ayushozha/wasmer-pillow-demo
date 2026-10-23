// usage: PLAYWRIGHT_MODULE=<playwright dir> CHROME_PATH=<chromium 1194 binary> node pw.js http://127.0.0.1:3932   (Playwright; only 127.0.0.1 allowed, all other origins blocked and recorded)
// Router paths at HEAD (src/routes.tsx): "/" (Home), "/samples" (Samples), "/playground" (dev only, not in production build).
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const base = process.argv[2];
(async () => {
  const b = await chromium.launch({ executablePath: process.env.CHROME_PATH });
  const ctx = await b.newContext();
  const blocked = new Map(), errors = [];
  await ctx.route('**/*', r => { const u = new URL(r.request().url());
    if (u.hostname === '127.0.0.1') return r.continue();
    blocked.set(u.origin, (blocked.get(u.origin) || 0) + 1); return r.abort(); });
  const p = await ctx.newPage();
  p.on('pageerror', e => errors.push('pageerror: ' + e.message));
  p.on('console', m => { if (m.type() === 'error') errors.push('console.error: ' + m.text()); });
  const state = async () => p.evaluate(() => ({ path: location.pathname + location.search,
    input: (document.querySelector('[data-testid=regex-input]') || {}).value ?? null,
    svgs: document.querySelectorAll('main svg, svg').length,
    graphNodes: document.querySelectorAll('svg rect, svg path').length,
    text: document.body.innerText.trim().slice(0, 50).replace(/\s+/g, ' ') }));
  const direct = async (path, label) => {
    const r = await p.goto(base + path, { waitUntil: 'networkidle' });
    await p.waitForTimeout(400);
    console.log(`[direct load] ${label || path} -> HTTP ${r.status()} title="${await p.title()}" ${JSON.stringify(await state())}`);
  };
  await direct('/');
  await direct('/?r=' + encodeURIComponent('/[a-z]+\\d{2,}/'), '/?r=/[a-z]+\\d{2,}/');
  // type a regex on the home page and confirm the URL (?r=) updates and a graph renders
  await p.goto(base + '/', { waitUntil: 'networkidle' });
  await p.fill('[data-testid=regex-input]', 'a|b+'); await p.keyboard.press('Enter'); await p.waitForTimeout(600);
  console.log('[typed "a|b+" on /] ->', JSON.stringify(await state()));
  const typedUrl = p.url().slice(base.length);
  await p.reload({ waitUntil: 'networkidle' }); await p.waitForTimeout(400);
  console.log(`[reload of ${typedUrl}] ->`, JSON.stringify(await state()));
  // in-app navigation to /samples via header link
  await p.goto(base + '/', { waitUntil: 'networkidle' });
  await p.click('header a[href="/samples"]'); await p.waitForTimeout(800);
  const s = await state();
  console.log('[click header Samples link] ->', JSON.stringify({ ...s, sampleLinks: await p.locator('a[href^="/?r="]').count() }));
  await p.locator('a[href^="/?r="]').first().click(); await p.waitForTimeout(600);
  console.log('[click first sample] ->', JSON.stringify(await state()));
  await p.goto(base + '/', { waitUntil: 'networkidle' });
  await p.click('header a[href="/samples"]'); await p.waitForTimeout(500);
  const rr = await p.reload({ waitUntil: 'networkidle' });
  console.log(`[reload while on /samples] -> HTTP ${rr.status()} ${JSON.stringify(await state())}`);
  await direct('/samples'); await direct('/samples/'); await direct('/playground'); await direct('/nope');
  console.log('blocked non-127.0.0.1 origins:', JSON.stringify([...blocked]));
  console.log('page/console errors (' + errors.length + '):'); [...new Set(errors)].forEach(e => console.log('  ' + e.slice(0, 200)));
  await b.close();
})().catch(e => { console.log('FAILED', e.message); process.exit(1); });
