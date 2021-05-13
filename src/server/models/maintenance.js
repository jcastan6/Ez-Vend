// a maintenance done by the employee on a route

const { default: main } = require("mysqldump");

module.exports = (sequelize, Sequelize) => {
  const maintenance = sequelize.define("maintenance", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
    },
    daysCount: {
      type: Sequelize.INTEGER,
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

  maintenance.associate = (models) => {
    maintenance.hasOne(models.employee, {
      as: "employees",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });
  };
  return maintenance;
};
