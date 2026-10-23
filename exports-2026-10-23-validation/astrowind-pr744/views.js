// Visual checks per AGENTS.md "homepage, blog, dark mode, mobile menu". Usage: node views.js <base> <outdir> <label>
const { chromium } = require('/opt/node-tools/node_modules/playwright');
const [base, out, label] = process.argv.slice(2);
(async () => {
  const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
  const views = [
    { name: 'home', path: '/', vp: { width: 1280, height: 800 } },
    { name: 'blog-index', path: '/blog', vp: { width: 1280, height: 800 }, noShot: true },
    { name: 'blog-post', path: '/get-started-website-with-astro-tailwind-css', vp: { width: 1280, height: 800 } },
    { name: 'dark-toggle', path: '/', vp: { width: 1280, height: 800 }, toggleDark: true },
    { name: 'dark-pcs', path: '/', vp: { width: 1280, height: 800 }, scheme: 'dark', noShot: true },
    { name: 'mobile-menu', path: '/', vp: { width: 390, height: 844 }, mobile: true },
  ];
  const results = [];
  for (const v of views) {
    const ctx = await browser.newContext({ viewport: v.vp, colorScheme: v.scheme || 'light', isMobile: !!v.mobile, hasTouch: !!v.mobile, deviceScaleFactor: 1 });
    const page = await ctx.newPage();
    const blocked = new Set(), consoleErrors = [], pageErrors = [], failed = [];
    await page.route('**/*', r => { const u = new URL(r.request().url()); if (u.hostname !== '127.0.0.1') { blocked.add(u.origin); return r.abort(); } return r.continue(); });
    page.on('console', m => { if (m.type() === 'error') consoleErrors.push(m.text().slice(0, 300)); });
    page.on('pageerror', e => pageErrors.push(String(e).slice(0, 300)));
    page.on('requestfailed', r => { const u = new URL(r.url()); if (u.hostname === '127.0.0.1') failed.push(u.pathname + ' ' + (r.failure() || {}).errorText); });
    const res = { view: v.name, url: base + v.path, viewport: `${v.vp.width}x${v.vp.height}` };
    try {
      const resp = await page.goto(base + v.path, { waitUntil: 'load', timeout: 120000 });
      res.status = resp ? resp.status() : null;
      res.title = await page.title();
      if (v.toggleDark) {
        const btn = page.locator('[data-aw-toggle-color-scheme]:visible').first();
        res.toggleFound = await btn.count();
        if (res.toggleFound) { await btn.click(); await page.waitForTimeout(400); }
      }
      if (v.mobile) {
        const m = page.locator('[data-aw-toggle-menu]:visible').first();
        res.menuButtonFound = await m.count();
        if (res.menuButtonFound) { await m.click(); await page.waitForTimeout(400); res.menuAriaExpanded = await m.getAttribute('aria-expanded'); }
        res.horizontalOverflow = await page.evaluate(() => document.documentElement.scrollWidth > window.innerWidth);
      }
      res.htmlHasDarkClass = await page.evaluate(() => document.documentElement.classList.contains('dark'));
      res.bodyBg = await page.evaluate(() => getComputedStyle(document.body).backgroundColor);
      res.h1 = await page.evaluate(() => (document.querySelector('h1') || {}).textContent?.trim().slice(0, 80) || null);
      if (!v.noShot) {
        const f = `${out}/shot-${label}-${v.name}.png`;
        await page.screenshot({ path: f, fullPage: false });
        res.screenshot = f.split('/').pop();
      }
    } catch (e) { res.error = String(e).slice(0, 300); }
    Object.assign(res, { consoleErrors, pageErrors, failedLocalRequests: failed, blockedOrigins: [...blocked].sort() });
    results.push(res);
    await ctx.close();
  }
  await browser.close();
  console.log(JSON.stringify(results, null, 1));
})();
