module.exports.parseFunctionArguments = (func) ->
  STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg;
  ARGUMENT_NAMES = /([^\s,]+)/g;

  fnStr = func.toString().replace(STRIP_COMMENTS, '')
  fnStr.slice(fnStr.indexOf('(')+1, fnStr.indexOf(')')).match(ARGUMENT_NAMES) || []
