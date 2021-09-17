module.exports = (sequelize, Sequelize) => {
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

    days: {
      type: Sequelize.STRING,
      defaultValue: "[]",
      get() {
        return JSON.parse(this.getDataValue("days"));
      },
      set(val) {
        return this.setDataValue("days", JSON.stringify(val));
      },
    },
  });
  route.associate = (models) => {
    route.belongsToMany(models.employee, {
      through: "employeeRoutes",
      onUpdate: "CASCADE",
    });
    route.belongsToMany(models.vendingMachine, {
      through: "machineRoutes",
      onUpdate: "CASCADE",
    });
  };

  return route;
};
