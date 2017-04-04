require('./main.css');
var logoPath = require('./logo.png');
var Elm = require('./Main.elm');

var root = document.getElementById('root');

Elm.Main.embed(root, logoPath);
