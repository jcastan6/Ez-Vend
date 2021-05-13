/* eslint-disable arrow-parens */
/* eslint-disable quotes */
const bcrypt = require("bcrypt");

module.exports = (sequelize, Sequelize) => {
  const account = sequelize.define(
    "account",
    {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      email: {
        type: Sequelize.STRING(45),
        allowNull: false,
        unique: true
      },
      businessName: {
        type: Sequelize.STRING(45),
        allowNull: false,
        unique: true
      },
      password: {
        type: Sequelize.STRING(255),
        allowNull: false
      },
      createdAt: {
        type: Sequelize.DATE,
        defaultValue: sequelize.literal("NOW()")
      },
      updatedAt: {
        type: Sequelize.DATE,
        defaultValue: sequelize.literal("NOW()")
      }
    },
    {
      hooks: {
        beforeCreate: (account, options) =>
          bcrypt
            .hash(account.password, 10)
            .then(hash => {
              account.password = hash;
            })
            .catch(err => {
              throw new Error();
            })
      }
    }
  );

  account.associate = models => {
    account.hasMany(models.client, {
      as: "clients",
      onUpdate: "CASCADE",
      onDelete: "CASCADE"
    });
    account.hasMany(models.vendingMachine, {
      as: "vendingMachines",
      onUpdate: "CASCADE",
      onDelete: "CASCADE"
    });
    account.hasMany(models.employee, {
      as: "employees",
      onUpdate: "CASCADE",
      onDelete: "CASCADE"
    });
  };

  // bcrypt.hash("admin123", 10).then(hash => {
  //   const admins = [
  //     {
  //       email: "admin@administrator.com",
  //       password: hash,
  //       businessName: "adminbusiness"
  //     }
  //   ];

  //   account.bulkCreate(admins).catch();
  // });

  account.prototype.comparePassword = async function(password) {
    return await bcrypt.compare(password, this.password);
  };

  return account;
};
