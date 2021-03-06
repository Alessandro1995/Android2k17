// Import to use in this file
var ordersDAOImpl = require('../DAOIMPL/orders.js');
var Order = require('../models/order.js');
var OrderStatus = require('../models/orderStatus.js');
var passport  =  require("../passportConfig.js")


//percorso "/orders/create"
function createOrder(request, response) {
    var customer;
    passport.authenticate('json', function (err,user,msg) {
        console.log("err")
        console.log(err)
        console.log("user")
        console.log(user)
        console.log("msg")
        console.log(msg)

        if(err == null && user != false){
            customer = user;
            console.log("BODY");
            console.log(request.body);
            orderCreationPromise = ordersDAOImpl.createOrder(customer, request.body.order)
            orderCreationPromise.then(function(orderId){
                //ordine aggiunto al db
                return ordersDAOImpl.getOrderFromId(orderId);
            }).then(function(order){
                response.status(200).json(order);
            }).catch(function(err){
                console.log(err);
                response.status(500).json("ERRORE NELL'INSERIRE L'ORDINE")
            });
        }else{
            response.status(401).json(msg);
        }
    })(request, response);
}

//percorso /orders/getNext
function getNextOrder(request, response){
    console.log("GET NEXT ORDER");
    passport.authenticate('BARMAN', function (err,user,msg) {
        if(err == null && user != false){
            ordersDAOImpl.getNextOrder()
            .then(function(order){
                response.status(200).json(order);
            }).catch(function(err){
                console.log(err);
                response.status(500).json("ERRORE NEL PRENDERE IL NEXT ORDER")
            })
        }
        else{
            response.status(500).json("ERRORE di autenticazione")
        }
    })(request, response);
}

function updateStatus(request, response){
    var orderId = parseInt(request.params.order_id);
    passport.authenticate('BARMAN', function (err,user,msg) {
        if(err == null && user != false){
            newStatus = request.body.newStatus;
            if(newStatus != OrderStatus.COMPLETED){
                ordersDAOImpl.updateOrderStatus(orderId, newStatus)
                .then(function(success){
                    //TODO CREO LA NOTIFICA DA INVIARE
                    response.status(200).json(success);
                }).catch(function(err){
                    response.status(500).json("ERRORE NELL'aggiornare lo stato")
                });
            }
            else{
                response.status(500).json("ERRORE: NON PUOI COMPLETARE L'ORDINE,chiama /");
            }
        }else{
            response.status(500).json("ERRORE di autenticazione")
        }
    })(request, response);
}

//percorso /orders/complete/:order_id
function completeOrder(request, response){
    var orderId = parseInt(request.params.order_id);
    var destroyCode = request.params.destroy_code;
    //passport.authenticate('BARMAN', function (err,user,msg) {
    //    if(err == null && user != false){
            ordersDAOImpl.checkOrderReady(orderId,destroyCode)
            .then(function(result){
                if(result == true){
                    ordersDAOImpl.updateOrderStatus(orderId, OrderStatus.COMPLETED)
                    .then(function(success){
                        response.status(200).json(success);
                    }).catch(function(err){
                        console.log(err)
                        response.status(500).json("ERRORE NEL COMPLETARE L'ORDINE")
                    });
                }
                else{
                    response.status(500).json("ERRORE: ORDINE NON ANCORA READY")
                }

            }).catch(function(err){
                console.log(err);
                response.status(500).json("ERRORE NEL COMPLETARE L'ORDINE")
            });
    //    }
    //    else{
    //        response.status(401).json("NON AUTORIZZATO")
    //    }
    //})(request, response);
}

//percorso /orders/:order_id
function getOrderFromId(request, response){
    var orderId = request.params.order_id;
    ordersDAOImpl.getOrderFromId(orderId)
    .then(function(order){
        response.status(200).json(order);
    }).catch(function(err){
        response.status(500).json("ERRORE NEL PRENDERE L'ORDINE")
    })

}




module.exports.createOrder = createOrder;
module.exports.getOrderFromId = getOrderFromId;
module.exports.getNextOrder = getNextOrder;
module.exports.updateStatus = updateStatus;
module.exports.completeOrder = completeOrder;
