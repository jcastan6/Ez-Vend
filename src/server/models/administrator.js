module.exports = (sequelize, Sequelize) => {
  const administrator = sequelize.define("administrator", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    employeeId: {
      type: Sequelize.INTEGER,
      allowNull: false,
      references: {
        model: "employees",
        key: "id"
      },
      onUpdate: "CASCADE",
      onDelete: "CASCADE"
    },
    createdAt: {
      type: Sequelize.DATE,
      defaultValue: sequelize.literal("NOW()")
    },
    updatedAt: {
      type: Sequelize.DATE,
      defaultValue: sequelize.literal("NOW()")
    }
  });
  return administrator;
};
