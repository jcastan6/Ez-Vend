/* eslint-disable arrow-parens */
/* eslint-disable quotes */
const bcrypt = require("bcrypt");

module.exports = (sequelize, Sequelize) => {
  const secret = sequelize.define("secret", {
    password: {
      type: Sequelize.STRING,
      allowNull: false,
      primaryKey: true,
    },
  });

  bcrypt.hash("californiavendingmexico", 10).then((hash) => {
    const admins = [
      {
        password: hash,
      },
    ];

    secret.bulkCreate(admins).catch();
  });

  secret.prototype.comparePassword = async function (password) {
    return await bcrypt.compare(password, this.password);
  };

  return secret;
};
