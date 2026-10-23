// usage: node browser.cjs BASE OUTDIR  (based on the PR2082 validation script; adds /view/, /embed/ and a query-string entry)
const { chromium } = require('/opt/node-tools/node_modules/playwright');
const [BASE, OUT] = process.argv.slice(2);
(async () => {
  const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
  const ctx = await browser.newContext({ viewport: { width: 1280, height: 800 } });
  const blocked = {}; const res = [];
  await ctx.route('**/*', r => { const u = new URL(r.request().url());
    if (u.hostname === '127.0.0.1') return r.continue();
    blocked[u.origin] = (blocked[u.origin] || 0) + 1; return r.abort(); });
  const svgSel = '#container svg[id^="graph"], #container svg, svg[aria-roledescription]';
  async function visit(path, opts = {}) {
    const page = await ctx.newPage(); const errs = []; const failed = [];
    page.on('console', m => { if (m.type() === 'error') errs.push(m.text().slice(0, 300)); });
    page.on('pageerror', e => errs.push('pageerror: ' + String(e).slice(0, 300)));
    page.on('requestfailed', q => { if (new URL(q.url()).hostname === '127.0.0.1') failed.push(q.url()); });
    const bad = []; page.on('response', r => { if (r.status() >= 400 && new URL(r.url()).hostname === '127.0.0.1') bad.push(r.status() + ' ' + r.url()); });
    const resp = await page.goto(BASE + path, { waitUntil: 'load', timeout: 60000 });
    let svg = null;
    try { await page.waitForSelector('svg[aria-roledescription]', { timeout: 30000 });
      svg = await page.$eval('svg[aria-roledescription]', e => ({ id: e.id, role: e.getAttribute('aria-roledescription'), nodes: e.querySelectorAll('g.node, g.nodes > g').length, textlen: e.textContent.length })); } catch (e) { svg = 'NO DIAGRAM SVG within 30s'; }
    await page.waitForTimeout(1500);
    const r = { path, status: resp && resp.status(), finalUrl: page.url().replace(BASE, ''), title: await page.title(), svg, sameOriginHttpErrors: bad, sameOriginFailed: failed, consoleErrors: errs };
    if (opts.shot) await page.screenshot({ path: `${OUT}/${opts.shot}`, type: 'png' });
    res.push(r); await page.close(); return page.url();
  }
  const editUrl = await visit('/edit', { shot: 'shot-edit.png' });
  const hash = new URL(editUrl).hash;
  res.push({ sampleStateFromEdit: hash.slice(0, 40) + '... (len ' + hash.length + ')' });
  await visit('/view' + hash, { shot: 'shot-view.png' });
  await visit('/embed' + hash, { shot: 'shot-embed.png' });
  await visit('/');
  await visit('/edit/' + hash);
  await visit('/view/' + hash);
  await visit('/embed/' + hash);
  await visit('/edit?x=1' + hash);
  await visit('/definitely-missing-q9z');
  res.push({ blockedExternalOrigins: blocked });
  console.log(JSON.stringify(res, null, 1));
  await browser.close();
})();
