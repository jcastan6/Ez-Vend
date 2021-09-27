const synchronize = require("../models/index");

const express = require("express");
const bodyParser = require("body-parser");
const db = require("../models/index");

const app = express();
const Sequelize = require("sequelize");

const { Op } = Sequelize;

const router = express.Router();
const models = require("../models");

router.get("/getAll", async (req, res) => {
  await db.check();

  models.client.findAll().then(async (clients) => {
    clientList = [];
    for (const client of clients) {
      const count = await models.vendingMachine.count({
        where: {
          clientId: client.dataValues.id,
        },
      });
      client.dataValues.count = count;
      console.log(count);
      clientList.push(client.dataValues);
    }

    return res.send(clientList);
  });
});
router.post("/addClient", async (req, res) => {
  await db.check();

  await models.client
    .create({
      name: req.body.name,
    })
    .then(async (client) => {
      console.log(client);

      await db.backup();
      res.status(200).json({ result: "client added" });
      return res.send();
    });
});

router.post("/addMachine", async (req, res) => {
  await db.check();
  models.account
    .findOne({
      where: {
        businessName: req.body.businessName,
      },
    })
    .then(async (account) => {
      await models.client
        .findOne({
          where: {
            name: req.body.name,
            accountId: account.dataValues.id,
          },
        })
        .then(async (client) => {
          await models.vendingMachine
            .findOne({ where: { id: req.body.machineid } })
            .then(async (machine) => {
              machine.setClient(client);
              await db.backup();
              return res.status(200).json({ result: "machine added" });
            });
        });
    });
});

router.post("/editClient", async (req, res) => {
  await db.check();
  const task = await models.client.findOne({
    where: {
      id: req.body.id,
    },
  });
  console.log(task);
  if (task) {
    await task
      .update({
        name: req.body.nane,
      })
      .then(async () => {
        await db.backup();
        return res.status(200).json({ result: "client edited" });
      });
  }
});

router.post("/deleteClient", async (req, res) => {
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
