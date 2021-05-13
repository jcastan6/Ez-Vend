// repeating tasks with an optionally scheduled reminder, this is the definition of the task
const { UUIDV4, UUIDV1, MACADDR } = require("sequelize");

module.exports = (sequelize, Sequelize) => {
  const maintenanceTask = sequelize.define("maintenanceTask", {
    id: {
      type: Sequelize.UUID,
      primaryKey: true,
      defaultValue: UUIDV4(),
    },
    task: {
      type: Sequelize.STRING,
    },
    recurring: {
      type: Sequelize.BOOLEAN,
    },
    reminderCount: {
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
    maintenanceTask.hasMany(models.maintenance, {
      as: "tasks",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });
  };
  return maintenanceTask;
};
