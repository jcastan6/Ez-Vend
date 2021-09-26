const express = require("express");
const bodyParser = require("body-parser");
const { where } = require("sequelize");
const { managers } = require("socket.io-client");
const synchronize = require("../models/index");

const db = require("../models/index");

const app = express();
const Sequelize = require("sequelize");

const sleep = (waitTimeInMs) =>
  new Promise((resolve) => setTimeout(resolve, waitTimeInMs));
const { Op } = Sequelize;

const router = express.Router();
const models = require("../models");
const { sequelize } = require("../models/index");
const { route } = require("./machines-router");

router.get("/getAll", async (req, res) => {
  await db.check();

  models.route
    .findAll({
      include: [{ all: true, nested: true }],
    })
    .then(async (routes) => {
      const routeList = [];

      routes.forEach(async (route) => {
        routeList.push(route.dataValues);
      });

      return res.send(routeList);
    });
});

router.get("/getEmployees", async (req, res) => {
  await db.check();
  models.employee
    .findAll({
      where: {
        routeId: null,
      },
    })
    .then(async (employees) => {
      employeeList = [];
      employees.forEach((employee) => {
        employeeList.push(employee.dataValues);
      });

      return res.send(employeeList);
    });
});

router.post("/addRoute", async (req, res) => {
  await db.check();
  const tasks = [];

  await models.route
    .create({
      name: req.body.routeName,
      days: req.body.days,
    })
    .then(async (route) => {
      console.log(route);

      for (const input of req.body.routeTasks) {
        const task = await models.maintenanceTask.findOne({
          where: {
            id: input.id,
          },
        });

        tasks.push(task);
      }

      const employees = [];
      for (const e of req.body.routeEmployees) {
        const employee = await models.employee.findOne({
          where: {
            id: e.id,
          },
        });
        employees.push(employee);
        employee.setRoute(route);
      }

      await route.addMaintenanceTasks(tasks);
      await route.addEmployees(employees);

      await db.backup();
      res.status(200).json({ result: "route added" });
      return res.send();
    });
});

router.post("/editRoute", async (req, res) => {
  await db.check();

  const route = await models.route.findOne({
    where: { id: req.body.id },
    include: [{ all: true, nested: true }],
  });
  if (route) {
    route.update({
      name: req.body.routeName,
      days: req.body.days,
    });
  }

  await route.setMaintenanceTasks([]);
  let i = 0;
  if (req.body.routeTasks) {
    for (input of req.body.routeTasks) {
      await sequelize.query(
        `INSERT INTO employeeTasks (createdAt, updatedAt, routeId,maintenanceTaskId, priority) VALUES (NOW(), NOW(),'${route.dataValues.id}','${req.body.routeTasks[i].id}', ${i});`
      );
      console.log("\n\n");
      await i++;
    }
  }

  const employees = [];
  const x = await route.getEmployees();
  for (element of x) {
    await element.setRoute(null);
  }
  for (const employee of req.body.routeEmployees) {
    const employee2 = await models.employee.findOne({
      where: {
        id: employee.id,
      },
    });
    employees.push(employee2);
    employee2.setRoute(route);
  }

  await route.setEmployees(employees);

  await db.backup();
  res.status(200).json({ result: "route added" });
  return res.send();
});

router.post("/deleteRoute", async (req, res) => {
  await db.check();
  console.log(req.body);
  const route = await models.route.findOne({
    where: {
      id: req.body.id,
    },
  });

  if (route) {
    await route.destroy().then(async () => {
      await db.backup();
      return res.status(200).json({ result: "route deleted" });
    });
  }
});

module.exports = router;
