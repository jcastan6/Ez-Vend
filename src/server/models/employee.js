module.exports = (sequelize, Sequelize) => {
  const employee = sequelize.define("employee", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true,
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
  };

  return employee;
};
