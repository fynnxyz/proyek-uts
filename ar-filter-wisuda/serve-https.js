const fs = require('node:fs');
const https = require('node:https');
const path = require('node:path');

const root = path.resolve(process.env.AR_HTTPS_ROOT);
const pfx = process.env.AR_HTTPS_PFX;
const password = process.env.AR_HTTPS_PASSWORD;
const port = 8443;
const contentTypes = {
  '.css': 'text/css; charset=utf-8',
  '.glb': 'model/gltf-binary',
  '.html': 'text/html; charset=utf-8',
  '.jpeg': 'image/jpeg',
  '.jpg': 'image/jpeg',
  '.js': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.svg': 'image/svg+xml'
};

if (!root || !pfx || !password) {
  throw new Error('AR_HTTPS_ROOT, AR_HTTPS_PFX, dan AR_HTTPS_PASSWORD wajib diisi.');
}

const server = https.createServer(
  { pfx: fs.readFileSync(pfx), passphrase: password },
  (request, response) => {
    let pathname;
    try {
      pathname = decodeURIComponent(new URL(request.url, 'https://localhost').pathname);
    } catch {
      response.writeHead(400).end('Bad request');
      return;
    }

    if (pathname === '/') pathname = '/index.html';
    const file = path.resolve(root, `.${pathname}`);
    if (file !== root && !file.startsWith(`${root}${path.sep}`)) {
      response.writeHead(403).end('Forbidden');
      return;
    }

    fs.stat(file, (error, stats) => {
      if (error || !stats.isFile()) {
        response.writeHead(404).end('Not found');
        return;
      }

      response.writeHead(200, {
        'Content-Length': stats.size,
        'Content-Type': contentTypes[path.extname(file).toLowerCase()] || 'application/octet-stream'
      });
      fs.createReadStream(file).pipe(response);
    });
  }
);

server.on('error', error => {
  console.error('Server HTTPS gagal:', error.message);
  process.exitCode = 1;
});

server.listen(port, '0.0.0.0', () => {
  console.log(`HTTPS server berjalan di port ${port}. Tekan Ctrl+C untuk berhenti.`);
});
