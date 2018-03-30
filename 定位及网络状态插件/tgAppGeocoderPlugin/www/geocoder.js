cordova.define("com.tg.app.plugin.geocoder.geocoder.js", function(require, exports, module) {
/**
	

**/
var exec = require('cordova/exec');

module.exports = {
    getPlaceName: function(info,onSuccess,onError){
        exec(onSuccess, onError,"CDVGeocoder","getPlaceName",[info]);
    }
};

});
