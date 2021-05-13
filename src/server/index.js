const express = require("express");
const fileUpload = require("express-fileupload");
const os = require("os");
const path = require("path");
const sequelize = require("sequelize");
const cors = require("cors");
const io = require("socket.io")();
const bodyParser = require("body-parser");
const userRouter = require("./routes/users-router");
const productRouter = require("./routes/products-router");
const machinesRouter = require("./routes/machines-router");
const clientsRouter = require("./routes/clients-router");

const app = express();

app.use(
  fileUpload({
    createParentPath: true,
  })
);

io.listen(8080);
app.set("socketio", io);

io.of("/lobby").on("connection", (socket) => {
  socket.on("subscribeToChat", (msg) => {
    io.of("/lobby").emit("message", msg);
  });
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());
app.use(express.static("dist"));

app.set("view engine", "ejs");
app.listen(4000, () => console.log("Listening on port 4000!"));

app.use("/users", userRouter);
app.use("/clients", clientsRouter);
app.use("/products", productRouter);
app.use("/machines", machinesRouter);

app.use((err, req, res, next) => {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render("error");
});

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "/../../dist/index.html"), (err) => {
    if (err) {
      res.status(500).send(err);
    }
  });
});

module.exports = app;
