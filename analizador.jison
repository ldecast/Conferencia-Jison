/* lexical grammar */
%{
	var cadena = '';
	var errores = [];
%}
%lex

%options case-insensitive
%x string

%%

\s+                   				// Whitespace
"//".*								// EndOfLineComment
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]	// MultiLineComment

/* TOKENS Y PALABRAS RESERVADAS */
"toLower"				return 'prtoLower'
"toUpper"				return 'prtoUpper'
"truncate"				return 'prtruncate'
"round"					return 'prround'
"random"				return 'prrandom'
";"						return 'ptcoma'
","						return 'coma'

"*"                   	return 'multi'
"/"                   	return 'div'
"-"                   	return 'menos'
"+"                   	return 'suma'
"("                   	return 'pabre'
")"                   	return 'pcierra'

([a-zA-Z])([a-zA-Z0-9_])* return 'id'
[0-9]+("."[0-9]+)+\b	return 'doble'
[0-9]+					return 'entero'

["]						{ cadena = ''; this.begin("string"); }
<string>[^"\\]+			{ cadena += yytext; }
<string>"\\\""			{ cadena += "\""; }
<string>"\\n"			{ cadena += "\n"; }
<string>\s				{ cadena += " ";  }
<string>"\\t"			{ cadena += "\t"; }
<string>"\\\\"			{ cadena += "\\"; }
<string>"\\\'"			{ cadena += "\'"; }
<string>"\\r"			{ cadena += "\r"; }
<string>["]				{ yytext = cadena; this.popState(); return 'cadena'; }

<<EOF>>               	return 'EOF'
.                     	{ errores.push({ tipo: "Léxico", error: yytext, linea: yylloc.first_line, columna: yylloc.first_column+1 }); return 'INVALID'; } 

/lex
%{
	// Aquí puede ir código JS
	function nuevoValor(_valor, _tipoValor, _linea, _columna) {
		let obj = {
			valor: _valor,
			tipoValor: _tipoValor,
			linea: _linea,
			columna: _columna
		};
		return obj;
	}

	function nuevaOperacionBinaria(_valor1, _valor2, _tipoOperacion, _linea, _columna) {
		let obj = {
			valor1: _valor1,
			valor2: _valor2,
			tipoOperacion: _tipoOperacion,
			linea: _linea,
			columna: _columna
		};
		return obj;
	}

	function nuevaFuncion(_parametro, _idFuncion, _linea, _columna) {
		let obj = {
			parametro: _parametro,
			idFuncion: _idFuncion,
			linea: _linea,
			columna: _columna
		};
		return obj;
	}

	function funcionDosParametros(_parametro1, _parametro2, _idFuncion, _linea, _columna) {
		let obj = {
			parametro: _parametro1,
			parametro2: _parametro2,
			idFuncion: _idFuncion,
			linea: _linea,
			columna: _columna
		};
		return obj;
	}
%}

/* operator associations and precedence */

%left 'suma' 'menos'
%left 'multi' 'div'
%left umenos
%left 'pabre'

%start ini

%% /* language grammar */

ini: ENTRADA EOF { retorno = { instrucciones: $1, errores: errores }; errores = []; return retorno; }
	| error EOF { retorno = { instrucciones: [], errores: [{ tipo: "Sintáctico", error: "Declaración de instrucción no válida.", linea: this._$.first_line, columna: this._$.first_column+1 }] }; errores = []; return retorno; }
;

ENTRADA: ENTRADA INSTRUCCION { $1.push($2); $$=$1; }
		| INSTRUCCION { $$=[$1]; }
;

INSTRUCCION: EXPRESION ptcoma {$$=$1}
		| FUNCIONESRESERVADAS ptcoma {$$=$1}
		| error ptcoma { $$ = ""; errores.push({ tipo: "Sintáctico", error: "Declaración de instrucción no válida.", linea: this._$.first_line, columna: this._$.first_column+1 }); }
;

EXPRESION: 	EXPRESION suma EXPRESION {$$= nuevaOperacionBinaria($1, $3, 'SUMA', this._$.first_line, this._$.first_column+1);}
			| EXPRESION menos EXPRESION {$$= nuevaOperacionBinaria($1, $3, 'RESTA', this._$.first_line, this._$.first_column+1);}
			| EXPRESION multi EXPRESION {$$= nuevaOperacionBinaria($1, $3, 'MULTIPLICACION', this._$.first_line,this._$.first_column+1);}
			| EXPRESION div EXPRESION {$$= nuevaOperacionBinaria($1, $3, 'DIVISION', this._$.first_line,this._$.first_column+1);}
			| menos EXPRESION %prec umenos {$$= nuevaOperacionBinaria($2, null, 'NEGATIVO', this._$.first_line,this._$.first_column+1);}
			| pabre EXPRESION pcierra {$$=$2}
			| cadena {$$ = nuevoValor($1, 'CADENA', this._$.first_line,this._$.first_column+1)}
			| entero {$$ = nuevoValor($1, 'ENTERO', this._$.first_line,this._$.first_column+1)}
			| doble {$$ = nuevoValor($1, 'DOBLE', this._$.first_line,this._$.first_column+1)}
;

FUNCIONESRESERVADAS: FTOLOWER {$$=$1}
					| FTOUPPER {$$=$1}
					| FTRUNCATE {$$=$1}
					| FROUND {$$=$1}
					| FRANDOM {$$=$1}
;

FTOLOWER: prtoLower pabre EXPRESION pcierra {$$ = nuevaFuncion($3, 'TO_LOWER', this._$.first_line, this._$.first_column+1)}
;

FTOUPPER: prtoUpper pabre EXPRESION pcierra {$$ = nuevaFuncion($3, 'TO_UPPER', this._$.first_line, this._$.first_column+1)}
;

FTRUNCATE: prtruncate pabre EXPRESION pcierra {$$ = nuevaFuncion($3, 'TRUNCATE', this._$.first_line, this._$.first_column+1)}
;

FROUND: prround pabre EXPRESION coma entero pcierra {$$ = funcionDosParametros($3, $5, 'ROUND', this._$.first_line, this._$.first_column+1)}
;

FRANDOM: prrandom pabre EXPRESION coma EXPRESION pcierra {$$ = funcionDosParametros($3, $5, 'RANDOM', this._$.first_line, this._$.first_column+1)}
;

LISTAVALORES: LISTAVALORES coma VALORES {$1.push($3); $$=$1;}
			| VALORES {$$=[$1];}
;

VALORES: EXPRESION {$$=$1}
;