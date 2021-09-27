/* eslint-disable linebreak-style */
const express = require("express");
const bodyParser = require("body-parser");

const app = express();
const Sequelize = require("sequelize");
const db = require("../models/index");
const { Op } = Sequelize;

const router = express.Router();
const models = require("../models");
const { where } = require("sequelize");
const { route } = require("./machines-router");

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
        username: req.body.username,
      },
    })
    .then(async (user) => {
      if (!user || !(await user.comparePassword(req.body.password))) {
        res
          .status(401)
          .json({ status: 401, token: null, errorMessage: "failed!" });
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
  let secret = await models.secret.findOne({});
  const va2 = await secret.comparePassword(req.body.secret);

  if (va2 === true) {
    models.account
      .findOne({
        where: {
          username: req.body.username,
        },
      })
      .then(async (user) => {
        // if userId is already being used
        if (user) {
          return res
            .status(400)
            .json({ status: 400, result: "User id is already used." });
        }

        await models.account.create({
          username: req.body.username,
          password: req.body.password,
        });
        await db.backup();

        return res.status(200).json({ status: 200, result: "user created" });
      });
  } else {
    return res
      .status(400)
      .json({ status: 401, result: "Secret does not match." });
  }
});

router.post("/checkSecret", async (req, res) => {
  await db.check();

  let secret = await models.secret.findOne({});
  if ((await secret.comparePassword(req.body.secret)) === true) {
    return res.status(200).json({ status: 200, result: "secret true" });
  } else {
    return res.status(400).json({ status: 400, result: "secret false" });
  }
});

router.post("/employeeLogin", async (req, res) => {
  await db.check();

  let secret = await models.secret.findOne({});
  if ((await secret.comparePassword(req.body.secret)) === true) {
    const user = await models.employee.findOne({
      where: {
        username: req.body.username,
      },
    });
    if (user) {
      console.log(user);
      return res
        .status(200)
        .json({ status: 200, result: "secret true", user: user });
    } else {
      return res
        .status(400)
        .json({ status: 400, result: "User doesn't exist" });
    }
  } else {
    return res.status(400).json({ status: 400, result: "secret false" });
  }
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
      username: req.body.username,
      isTechnician: false,
    })
    .then(async (employee) => {
      await db.backup();
      return res.send(employee.dataValues);
    })
    .catch(Sequelize.UniqueConstraintError, function (err) {
      res.status(400).json({ message: "username exists" });
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
        isTechnician: false,
        username: req.body.username,
      })
      .then(async () => {
        if (req.body.isTechnician === true) {
          await employee.setMachineType(machineType);
        } else {
          await employee.setMachineType(null);
        }
        await db.backup();
        return res.status(200).json({ result: "employee info edited" });
      })
      .catch(Sequelize.UniqueConstraintError, function (err) {
        console.log("ass");
        res.status(400).json(_.pluck(err.errors, "path"));
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
