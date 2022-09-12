
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
    else if (_expresion.tipo === 'TO_LOWER') {
        const { ToLower } = require("../Funciones/Reservadas");
        return ToLower(_expresion);
    }
    else if (_expresion.tipo === 'TO_UPPER') {
        const { ToUpper } = require("../Funciones/Reservadas");
        return ToUpper(_expresion);
    }
    else if (_expresion.tipo === 'TRUNCATE') {
        const { Truncate } = require("../Funciones/Reservadas");
        return Truncate(_expresion);
    }
    else if (_expresion.tipo === 'ROUND') {
        const { Round } = require("../Funciones/Reservadas");
        return Round(_expresion);
    }
    else return undefined;
}

module.exports = Expresion;