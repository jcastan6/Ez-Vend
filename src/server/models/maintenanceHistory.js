// individual maintenance tracker. Each machine has one for each of it's specified tasks.
// Keeps track of how many days have passed since task was last done

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
  });

  maintenanceHistory.associate = (models) => {
    maintenanceHistory.hasOne(models.employee, {
      as: "employee",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });
  };
  return maintenanceHistory;
};
