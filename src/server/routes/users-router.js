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
            [Op.like]: `%${req.body.userid}%`
          }
        }
      })
      .then(users => {
        console.log(users);
        res.send(users);
      })
      .catch(error => {
        res.status(500).send(error);
      });
  } else {
    models.user
      .findAll({
        raw: true
      })
      .then(users => {
        console.log(users);
        res.send(JSON.stringify(users));
      })
      .catch(error => {
        res.status(500).send(error);
      });
  }
});

router.post("/login", async (req, res) => {
  await db.check();
  models.account
    .findOne({
      where: {
        email: req.body.userid
      }
    })
    .then(async user => {
      if (!user || !(await user.comparePassword(req.body.password))) {
        res.status(401).json({ token: null, errorMessage: "failed!" });
      } else {
        user.password = true;
        res.send(user.dataValues);
      }
    });
});

router.post("/register", async (req, res, next) => {
  await db.check();
  models.user
    .findOne({
      where: {
        userid: req.body.userid
      }
    })
    .then(async user => {
      // if userId is already being used
      if (user) {
        return res.status(400).json({ result: "User id is already used." });
      }

      models.user.create({
        userid: req.body.userid,
        email: req.body.email,
        password: req.body.password,
        sessionToken: null
      });
      db.backup();
      return res.status(200).json({ result: "user created" });
    });
});

module.exports = router;
