module.exports = (sequelize, Sequelize) => {
  const tasks = sequelize.define("employeeTasks", {
    priority: {
      type: Sequelize.INTEGER,
    },
  });
  const route = sequelize.define("route", {
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
    name: {
      type: Sequelize.STRING,
      allowNull: false,
    },
  });
  route.associate = (models) => {
    route.belongsToMany(models.employee, {
      through: "employeeRoutes",
    });
    route.belongsToMany(models.maintenanceTask, {
      through: tasks,
      onUpdate: "CASCADE",
    });
  };

  return route;
};
