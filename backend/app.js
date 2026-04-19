const express = require("express");
const cors = require("cors");

const authRoutes = require("./routes/auth");
const playerRoutes = require("./routes/player");
const gameRoutes = require("./routes/game");
const actionRoutes = require("./routes/action");
const rebirthRoutes = require("./routes/rebirth");
const ascensionRoutes = require("./routes/ascension");
const worldRoutes = require("./routes/world");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({ message: "Deep Saga backend is running" });
});

app.use("/api/auth", authRoutes);
app.use("/api/player", playerRoutes);
app.use("/api/game", gameRoutes);
app.use("/api/action", actionRoutes);
app.use("/api/rebirth", rebirthRoutes);
app.use("/api/ascension", ascensionRoutes);
app.use("/api/world", worldRoutes);

module.exports = app;
