module.exports = (sequelize, Sequelize) => {
  const machineType = sequelize.define("machineType", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    type: {
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
  });
  machineType.associate = (models) => {
    machineType.hasMany(models.maintenanceTask, {
      as: "tasks",
      onUpdate: "CASCADE",
      onDelete: "CASCADE",
    });
  };
  return machineType;
};
