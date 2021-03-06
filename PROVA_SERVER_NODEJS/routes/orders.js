var express = require('express');
var router = express.Router();
var ordersCtrl = require('../controllers/orders.js');

/* POST create order. */
router.post('/create', function (req, res, next) {
  ordersCtrl.createOrder(req, res);
});

/* GET order */
router.get('/:order_id', function (req, res, next) {
  ordersCtrl.getOrderFromId(req, res);
});

/* GET to delete order */
router.get('delete/:order_id/:destroy_code', function (req, res, next) {
  ordersCtrl.deleteOrder(req, res);
});

/* GET NEXT ORDER -> for barman */
router.post('/getNext', function (req, res, next) {
    console.log("GETNEXT");
    ordersCtrl.getNextOrder(req, res);
});

/* UPDATE STATUS OF ORDER -> for barman*/
router.post('/updateStatus/:order_id', function (req, res, next) {
    ordersCtrl.updateStatus(req, res);
});

/* COMPLETE STATUS OF ORDER -> for barman*/
router.get('/complete/:order_id/:destroy_code', function (req, res, next) {
    ordersCtrl.completeOrder(req, res);
});

module.exports = router;
