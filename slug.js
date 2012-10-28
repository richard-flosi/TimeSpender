var argv = process.argv.slice(2);
var fs = require('fs');
var path = require('path');
var util = require('util');
var hem  = new (require('hem'))();
var HamlCoffee = require('haml-coffee/src/haml-coffee');
var CoffeeScript = require('coffee-script');
var less = require('less');

// haml compiler
hem.compilers.haml = function(path) {
    var compiler, content, template;
    compiler = new HamlCoffee({});
    content = fs.readFileSync(path, 'utf8');
    compiler.parse(content);
    template = compiler.precompile();
    template = CoffeeScript.compile(template);
    return "module.exports = (function(data){ return (function(){ return " + template + " }).call(data); })";
};

hem.compilers.jhaml = function(path) {
    var compiler, content, template;
    compiler = new HamlCoffee({});
    content = fs.readFileSync(path, 'utf8');
    compiler.parse(content);
    template = compiler.precompile();
    template = CoffeeScript.compile(template);
    return "module.exports = (function(values){ " +
        "values = $.makeArray(values); " +
        "return (function(values){ " +
            "var $ = jQuery, result = $(); " +
            "for(var i=0; i < this.length; i++) { " +
                "var value = this[i]; " +
                "var elem = (function(){ " +
                    "return " + template +
                "}).call(value); " +
                "elem = $(elem); " +
                "elem.data('item', value); " +
                "$.merge(result, elem); " +
            "} " +
            "return result; " +
        "}).call(values); " +
    "})";
};

require.extensions['.jhaml'] = require.extensions['.haml'];

// less compiler
hem.compilers.less = function (pathname) {
    var content, result;
    content = fs.readFileSync(pathname, 'utf8');
    result = '';
    less.render(content, {paths: [path.dirname(pathname)]}, function(err, css) {
        if (err) { throw err; }
        result = css;
    });
    return result;
};

require.extensions['.less'] = function(module, filename) {
    var source;
    source = JSON.stringify(hem.compilers.less(filename));
    return module._compile("module.exports = " + source, filename);
 };

 // Monkey patch importer of LESS to load files synchronously
 less.Parser.importer = function (file, paths, callback) {
    var pathname, data;
    paths.unshift('.');
    for (var i = 0; i < paths.length; i++) {
        try {
            pathname = path.join(paths[i], file);
            fs.statSync(pathname);
            break;
        } catch (e) {
            pathname = null;
        }
    }
    if (!pathname) {
        util.error("file '" + file + "' wasn't found.\n");
        process.exit(1);
    }
    try {
        data = fs.readFileSync(pathname, 'utf-8');
    } catch (e) {
        util.error(e);
    }
    new(less.Parser)({
        paths: [path.dirname(pathname)].concat(paths),
        filename: pathname
    }).parse(data, function (e, root) {
        if (e) less.writeError(e);
        callback(e, root);
    });
};

hem.exec(argv[0]);
