grammar Calculette;

// REGLES 
start
	: calcul EOF {System.out.println($calcul.code + "WRITE\n" + "POP\n" + "HALT\n");}
;

calcul returns [String code]
	: nexpr fin_instruction {$code = $nexpr.code;}
	| bexpr fin_instruction {$code = $bexpr.code;}
//	| declaration fin_instruction {$code = $declaration.code;}
;

fin_instruction
	: NEWLINE
	| ';'
;

nexpr returns [String code]
@init{$code = new String();}
// TODO: pow, gt, lt, eq...
	: LPAR a=nexpr RPAR {$code = $a.code;}
	| a=nexpr MUL_OP b=nexpr {$code=$a.code + $b.code + $MUL_OP.getText() + "\n";}
	| a=nexpr ADD_OP b=nexpr {$code=$a.code + $b.code + $ADD_OP.getText() + "\n";}
	| MINUS INT {$code = $code + "PUSHI "+ "-" + $INT.int + "\n";} 
	| INT {$code = $code + "PUSHI " + $INT.int + "\n";}
;

bexpr returns [String code]
@init{$code = new String();}
// TODO: implication, lazy or
	: LPAR a=bexpr RPAR {$code = $a.code;}
	| NOT a=bexpr {$code = "PUSHI 1\n" + $a.code + "SUB\n";}
	| a=bexpr AND b=bexpr {$code=$a.code + $b.code + "MUL\n";}
	| a=bexpr OR b=bexpr {$code=$a.code + $b.code + "ADD\n";}
	//| a=bexpr '->' b=bexpr {}
	| BOOL {$code = $code + "PUSHI " + $BOOL.getText() +"\n";}
;

/*declaration returns [String code]
#@init{$code = new String();}
	: TYPE ID {}
;
*/

// LEXER
NEWLINE : '\r'? '\n' -> skip;
WS 		: (' '|'\t')+ -> skip;

LPAR	: '(';
RPAR	: ')';

INT 	: [0-9]+;
FLOAT 	: [0-9]+ ('.' [0-9]+)?;

MINUS 	: '-';

ADD_OP 	: '-' {setText("SUB");} | '+' {setText("ADD");};
MUL_OP 	: '*' {setText("MUL");} | '/' {setText("DIV");};

BOOL 	: 'true' {setText("1");} | 'false' {setText("0");};
AND 	: 'and';
OR 		: 'or' ;
NOT 	: 'not' ;

TYPE 	: 'int' | 'float' | 'bool';
ID 		: ([a-zA-Z] | '_') [a-zA-Z0-9]*;

UNMATCH : . -> skip;
