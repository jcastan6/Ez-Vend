/* eslint-disable linebreak-style */
const express = require("express");
const bodyParser = require("body-parser");

const app = express();
const Sequelize = require("sequelize");
const db = require("../models/index");
const { Op } = Sequelize;

const router = express.Router();
const models = require("../models");

router.put("/userSearch", async (req, res) => {
  await db.check();
  if (req.body.userid !== null || req.body.userid !== "") {
    models.user
      .findAll({
        raw: true,
        where: {
          userid: {
            [Op.like]: `%${req.body.userid}%`,
          },
        },
      })
      .then((users) => {
        console.log(users);
        res.send(users);
      })
      .catch((error) => {
        res.status(500).send(error);
      });
  } else {
    models.user
      .findAll({
        raw: true,
      })
      .then((users) => {
        console.log(users);
        res.send(JSON.stringify(users));
      })
      .catch((error) => {
        res.status(500).send(error);
      });
  }
});

router.post("/login", async (req, res) => {
  await db.check();
  models.account
    .findOne({
      where: {
        email: req.body.userid,
      },
    })
    .then(async (user) => {
      if (!user || !(await user.comparePassword(req.body.password))) {
        res.status(401).json({ token: null, errorMessage: "failed!" });
      } else {
        user.password = true;
        res.send(user.dataValues);
      }
    });
});

router.get("/getEmployees", async (req, res) => {
  await db.check();
  models.employee.findAll().then(async (employees) => {
    employeeList = [];
    employees.forEach((employee) => {
      employeeList.push(employee.dataValues);
    });

    return res.send(employeeList);
  });
});

router.post("/register", async (req, res, next) => {
  await db.check();
  models.user
    .findOne({
      where: {
        userid: req.body.userid,
      },
    })
    .then(async (user) => {
      // if userId is already being used
      if (user) {
        return res.status(400).json({ result: "User id is already used." });
      }

      models.user.create({
        userid: req.body.userid,
        email: req.body.email,
        password: req.body.password,
        sessionToken: null,
      });
      db.backup();
      return res.status(200).json({ result: "user created" });
    });
});

router.post("/addEmployee", async (req, res) => {
  await db.check();
  console.log(req.body);
  let machineType;
  if (req.body.isTechincian === true) {
    machineType = await models.machineType.findOne({
      where: {
        type: req.body.type,
      },
    });
  }

  models.employee
    .create({
      name: req.body.name,
      isTechnician: req.body.isTechnician,
    })
    .then(async (employee) => {
      if (req.body.isTechnician === true) {
        await employee.setMachineType(machineType);
      }
      await db.backup();
      return res.send(employee.dataValues);
    });
});

router.post("/editEmployee", async (req, res) => {
  await db.check();

  let machineType;
  if (req.body.isTechnician === true) {
    machineType = await models.machineType.findOne({
      where: {
        type: req.body.type,
      },
    });
  }

  const employee = await models.employee.findOne({
    where: {
      id: req.body.id,
    },
  });

  if (employee) {
    await employee
      .update({
        name: req.body.name,
        isTechnician: req.body.isTechnician,
      })
      .then(async () => {
        if (req.body.isTechnician === true) {
          await employee.setMachineType(machineType);
        } else {
          await employee.setMachineType(null);
        }
        await db.backup();
        return res.status(200).json({ result: "employee info edited" });
      });
  }
});

router.post("/deleteEmployee", async (req, res) => {
  await db.check();
  await models.employee
    .destroy({
      where: {
        id: req.body.id,
      },
    })
    .then(async () => {
      await db.backup();
      return res.status(200).json({ result: "employee info edited" });
    });
});

router.get("/getEmployeeRoute/:id", async (req, res) => {
  await db.check();
  console.log(req.params);
  let employee = await models.employee.findOne({
    where: {
      id: req.params.id,
    },
  });
  let route = await employee.getRoute({
    include: [{ all: true, nested: true }],
  });

  return res.send(route.dataValues);
});
module.exports = router;
