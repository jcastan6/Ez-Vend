// keeps track of tasks done/completed, who completed them

module.exports = (sequelize, Sequelize) => {
  const maintenanceHistory = sequelize.define("maintenanceHistory", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    createdAt: {
      type: Sequelize.DATE,
      defaultValue: sequelize.literal("NOW()"),
    },
    updatedAt: {
      type: Sequelize.DATE,
      defaultValue: sequelize.literal("NOW()"),
    },
    image: {
      type: Sequelize.STRING,
      defaultValue: null,
    },
    notes: {
      type: Sequelize.STRING,
      defaultValue: null,
    },
  });

  maintenanceHistory.associate = (models) => {
    models.maintenanceHistory.belongsTo(models.maintenanceTask, {
      as: "maintenance",
      onUpdate: "CASCADE",
    });
    models.maintenanceHistory.belongsTo(models.employee, {
      as: "employee",
      onUpdate: "CASCADE",
    });
  };
  return maintenanceHistory;
};
