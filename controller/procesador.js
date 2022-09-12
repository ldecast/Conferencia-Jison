const Expresion = require("./expresion");

function Bloque(_instrucciones) {
    var salida = '';
    _instrucciones.forEach(instruccion => {
        // console.log(instruccion);
        salida += Expresion(instruccion);
        salida += '\n';
    });
    return salida;
}

module.exports = Bloque