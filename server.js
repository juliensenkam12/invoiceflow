const http = require('http');

http.createServer((req, res) => {
  res.end("InvoiceFlow Running");
}).listen(3000);
