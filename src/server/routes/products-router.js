const express = require("express");
const bodyParser = require("body-parser");

const app = express();
const Sequelize = require("sequelize");

const { Op } = Sequelize;
const db = require("../models/index");

const router = express.Router();
const models = require("../models");

router.get("/getAll/:businessName", async (req, res) => {
  await db.sequelize.sync();
  models.account
    .findOne({
      where: {
        businessName: req.params.businessName
      }
    })
    .then(account => {
      account.getProducts().then(products => {
        productsList = [];
        products.forEach(product => {
          productsList.push(product.dataValues);
        });
        return res.send(productsList);
      });
    });
});
router.post("/newProduct", async (req, res) => {
  await db.sequelize.sync();
  models.product
    .findOne({
      where: {
        upc: req.body.upc
      }
    })
    .then(product => {
      // if userId is already being used
      if (product) {
        models.account
          .findOne({
            where: {
              businessName: req.body.businessName
            }
          })
          .then(account => {
            account.addProduct(product);
            return res
              .status(200)
              .json({ result: "product created and added" });
          });
        return product;
      }

      models.product
        .create({
          name: req.body.name,
          upc: req.body.upc
        })
        .then(product => {
          models.account
            .findOne({
              where: {
                businessName: req.body.businessName
              }
            })
            .then(account => {
              account.addProduct(product);
            });

          return res.status(200).json({ result: "product created and added" });
        });
    });
});
module.exports = router;
