var pushy = require('pushy');
var config = require('../config.js');
var api = new pushy(config.pushy.secretApiKey);

// Registered devices
var tokens = [];

// Set push payload data to deliver to device(s)
var data = {
  message: 'Hello World!!!!!!!!'
};

// Set sample iOS notification fields
  var options = {
      notification: {
          badge: 1,
          sound: 'ping.aiff',
          body: 'Hello World OPZIONI \u270c'
      },
  };

//route index
function index(request, response){
  response.status(200).send("Index");
}

//route /notifications/register
function push(request, response){
  // Send push notification via the Send Notifications API
  // https://pushy.me/docs/api/send-notifications
  api.sendPushNotification(data, tokens, options, function (err, id) {
    // Log errors to console
    if (err) {
      return console.log('Fatal Error', err);
    }

    // Log success
    console.log('Push sent successfully! (ID: ' + id + ')');

    response.status(200).send("Push");
  });
}

function updateStatusPushPromise(newStatus,token){

    var dataUpdate = {
      message: newStatus
    };
    return new Promise(function(resolve, reject){
        api.sendPushNotification(dataUpdate, [token], options, function (err, id) {
          // Log errors to console
          if (err) {
            console.log('Fatal Error', err);
            reject(err)
          }

          // Log success
          console.log('Push sent successfully! (ID: ' + id + ')');
          resolve("TRUE");
        });
    })
}

//route /notifications/register
function register(request, response){
  var device = request.params.device;
  tokens.push(device);
  console.log("Device registered");
  response.status(200).send("Register");
}

module.exports.index = index;
module.exports.push = push;
module.exports.register = register;
module.exports.updateStatusPushPromise = updateStatusPushPromise;
