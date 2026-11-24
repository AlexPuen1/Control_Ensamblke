// Lee la tabla de Ignition con un Edge/Chrome oculto y la sirve en http://localhost:3000
const http = require("http");
const fs = require("fs");
const path = require("path");
const { chromium } = require("playwright-core");

const SOURCE = process.env.SOURCE_URL || "http://est01ignition:8088/data/perspective/client/Control_ENSAMBLE/cobot";
const PORT = Number(process.env.PORT) || 3000;
const CHANNEL = process.env.BROWSER || "msedge"; // o "chrome"
const EVERY_MS = 10000;

let state = { ok: false, error: "Cargando datos…", stamp: null, hours: [], groups: [] };

// Corre dentro de la página: convierte las filas de la tabla en {hours, groups}.
function readTable() {
  const hours = [...document.querySelectorAll("*")]
    .filter(e => e.children.length === 0 && /^H \d\d$/.test(e.textContent.trim()))
    .map(e => e.textContent.trim().slice(2).trim());
  const groups = [];
  for (const r of document.querySelectorAll(".tr-group")) {
    const cells = r.innerText.split("\n").map(s => s.trim()).filter(Boolean);
    if (!cells.length) continue;
    if (!cells[0].startsWith("↳")) { groups.push({ name: cells[0], lines: [] }); continue; }
    if (!groups.length) continue;
    const nums = cells.slice(1).map(Number);
    if (nums.length < 2 || nums.some(Number.isNaN)) continue;
    groups[groups.length - 1].lines.push({ n: cells[0].replace(/^↳\s*/, ""), m: nums[0], v: nums.slice(1) });
  }
  return { hours: [...new Set(hours)], groups: groups.filter(g => g.lines.length) };
}

async function loop() {
  const browser = await chromium.launch({ channel: CHANNEL, headless: true });
  const page = await browser.newPage({ viewport: { width: 1400, height: 1800 } }); // alto para que se dibujen todas las filas
  const load = () => page.goto(SOURCE, { waitUntil: "domcontentloaded", timeout: 30000 });
  for (;;) {
    try {
      if (page.url() === "about:blank") { await load(); await page.waitForSelector(".tr-group", { timeout: 30000 }); }
      const t = await page.evaluate(readTable);
      const rows = t.groups.reduce((a, g) => a + g.lines.length, 0);
      if (!rows || t.groups.some(g => g.lines.some(l => l.v.length !== t.hours.length))) throw new Error("La tabla no tiene el formato esperado");
      state = { ok: true, stamp: new Date().toLocaleString("es-MX"), ...t };
    } catch (e) {
      state = { ...state, ok: false, error: e.message };
      await page.goto("about:blank").catch(() => {}); // fuerza recarga completa en el siguiente ciclo
    }
    await new Promise(r => setTimeout(r, EVERY_MS));
  }
}

const INDEX = path.join(__dirname, "public", "index.html");
http.createServer((req, res) => {
  const url = req.url.split("?")[0];
  if (url === "/api/data") {
    res.writeHead(200, { "Content-Type": "application/json", "Cache-Control": "no-store" });
    return res.end(JSON.stringify(state));
  }
  if (url === "/" || url === "/index.html") {
    res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
    return fs.createReadStream(INDEX).pipe(res);
  }
  res.writeHead(404).end("No encontrado");
}).listen(PORT, "127.0.0.1", () => console.log(`Dashboard en http://localhost:${PORT}`));

loop().catch(e => { console.error(e); process.exit(1); });
