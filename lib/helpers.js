(function() {
  module.exports.parseFunctionArguments = function(func) {
    var ARGUMENT_NAMES, STRIP_COMMENTS, fnStr;
    STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg;
    ARGUMENT_NAMES = /([^\s,]+)/g;
    fnStr = func.toString().replace(STRIP_COMMENTS, '');
    return fnStr.slice(fnStr.indexOf('(') + 1, fnStr.indexOf(')')).match(ARGUMENT_NAMES) || [];
  };

}).call(this);
