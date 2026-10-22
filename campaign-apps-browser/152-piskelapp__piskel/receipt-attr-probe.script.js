// Local, DOM-only probe of piskel's Template.sanitize behaviour in quoted attributes.
// Harmless marker payload; no script, no network beyond 127.0.0.1 (everything else aborted).
const { chromium } = require('/opt/node-tools/node_modules/playwright');
(async () => {
  const base = process.argv[2];
  const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium-1194/chrome-linux/chrome' });
  const page = await browser.newPage();
  const blocked = [];
  await page.route('**/*', (route) => {
    const u = new URL(route.request().url());
    if (u.hostname === '127.0.0.1') return route.continue();
    blocked.push(u.origin); return route.abort();
  });
  await page.goto(base + '/', { waitUntil: 'load' });
  await page.waitForFunction(() => window.pskl && pskl.utils && pskl.utils.Template, null, { timeout: 30000 });
  const payload = 'x" data-wasmer-marker="probe';
  const result = await page.evaluate((payload) => {
    const T = pskl.utils.Template;
    const out = { payload, sanitized: T.sanitize(payload) };
    const inspect = (html, sel) => {
      const host = document.createElement('div');          // detached: never attached to the document
      host.innerHTML = html;
      const el = sel ? host.querySelector(sel) : host.firstElementChild;
      return { html, attrs: el ? Array.from(el.attributes).map(a => a.name + '=' + JSON.stringify(a.value)) : null,
               markerAttrPresent: el ? el.hasAttribute('data-wasmer-marker') : null };
    };
    // 1) the generic replace path with a quoted attribute
    out.generic = inspect(T.replace('<span title="{{name}}">{{name}}</span>', { name: payload }));
    // 2) the real import dialog template (templates/dialogs/import.html:90)
    try {
      out.importMeta = inspect(T.getAndReplace('import-meta-content', { name: payload, dimensions: '1x1', frames: 1, layers: 1 }), '.import-meta-value');
    } catch (e) { out.importMeta = 'template not found: ' + e.message; }
    // 3) the real layer rename input (templates/layers-list.html:80): find the template containing layer-name-input
    const tplId = Array.from(document.querySelectorAll('script[type="text/template"]')).map(s => s.id)
      .find(id => (T.get(id) || '').includes('layer-name-input'));
    out.layerTemplateId = tplId || null;
    if (tplId) out.layerInput = inspect(T.replace(T.get(tplId), { layername: payload, layerindex: 0, isselected: false, opacity: 1 }), '.layer-name-input');
    return out;
  }, payload);
  result.blockedOrigins = [...new Set(blocked)];
  console.log(JSON.stringify(result, null, 2));
  await browser.close();
})().catch((e) => { console.error(e); process.exit(1); });
