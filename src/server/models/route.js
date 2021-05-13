module.exports = (sequelize, Sequelize) => {
  const route = sequelize.define("route", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
    },
    createdAt: {
      type: Sequelize.DATE,
      defaultValue: sequelize.literal("NOW()"),
    },
    updatedAt: {
      type: Sequelize.DATE,
      defaultValue: sequelize.literal("NOW()"),
    },
    machines: {
      type: Sequelize.STRING,
      defaultValue: "[]",
      get() {
        return JSON.parse(this.getDataValue("machines"));
      },
      set(val) {
        return this.setDataValue("machines", JSON.stringify(val));
      },
    },
    employees: {
      type: Sequelize.STRING,
      defaultValue: "[]",
      get() {
        return JSON.parse(this.getDataValue("employees"));
      },
      set(val) {
        return this.setDataValue("employees", JSON.stringify(val));
      },
    },
  });

  return route;
};
