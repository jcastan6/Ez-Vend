// individual maintenance tracker. Each machine has one for each of it's specified tasks.
// Keeps track of how many days have passed since task was last done

module.exports = (sequelize, Sequelize) => {
  const maintenanceLog = sequelize.define("maintenanceLog", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    daysCount: {
      type: Sequelize.INTEGER,
      defaultValue: 0,
    },
    pastDue: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    },
    reminderAt: {
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

  maintenanceLog.associate = (models) => {
    maintenanceLog.belongsTo(models.employee, {
      as: "employees",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });
  };
  return maintenanceLog;
};
