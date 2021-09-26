const express = require("express");
const bodyParser = require("body-parser");
const cron = require("node-cron");

const app = express();
const Sequelize = require("sequelize");

const { Op } = Sequelize;

const router = express.Router();
const { UUIDV4, UUIDV1, MACADDR } = require("sequelize");
const { Storage } = require("@google-cloud/storage");
const models = require("../models");
const { sequelize } = require("../models/index");

const db = require("../models/index");

const storage = new Storage({ keyFilename: "gcskey.json" });

const bucket = storage.bucket("ezvend");

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
        let i = 0;

        for (report of reports) {
          if (report.dataValues.emergency || report.dataValues.pastDue) {
            i++;
          }
        }
        machine.dataValues.reports = i;
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
        reminderAt: req.body.reminderAt,
        pastDue:
          req.body.reminderAt <= task.dataValues.daysCount ? true : false,
      })
      .then(async () => {
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

router.post("/editMaintenanceReport", async (req, res) => {
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
      })
      .then(async () => {
        await db.backup();
        return res.status(200).json({ result: "task edited" });
      });
  } else {
    return res.status(200).json({ result: "task edited" });
  }
});

router.post("/deleteMaintenanceReport", async (req, res) => {
  await db.check();
  const task = await models.maintenanceTask.findOne({
    where: {
      id: req.body.id,
    },
  });
  if (task) {
    await task.destroy().then(async () => {
      await db.backup();
      return res.status(200).json({ result: "report removed" });
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
    if (client) {
      task.dataValues.client = client;
      maintenanceList.push(task.dataValues);
    }
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

router.post("/submitReport", async (req, res) => {
  await db.check();

  if (req.files) {
    // Create a new blob in the bucket and upload the file data.
    const blob = bucket.file(req.files.file.name);
    const blobStream = blob.createWriteStream({
      resumable: false,
    });

    blobStream.on("error", (err) => {
      res.status(500).send({ message: err.message });
    });

    blobStream.on("finish", async (data) => {
      // Create URL for directly file access via HTTP.
      const publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;

      try {
        const machine = await models.vendingMachine.findOne({
          where: {
            machineNo: req.body.machine,
          },
        });
        const report = await models.maintenanceTask.create({
          task: req.body.issue,
          emergency: true,
          image: publicUrl,
        });
        await machine.addTask(report);
        await db.backup();
        await bucket.file(req.file.originalname).makePublic();
      } catch {
        return res.status(500).send({
          message: `Uploaded the file successfully: ${req.files.file.name}, but public access is denied!`,
          url: publicUrl,
        });
      }

      res.status(200).send({
        message: "Uploaded the file successfully: " + req.files.file.name,
        url: publicUrl,
      });
    });

    blobStream.end(req.files.file.data);
  } else {
    const machine = await models.vendingMachine.findOne({
      where: {
        machineNo: req.body.machine,
      },
    });
    const report = await models.maintenanceTask.create({
      task: req.body.issue,
      emergency: true,
      image: null,
    });
    await machine.addTask(report);
    await db.backup();
    return res.status(200).send({ message: "success" });
  }
});

router.post("/getMaintenanceHistory", async (req, res) => {
  await db.check();

  const machine = await models.vendingMachine.findOne({
    where: {
      id: req.body.machine.id,
    },
  });
  if (machine) {
    const reports = await machine.getHistory({
      order: [["createdAt", "DESC"]],
    });
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

router.post("/deleteMaintenanceHistory", async (req, res) => {
  await db.check();
  const task = await models.maintenanceHistory.findOne({
    where: {
      id: req.body.id,
    },
  });
  if (task) {
    await task.destroy().then(async () => {
      await db.backup();
      return res.status(200).json({ result: "report removed" });
    });
  }
});

router.get("/getDailyMaintenanceHistory", async (req, res) => {
  await db.check();
  const Op = Sequelize.Op;
  const TODAY_START = new Date().setHours(0, 0, 0, 0);
  const NOW = new Date();

  const reports = await models.maintenanceHistory.findAll({
    where: {
      createdAt: {
        [Op.gt]: TODAY_START,
        [Op.lt]: NOW,
      },
    },
    order: [["createdAt", "DESC"]],
  });
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
});

router.post("/addMaintenanceHistory", async (req, res) => {
  await db.check();

  if (req.files) {
    // Create a new blob in the bucket and upload the file data.
    const blob = bucket.file(req.files.file.name);
    const blobStream = blob.createWriteStream({
      resumable: false,
    });

    blobStream.on("error", (err) => {
      res.status(500).send({ message: err.message });
    });

    blobStream.on("finish", async (data) => {
      // Create URL for directly file access via HTTP.
      const publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;

      try {
        const employee = await models.employee.findOne({
          where: {
            id: req.body.employeeId,
          },
        });
        const history = await models.maintenanceHistory.create({
          image: publicUrl,
          notes: req.body.notes,
        });
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

        if (!task.dataValues.emergency) {
          task.daysCount = 0;
          task.pastDue = false;
          task.save();
        }

        await sequelize.query(
          `DELETE FROM vending.employeetasks where maintenanceTaskId= ${req.body.task};`
        );

        await machine.addHistory(history);
        await history.setEmployee(employee);
        await history.setMaintenance(task);

        await db.backup();
        await bucket.file(req.file.originalname).makePublic();
      } catch {
        return res.status(500).send({
          message: `Uploaded the file successfully: ${req.files.file.name}, but public access is denied!`,
          url: publicUrl,
        });
      }

      res.status(200).send({
        message: "Uploaded the file successfully: " + req.files.file.name,
        url: publicUrl,
      });
    });

    blobStream.end(req.files.file.data);
  }
});

module.exports = router;
