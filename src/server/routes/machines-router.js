const express = require("express");
const bodyParser = require("body-parser");
const db = require("../models/index");

const app = express();
const Sequelize = require("sequelize");

const { Op } = Sequelize;

const router = express.Router();
const models = require("../models");
const { UUIDV4, UUIDV1, MACADDR } = require("sequelize");

router.get("/getAll/", async (req, res) => {
  await db.check();

  await models.vendingMachine.findAll().then(async (machines) => {
    machineList = [];
    machines.forEach((machine) => {
      machineList.push(machine.dataValues);
    });
    return res.send(machineList);
  });
});

router.get("/getMachineAttributes/", async (req, res) => {
  await db.check();

  return res.send(Object.keys(models.vendingMachine.rawAttributes));
});

router.post("/addProduct", async (req, res) => {
  await db.check();
  await models.product
    .findOne({
      where: {
        upc: req.body.upc,
      },
    })
    .then(async (product) => {
      await models.vendingMachine
        .findOne({
          where: {
            id: req.body.machineid,
          },
        })
        .then(async (machine) => {
          duplicate = false;
          await machine.getProductStocks().then(async (stocks) => {
            stocks.forEach(async (stock) => {
              if (stock.dataValues.productId === product.id) {
                duplicate = true;
                await res
                  .status(400)
                  .json({ result: "product is already in machine!" });
                return res.send();
              }
            });
            if (!duplicate) {
              await models.productStock
                .create({
                  count: req.body.count,
                  minimum: req.body.minimum,
                })
                .then(async (productStock) => {
                  product.addProductStock(productStock);
                  machine.addProductStock(productStock);
                  await db.backup();
                  return res.status(200).json({ result: "product added" });
                });
            }
          });
        });
    });
});

router.post("/newMaintenanceTask", async (req, res) => {
  await db.check();
  const machineType = await models.machineType.findOne({
    where: {
      type: req.body.machineType,
    },
  });
  console.log(machineType.id);

  await models.maintenanceTask
    .create({
      task: req.body.task,
      recurring: req.body.recurring,
      reminderCount: req.body.reminderCount,
    })
    .then(async (newTask) => {
      await machineType.addTask(newTask);
      await db.backup();
      return res.status(200).json({ result: "task added" });
    });
});

router.post("/editMaintenanceTask", async (req, res) => {
  await db.check();
  const task = await models.maintenanceTask.findOne({
    where: {
      id: req.body.id,
    },
  });
  if (task) {
    await task
      .update({
        task: req.body.task,
        recurring: req.body.recurring,
        reminderCount: req.body.reminderCount,
      })
      .then(async () => {
        await db.backup();
        return res.status(200).json({ result: "task edited" });
      });
  }
});

router.post("/newMachine", async (req, res) => {
  await db.check();
  const machineType = await models.machineType.findOne({
    where: {
      type: req.body.machineType,
    },
  });

  models.vendingMachine.create({}).then(async (machine) => {
    await machine.addType(machineType);
    await db.backup();
    return res.send(machine.dataValues);
  });
});

router.post("/batchMachines", async (req, res) => {
  await db.check();

  models.vendingMachine
    .create({
      type: req.body.type,
    })
    .then(async (machine) => {
      await db.backup();
      return res.send(machine.dataValues);
    });
});

router.post("/newType", async (req, res) => {
  await db.check();

  models.machineType
    .create({
      type: req.body.type,
    })
    .then(async (machineType) => {
      await db.backup();
      return res.send(machineType.dataValues);
    });
});

router.get("/getTypes", async (req, res) => {
  await db.check();
  await models.machineType.findAll().then(async (machines) => {
    machineList = [];
    machines.forEach((machine) => {
      machineList.push(machine.dataValues);
    });
    return res.send(machineList);
  });
});

router.get("/getMaintenanceTasks", async (req, res) => {
  await db.check();
  console.log(req.query);

  const machineType = await models.machineType.findOne({
    where: {
      type: req.query.machineType,
    },
  });

  machineType.getTasks().then(async (tasks) => {
    console.log(tasks);
    maintenanceList = [];
    tasks.forEach((task) => {
      maintenanceList.push(task.dataValues);
    });
    await db.backup();
    return res.send(maintenanceList);
  });
});

module.exports = router;
