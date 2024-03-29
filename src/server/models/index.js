const fs = require("fs");
const path = require("path");
const Sequelize = require("sequelize");
const mysql = require("mysql2/promise");
const mysqldump = require("mysqldump");
const execSQL = require("exec-sql");

const basename = path.basename(__filename);
const env = process.env.NODE_ENV || "development";
const config = require(`${__dirname}/../config/config.json`)[env];
const db = {};

let dbConnection;

mysql
  .createConnection({
    user: config.username,
    password: config.password,
  })
  .then((connection) => {
    dbConnection = connection;
    db.check();
  });

if (config.use_env_variable) {
  var sequelize = new Sequelize(process.env[config.use_env_variable], config);
} else {
  var sequelize = new Sequelize(
    config.database,
    config.username,
    config.password,
    {
      host: "localhost",
      dialect: "mysql",
    }
  );
}

fs.readdirSync(__dirname)
  .filter(
    (file) =>
      file.indexOf(".") !== 0 && file !== basename && file.slice(-3) === ".js"
  )
  .forEach((file) => {
    const model = sequelize.import(path.join(__dirname, file));
    db[model.name] = model;
  });

Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;

db.backup = () => {
  mysqldump({
    connection: {
      host: "localhost",
      user: config.username,
      password: config.password,
      database: config.database,
    },
    dumpToFile: "./dump.sql",
  });
};

db.check = async () => {
  console.log("db checked");
};
module.exports = db;
