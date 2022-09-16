const Expresion = require("../controller/expresion");

function Funciones(_reservada) {
    let valor = Expresion(_reservada.parametro);
    switch (_reservada.idFuncion) {
        case 'TO_LOWER':
            return String(valor).toLowerCase();
        case 'TO_UPPER':
            return String(valor).toUpperCase();
        case 'TRUNCATE':
            return Math.trunc(valor);
        case 'ROUND':
            let decimals = parseInt(_reservada.decimales);
            return valor.toFixed(decimals);
        default:
            console.log("Error al reconocer: ", _reservada)
            return undefined;
    }
}

module.exports = Funciones;