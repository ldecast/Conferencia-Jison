const Expresion = require("../controller/expresion");

function Aritmetica(_operacion) {
    let v1 = Expresion(_operacion.valor1);
    let v2 = _operacion.valor2 ? Expresion(_operacion.valor2) : 0; // Para negativos
    switch (_operacion.tipoOperacion) {
        case 'SUMA':
            return v1 + v2;
        case 'RESTA':
            return v1 - v2;
        case 'MULTIPLICACION':
            return v1 * v2;
        case 'DIVISION':
            return v1 / v2;
        case 'NEGATIVO':
            return v2 - v1;
        default:
            return undefined;
    }
}

module.exports = Aritmetica;