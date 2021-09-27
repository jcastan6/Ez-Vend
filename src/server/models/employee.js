module.exports = (sequelize, Sequelize) => {
  const employee = sequelize.define("employee", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    username: {
      type: Sequelize.STRING,
      allowNull: false,
      unique: true,
    },
    name: {
      type: Sequelize.STRING,
      allowNull: false,
    },
    isTechnician: {
      type: Sequelize.BOOLEAN,
      allowNull: false,
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

  employee.associate = (models) => {
    employee.belongsTo(models.machineType, {
      as: "machineType",
      onUpdate: "CASCADE",
    });
    employee.belongsTo(models.route, {
      as: "route",
      onUpdate: "CASCADE",
    });
  };

  return employee;
};
