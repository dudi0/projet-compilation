grammar Calculette;

// REGLES 
start
@after {System.out.println("HALT\n");}
	: (calcul fin_instruction {System.out.println($calcul.code);})+
;

calcul returns [String code]
	: nexpr {$code = $nexpr.code+ "WRITE\n" + "POP\n";}
	| bexpr {$code = $bexpr.code+ "WRITE\n" + "POP\n";}
//	| declaration fin_instruction {$code = $declaration.code;}
;

fin_instruction
	: EOF
	| '\n'
	| ';'
;

nexpr returns [String code]
@init{$code = new String();}
// TODO: pow, gt, lt, eq...
	: LPAR a=nexpr RPAR {$code = $a.code;}
	| a=nexpr MUL_OP b=nexpr {$code=$a.code + $b.code + $MUL_OP.getText();}
	| a=nexpr MINUS b=nexpr {$code=$a.code + $b.code + $MINUS.getText();}
	| a=nexpr ADD b=nexpr {$code=$a.code + $b.code + $ADD.getText();}
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

MINUS 	: '-' {setText("SUB\n");};

ADD 	: '+' {setText("ADD\n");};
MUL_OP 	: '*' {setText("MUL\n");} | '/' {setText("DIV\n");};

BOOL 	: 'true' {setText("1");} | 'false' {setText("0");};
AND 	: 'and';
OR 		: 'or' ;
NOT 	: 'not' ;

TYPE 	: 'int' | 'float' | 'bool';
ID 		: ([a-zA-Z] | '_') [a-zA-Z0-9]*;

UNMATCH : . -> skip;
