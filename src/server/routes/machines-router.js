const express = require("express");
const bodyParser = require("body-parser");
const db = require("../models/index");
const cron = require("node-cron");

const app = express();
const Sequelize = require("sequelize");

const { Op } = Sequelize;

const router = express.Router();
const { UUIDV4, UUIDV1, MACADDR } = require("sequelize");
const models = require("../models");
const { sequelize } = require("../models/index");

cron.schedule("00 00 * * *", async () => {
  console.log("hey!");
  await sequelize.query(
    "UPDATE maintenancelogs SET daysCount = dayscount + 1;"
  );
  await sequelize.query(
    "UPDATE maintenancelogs SET pastDue = 1 where reminderAt = daysCount;"
  );
});

router.get("/getAll/", async (req, res) => {
  await db.check();

  await models.vendingMachine
    .findAll({ include: ["client", "type"] })
    .then(async (machines) => {
      machineList = [];
      for (const machine of machines) {
        const reports = await machine.getReports();
        machine.dataValues.reports = reports.length;
        machineList.push(machine.dataValues);
      }
    });
  return res.send(machineList);
});

router.get("/getMachineAttributes/", async (req, res) => {
  await db.check();

  return res.send(Object.keys(models.vendingMachine.rawAttributes));
});

router.post("/newMaintenanceTask", async (req, res) => {
  await db.check();
  const machineType = await models.machineType.findOne({
    where: {
      type: req.body.machineType,
    },
  });

  const newTask = await models.maintenanceTask.create({
    task: req.body.task,
    recurring: req.body.recurring,
    reminderCount: req.body.reminderCount,
    priority: req.body.priority,
  });

  await machineType.addTask(newTask);

  const machines = await models.vendingMachine.findAll({
    where: {
      typeId: machineType.id,
    },
  });

  for (const machine of machines) {
    const maintenance = await models.maintenanceLog.create({
      reminderAt: req.body.reminderCount,
    });
    newTask.addLog(maintenance);
    await machine.addMaintenance(maintenance);
  }

  await db.backup();
  return res.status(200).json({ result: "task added" });
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
        priority: req.body.priority,
      })
      .then(async () => {
        await sequelize.query(
          `UPDATE maintenancelogs SET reminderAt = ${req.body.reminderCount} where maintenanceTaskId = "${task.id}";`
        );
        await sequelize.query(
          "UPDATE maintenancelogs SET pastDue = 1 where reminderAt = daysCount;"
        );
        await db.backup();
        return res.status(200).json({ result: "task edited" });
      });
  }
});

router.post("/deleteMaintenanceTask", async (req, res) => {
  await db.check();
  const task = await models.maintenanceTask.findOne({
    where: {
      id: req.body.id,
    },
  });
  if (task) {
    await task.destroy().then(async () => {
      await db.backup();
      return res.status(200).json({ result: "task removed" });
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

  const client = await models.client.findOne({
    where: {
      name: req.body.clientName,
    },
  });

  models.vendingMachine
    .create({
      machineNo: req.body.machineNo,
      serialNo: req.body.serialNo,
      model: req.body.model,
    })
    .then(async (machine) => {
      await machine.setClient(client);
      await machine.setType(machineType);

      await db.backup();
      return res.send(machine.dataValues);
    });
});

router.post("/deleteMachine", async (req, res) => {
  await db.check();

  models.vendingMachine
    .destroy({
      where: {
        id: req.body.id,
      },
    })
    .then(async () => {
      await db.backup();
      return res.status(200).json({ result: "machine removed" });
    });
});

router.post("/editMachine", async (req, res) => {
  await db.check();
  const machineType = await models.machineType.findOne({
    where: {
      type: req.body.machineType,
    },
  });

  const client = await models.client.findOne({
    where: {
      name: req.body.clientName,
    },
  });

  machine = await models.vendingMachine.findOne({
    where: {
      id: req.body.id,
    },
  });

  if (machine) {
    machine
      .update({
        machineNo: req.body.machineNo,
        serialNo: req.body.serialNo,
        model: req.body.model,
      })
      .then(async (machine) => {
        await machine.setClient(client);
        await machine.setType(machineType);

        await db.backup();
        return res.send(machine.dataValues);
      });
  }
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

// gets maintenances tasks for one machine type
router.get("/getMaintenanceTasks", async (req, res) => {
  await db.check();

  const machineType = await models.machineType.findOne({
    where: {
      type: req.query.machineType,
    },
  });

  machineType.getTasks().then(async (tasks) => {
    maintenanceList = [];
    tasks.forEach((task) => {
      maintenanceList.push(task.dataValues);
    });
    await db.backup();
    return res.send(maintenanceList);
  });
});

// gets all the daily maintenances for one machine
router.post("/getMaintenanceLogs", async (req, res) => {
  await db.check();

  const machine = await models.vendingMachine.findOne({
    where: {
      id: req.body.machine.id,
    },
  });

  machine.getMaintenances().then(async (tasks) => {
    const maintenanceList = [];
    for (const task of tasks) {
      if (task.dataValues.pastDue === false) {
        task.dataValues.pastDue = "No";
      } else {
        task.dataValues.pastDue = "Yes";
      }
      const maintenanceTask = await models.maintenanceTask.findOne({
        where: {
          id: task.dataValues.maintenanceTaskId,
        },
      });

      task.dataValues.task = maintenanceTask.dataValues.task;
      maintenanceList.push(task.dataValues);
    }
    await db.backup();

    return res.send(maintenanceList);
  });
});

router.get("/getReports", async (req, res) => {
  await db.check();

  models.maintanceReports.findAll().then(async (tasks) => {
    maintenanceList = [];
    tasks.forEach((task) => {
      maintenanceList.push(task.dataValues);
    });
    await db.backup();
    return res.send(maintenanceList);
  });
});

router.post("/getMachineReports", async (req, res) => {
  await db.check();

  const machine = await models.vendingMachine.findOne({
    where: {
      id: req.body.machine.id,
    },
  });

  await machine.getReports().then(async (reports) => {
    const list = [];
    reports.forEach((report) => {
      list.push(report.dataValues);
    });
    await db.backup();
    return res.send(list);
  });
});

module.exports = router;

router.post("/submitReport", async (req, res) => {
  await db.check();

  const report = await models.maintenanceReport.create({
    task: req.body.issue,
  });

  const machine = await models.vendingMachine.findOne({
    where: {
      machineNo: req.body.machine,
    },
  });

  await machine.addReport(report);

  await db.backup();
  return res.send();
});

router.post("/getMaintenanceHistory", async (req, res) => {
  await db.check();

  const machine = await models.vendingMachine.findOne({
    where: {
      id: req.body.machine.id,
    },
  });
  if (machine) {
    await machine.getHistory().then(async (reports) => {
      const list = [];
      reports.forEach((report) => {
        list.push(report.dataValues);
      });
      await db.backup();
      return res.send(list);
    });
  }
});
