const synchronize = require("../models/index");

const express = require("express");
const bodyParser = require("body-parser");
const db = require("../models/index");

const app = express();
const Sequelize = require("sequelize");

const { Op } = Sequelize;

const router = express.Router();
const { managers } = require("socket.io-client");
const models = require("../models");

router.get("/getAll", async (req, res) => {
  await db.check();

  models.route
    .findAll({
      include: ["vendingMachines", "employees"],
    })
    .then(async (routes) => {
      const routeList = [];
      routes.forEach((route) => {
        routeList.push(route.dataValues);
      });

      return res.send(routeList);
    });
});

router.post("/addRoute", async (req, res) => {
  await db.check();
  const machines = [];
  for (const machine of req.body.routeMachines) {
    machines.push(
      await models.vendingMachine.findOne({
        where: {
          id: machine.id,
        },
      })
    );
  }
  const employees = [];
  for (const employee of req.body.routeEmployees) {
    employees.push(
      await models.employee.findOne({
        where: {
          id: employee.id,
        },
      })
    );
  }
  await models.route
    .create({
      name: req.body.routeName,
      days: req.body.days,
    })
    .then(async (route) => {
      console.log(route);

      await route.addVendingMachines(machines);
      await route.addEmployees(employees);
      await db.backup();
      res.status(200).json({ result: "route added" });
      return res.send();
    });
});

router.post("/editRoute", async (req, res) => {
  await db.check();
  const machines = [];
  for (const machine of req.body.routeMachines) {
    machines.push(
      await models.vendingMachine.findOne({
        where: {
          id: machine.id,
        },
      })
    );
  }
  const employees = [];
  for (const employee of req.body.routeEmployees) {
    employees.push(
      await models.employee.findOne({
        where: {
          id: employee.id,
        },
      })
    );
  }
  const route = await models.route.findOne({ where: { id: req.body.id } });
  if (route) {
    route
      .update({
        name: req.body.routeName,
        days: req.body.days,
      })
      .then(async (route2) => {
        console.log(route2);

        await route2.setVendingMachines(machines);
        await route2.setEmployees(employees);
        await db.backup();
        res.status(200).json({ result: "route added" });
        return res.send();
      });
  }
});

router.post("/deleteRoute", async (req, res) => {
  await db.check();
  const task = await models.client.findOne({
    where: {
      id: req.body.id,
    },
  });
  console.log(task);
  if (task) {
    await task.destroy().then(async () => {
      await db.backup();
      return res.status(200).json({ result: "client edited" });
    });
  }
});

module.exports = router;
