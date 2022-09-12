const express = require('express');
const app = express();
const port = 3080;
let cors = require('cors');

app.use(cors());
app.use(express.json());

const parser = require('./analizador');
const Bloque = require('./controller/procesador');

app.get('/', (req, res) => {
    res.send('Hello from server!');
});

app.post('/compile', (req, res) => {
    var input = req.body.input;
    var ast = parser.parse(input); // { instrucciones: [], errores [] }
    // console.log(ast);
    if (ast.errores.length > 0) {
        console.log('Se encontraron errores al analizar la entrada.', ast.errores);
        res.status(400).send(ast.errores);
    }
    else {
        var salida = Bloque(ast.instrucciones);
        res.send(salida);
    }
});

app.listen(port, () => {
    console.log(`Server listening on the port: ${port}`);
});