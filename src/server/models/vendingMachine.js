const bcrypt = require("bcrypt");

module.exports = (sequelize, Sequelize) => {
  const vendingMachine = sequelize.define("vendingMachine", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    serialNo: {
      type: Sequelize.STRING,
    },
    createdAt: {
      type: Sequelize.DATE,
      defaultValue: sequelize.literal("NOW()"),
    },
    updatedAt: {
      type: Sequelize.DATE,
      defaultValue: sequelize.literal("NOW()"),
    },
    model: {
      type: Sequelize.STRING,
    },
  });

  vendingMachine.associate = (models) => {
    vendingMachine.belongsTo(models.client, {
      as: "client",
      onUpdate: "CASCADE",
    });
    vendingMachine.hasOne(models.machineType, {
      as: "type",
      onUpdate: "CASCADE",
    });

    vendingMachine.hasMany(models.maintenance, {
      as: "maintenances",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });
  };
  return vendingMachine;
};
