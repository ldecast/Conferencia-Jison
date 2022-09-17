
function Expresion(_expresion) {
    if (_expresion.tipoValor === 'DOBLE' ||
        _expresion.tipoValor === 'CADENA' ||
        _expresion.tipoValor === 'ENTERO') {
        const ValorExpresion = require("../model/ValorExpresion");
        return ValorExpresion(_expresion);
    }
    else if (_expresion.tipoOperacion === 'SUMA' || _expresion.tipoOperacion === 'RESTA' ||
        _expresion.tipoOperacion === 'MULTIPLICACION' || _expresion.tipoOperacion === 'DIVISION'
        || _expresion.tipoOperacion === 'NEGATIVO') {
        const Aritmetica = require("../model/Aritmetica");
        return Aritmetica(_expresion);
    }
    else if (_expresion.idFuncion === 'TO_LOWER' || _expresion.idFuncion === 'TO_UPPER'
        || _expresion.idFuncion === 'TRUNCATE' || _expresion.idFuncion === 'ROUND' || _expresion.idFuncion === 'RANDOM') {
        const Funciones = require("../model/Funciones");
        return Funciones(_expresion);
    }
    else return undefined;
}

module.exports = Expresion;