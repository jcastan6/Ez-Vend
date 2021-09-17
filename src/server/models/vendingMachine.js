const bcrypt = require("bcrypt");

module.exports = (sequelize, Sequelize) => {
  const vendingMachine = sequelize.define("vendingMachine", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    machineNo: {
      type: Sequelize.INTEGER,
    },
    serialNo: {
      type: Sequelize.STRING,
      allowNull: true,
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
    vendingMachine.belongsTo(models.machineType, {
      as: "type",
      onUpdate: "CASCADE",
    });

    vendingMachine.hasMany(models.maintenanceLog, {
      as: "maintenances",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });

    vendingMachine.hasMany(models.maintenanceReport, {
      as: "reports",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });
  };
  return vendingMachine;
};
