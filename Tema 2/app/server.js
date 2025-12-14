const express = require("express");
const sql = require("mssql");

const app = express();

const path = require("path");
app.use(express.static(path.join(__dirname, "public")));
app.use(express.json());

const dbConfig = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_NAME,
  options: {
    encrypt: true
  }
};

app.get("/api/items", async (req, res) => {
  const pool = await sql.connect(dbConfig);
  const result = await pool.request().query("SELECT text FROM Items ORDER BY id DESC");
  res.json(result.recordset);
});

app.post("/api/items", async (req, res) => {
  const pool = await sql.connect(dbConfig);
  await pool.request()
    .input("text", sql.NVarChar, req.body.text)
    .query("INSERT INTO Items (text) VALUES (@text)");
  res.sendStatus(201);
});

const port = process.env.PORT || 3000;
app.listen(port);

