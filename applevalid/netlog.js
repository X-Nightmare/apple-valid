"use strict";
var page = require('webpage').create(),
    system = require('system'),
    address;
page.settings.userAgent='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.81 Safari/537.36'

if (system.args.length === 1) {
    console.log('Usage: netlog.js <some URL>');
    phantom.exit(1);
} else {
    address = system.args[1];

    // page.onResourceRequested = function (req) {
    //     console.log('requested: ' + JSON.stringify(req, undefined, 4));
    // };

    page.onResourceReceived = function (res) {
        console.log('received: ' + JSON.stringify(res, undefined, 4));
    };

    page.open(address, function (status) {
        if (status !== 'success') {
            console.log('FAIL to load the address');
        }

        console.log(page.content);
        // page.render('halo.png');
        phantom.exit();
    });
}