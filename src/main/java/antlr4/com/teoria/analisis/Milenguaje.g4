// Definición de la gramática
grammar Milenguaje;

// Reglas léxicas

CEDULA : [a-zA-Z_] [a-zA-Z0-9_]* ;
NUM_ENTERO : [0-9]+ ;
NUM_DECIMAL : [0-9]+ '.' [0-9]+ ;
BANDERA : '/facto' | '/fake' ;
FRASE   : '"' .*? '"' ;

SI : '/si' ;
SINO : '/sino' ;
MIENTRAS : '/mientras' ;
PARA : '/para' ;
REGRESAR : '/regresar' ;
MOSTRAR : '/mostrar' ;
GUARDAR : '/guardar';

SUMA : '+' ;
RESTA : '-' ;
MULTIPLICACION : '*' ;
DIVISION : '/' ;
MODULO : '%' ;
POTENCIA : '^' ;

IGUAL : '/igual' ;
DIFERENTE : '/diferente' ;
MENOR : '/menor que' ;
MAYOR : '/mayor que' ;
MENOR_IGUAL : '/menor o igual a' ;
MAYOR_IGUAL : '/mayor o igual a' ;

Y : '/y' ;
O : '/o' ;
NEGACION : '/no' ;

PUNTOYCOMA : ';' ;
COMA : ',' ;
PARENTESIS_ABRIR : '(' ;
PARENTESIS_CERRAR : ')' ;
LLAVE_ABRIR : '{' ;
LLAVE_CERRAR : '}' ;


ESPACIO : [ \t\r\n] -> skip ;
COMENTARIO : '//' ~[\r\n]* -> skip ;


// Reglas sintácticas
programa : sentencia* EOF ;

expresion_aritmetica
    : termino (op=(SUMA | RESTA) termino)*  #ExpresionAritmetica;

termino
    : potencia (op=(MULTIPLICACION | DIVISION | MODULO) potencia)*  #TerminoAritmetico;

// Solución a la recursión mutua
temperatura
    : NUM_ENTERO                       #NumeroEntero
    | NUM_DECIMAL                      #NumeroDecimal
    | CEDULA                           #Variable
    | PARENTESIS_ABRIR expresion_aritmetica PARENTESIS_CERRAR  #ParenExpr
    ;

potencia
    : temperatura (POTENCIA potencia)?  #PotenciaExpr;

expresion_relacional
    : expresion_aritmetica (op=(IGUAL | DIFERENTE | MENOR | MAYOR | MENOR_IGUAL | MAYOR_IGUAL)) expresion_aritmetica ;

expresion_logica
    : expresion_relacional (op=(Y | O) expresion_relacional)* ;

declaracion : CEDULA '=' expresion_aritmetica PUNTOYCOMA ;

asignacion : CEDULA '=' (expresion_aritmetica | expresion_logica | FRASE | BANDERA) PUNTOYCOMA ;

si
    : SI PARENTESIS_ABRIR expresion_logica PARENTESIS_CERRAR bloque (SINO bloque)? ;

mientras
    : MIENTRAS PARENTESIS_ABRIR expresion_logica PARENTESIS_CERRAR bloque ;

para
    : PARA PARENTESIS_ABRIR asignacion expresion_logica PUNTOYCOMA asignacion PARENTESIS_CERRAR bloque ;

bloque
    : LLAVE_ABRIR sentencia* LLAVE_CERRAR ;
guardar
    : GUARDAR PARENTESIS_ABRIR CEDULA PARENTESIS_CERRAR PUNTOYCOMA ;

mostrar
    : MOSTRAR PARENTESIS_ABRIR (expresion_aritmetica | FRASE | CEDULA | BANDERA | expresion_logica) PARENTESIS_CERRAR PUNTOYCOMA ;

bandera_o_frase
    : BANDERA  #Bandera
    | FRASE    #Frase;

sentencia
    : declaracion
    | asignacion
    | si
    | mientras
    | mostrar
    | guardar
    | para
    ;