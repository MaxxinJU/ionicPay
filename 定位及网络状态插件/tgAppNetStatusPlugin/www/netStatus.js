
var exec = require('cordova/exec');

module.exports = {
    getNetStatusFormAFN: function(onSuccess,onError){
        exec(onSuccess, onError,"CDVNetStatus","getNetStatusFormAFN",[]);
    }
};
module.exports = {
  
               
    getNetStatusFormStatebar: function(onSuccess,onError){
        exec(onSuccess, onError,"CDVNetStatus","getNetStatusFormStatebar",[]);
    }
};
               


