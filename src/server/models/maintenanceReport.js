const bcrypt = require("bcrypt");

// reports for corrective maintenances to-do (emergency repairs etc)
module.exports = (sequelize, Sequelize) => {
  const maintenanceReport = sequelize.define("maintenanceReport", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    task: {
      type: Sequelize.STRING,
      allowNull: false,
    },
    priority: {
      type: Sequelize.INTEGER,
      defaultValue: 0,
    },
    completed: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    },
    createdAt: {
      type: Sequelize.DATE,
      defaultValue: sequelize.literal("NOW()"),
    },
    updatedAt: {
      type: Sequelize.DATE,
      defaultValue: sequelize.literal("NOW()"),
    },
  });

  maintenanceReport.associate = (models) => {
    maintenanceReport.belongsTo(models.employee, {
      as: "employee",
      onUpdate: "CASCADE",
    });
  };
  return maintenanceReport;
};
