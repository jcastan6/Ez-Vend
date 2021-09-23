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
    "UPDATE maintenancetasks SET daysCount = dayscount + 1;"
  );
  await sequelize.query(
    "UPDATE maintenancetasks SET pastDue = 1 where reminderAt = daysCount;"
  );
});

router.get("/getAll/", async (req, res) => {
  await db.check();

  await models.vendingMachine
    .findAll({ include: ["client", "type"] })
    .then(async (machines) => {
      machineList = [];
      for (const machine of machines) {
        const reports = await machine.getTasks();
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

  const machine = await models.vendingMachine.findOne({
    where: {
      id: req.body.machine.id,
    },
  });

  const newTask = await models.maintenanceTask.create({
    task: req.body.task,
    reminderAt: req.body.reminderCount,
    emergency: false,
  });

  await machine.addTask(newTask);

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
          `UPDATE maintenancetasks SET reminderAt = ${req.body.reminderCount} where id = "${task.id}";`
        );
        await sequelize.query(
          "UPDATE maintenancetasks SET pastDue = 1 where reminderAt = daysCount;"
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
  console.log(req.body);

  const client = await models.client.findOne({
    where: {
      name: req.body.clientName,
    },
  });

  const machine = await models.vendingMachine.findOne({
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

// // gets maintenances tasks for one machine type
// router.get("/getMaintenanceTasks", async (req, res) => {
//   await db.check();

//   const machineType = await models.machineType.findOne({
//     where: {
//       type: req.query.machineType,
//     },
//   });

//   machineType.getTasks().then(async (tasks) => {
//     maintenanceList = [];
//     tasks.forEach((task) => {
//       maintenanceList.push(task.dataValues);
//     });
//     await db.backup();
//     return res.send(maintenanceList);
//   });
// });

router.get("/getAllMaintenanceLogs", async (req, res) => {
  await db.check();
  const existing = await sequelize.query(
    "SELECT maintenanceTaskId FROM vending.employeetasks;",
    { raw: true }
  );
  const array = [];

  for (number of existing[0]) {
    if (number) {
      array.push(number.maintenanceTaskId);
    }
  }
  console.log(array);

  const tasks = await models.maintenanceTask.findAll({
    where: {
      completed: false,
      [Op.or]: [{ pastDue: true }, { emergency: true }],
      id: { [Op.notIn]: array },
    },
    include: ["vendingMachine"],
  });

  const maintenanceList = [];

  for (task of tasks) {
    const client = await models.client.findOne({
      where: { id: task.dataValues.vendingMachine.clientId },
    });
    task.dataValues.client = client;
    maintenanceList.push(task.dataValues);
  }
  await db.backup();

  return res.send(maintenanceList);
});
// gets all the daily maintenances for one machine
router.post("/getMaintenanceLogs", async (req, res) => {
  await db.check();

  const machine = await models.vendingMachine.findOne({
    where: {
      id: req.body.machine.id,
    },
  });

  machine
    .getTasks({
      where: {
        emergency: false,
      },
    })
    .then(async (tasks) => {
      const maintenanceList = [];
      tasks.forEach((task) => {
        if (task.dataValues.pastDue === false) {
          task.dataValues.pastDue = "No";
        } else {
          task.dataValues.pastDue = "Yes";
        }
        maintenanceList.push(task.dataValues);
      });
      await db.backup();

      return res.send(maintenanceList);
    });
});

router.get("/getReports", async (req, res) => {
  await db.check();

  models.maintenanceTasks
    .findAll({
      where: {
        emergency: true,
        completed: false,
      },
    })
    .then(async (tasks) => {
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

  await machine
    .getTasks({
      where: {
        emergency: true,
        completed: false,
      },
    })
    .then(async (reports) => {
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

  const report = await models.maintenanceTask.create({
    task: req.body.issue,
    emergency: true,
  });

  const machine = await models.vendingMachine.findOne({
    where: {
      machineNo: req.body.machine,
    },
  });

  await machine.addTask(report);

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
    const reports = await machine.getHistory();
    const list = [];
    for (report of reports) {
      const task = await report.getMaintenance();
      const employee = await report.getEmployee();
      if (employee) {
        report.dataValues.employee = employee.dataValues.name;
      }
      report.dataValues.task = task.dataValues.task;
      list.push(report.dataValues);
    }
    await db.backup();
    return res.send(list);
  }
});

router.post("/addMaintenanceHistory", async (req, res) => {
  await db.check();

  const history = await models.maintenanceHistory.create({});
  const machine = await models.vendingMachine.findOne({
    where: {
      id: req.body.machine,
    },
  });

  const task = await models.maintenanceTask.findOne({
    where: {
      id: req.body.task,
      completed: false,
    },
  });
  if (task.emergency === true) {
    task.completed = true;
    await task.save();
  }
  await machine.addHistory(history);
  await history.setMaintenance(task);

  await db.backup();
  return res.send();
});
