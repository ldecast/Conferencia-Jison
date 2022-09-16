function ValorExpresion(_expresion) {
    switch (_expresion.tipoValor) {
        case 'CADENA':
            return String(_expresion.valor);
        case 'ENTERO':
            return parseInt(_expresion.valor);
        case 'DOBLE':
            return parseFloat(_expresion.valor);
        default:
            console.log("Error al reconocer: ", _expresion)
            return undefined;
    }
}

module.exports = ValorExpresion;