// Harmless DOM probe for pev2 Plan.vue invalid-plan branch (v-html="planSource").
// Serves nothing itself; expects the replayed build at http://127.0.0.1:4154/ . All non-localhost requests are aborted.
const { chromium } = require('/opt/node-tools/node_modules/playwright');
(async () => {
  const out = { url: 'http://127.0.0.1:4154/', input: 'not a plan <b data-wasmer-marker="probe">marker</b>', aborted: [] };
  const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome', args: ['--no-sandbox'] });
  const page = await browser.newPage();
  await page.route('**/*', r => {
    const u = new URL(r.request().url());
    if (u.hostname === '127.0.0.1' || u.protocol === 'data:' || u.protocol === 'blob:') return r.continue();
    out.aborted.push(r.request().url()); return r.abort();
  });
  await page.goto(out.url, { waitUntil: 'load' });
  await page.fill('#planInput', out.input);
  await page.locator('form button[type=submit]').first().click();
  await page.waitForSelector('text=Couldn\'t parse plan', { timeout: 15000 }).then(() => out.errorCardShown = true, () => out.errorCardShown = false);
  out.markerElementCount = await page.locator('[data-wasmer-marker]').count();
  out.markerTag = out.markerElementCount ? await page.locator('[data-wasmer-marker]').first().evaluate(e => e.tagName + ' text=' + e.textContent) : null;
  out.codeInnerHTML = await page.evaluate(() => { const c = document.querySelector('pre code'); return c ? c.innerHTML : null; });
  out.codeTextContent = await page.evaluate(() => { const c = document.querySelector('pre code'); return c ? c.textContent : null; });
  out.reinterpretedAsHTML = out.markerElementCount > 0;
  console.log(JSON.stringify(out, null, 2));
  await browser.close();
})();
