// keeps track of to/do maintenances. Scheduled or emergency

module.exports = (sequelize, Sequelize) => {
  const maintenanceTask = sequelize.define("maintenanceTask", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    task: {
      type: Sequelize.STRING,
    },
    emergency: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    },
    completed: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    },
    daysCount: {
      type: Sequelize.INTEGER,
      defaultValue: 0,
      allowNull: true,
    },
    pastDue: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    },
    reminderAt: {
      type: Sequelize.INTEGER,
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
  });

  maintenanceTask.associate = (models) => {
    maintenanceTask.belongsTo(models.employee, {
      as: "employees",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });
    maintenanceTask.belongsTo(models.route, {
      as: "route",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });
    maintenanceTask.belongsTo(models.vendingMachine, {
      as: "vendingMachine",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });
  };
  return maintenanceTask;
};
