grammar Calculette;

// REGLES 
start
	: calcul fin_instruction {System.out.println($calcul.code + "WRITE\n" + "POP\n" + "HALT\n");}
;

calcul returns [String code]
	: nexpr fin_instruction {$code = $nexpr.code;}
	| bexpr fin_instruction {$code = $bexpr.code;}
	| declaration fin_instruction {$code = $declaration.code;}
;

fin_instruction
	: EOF
	| NEWLINE
	| ';'
;

nexpr returns [String code]
@init{$code = new String();}
// TODO: pow, gt, lt, eq...
	:'(' a=nexpr ')' {$code = $a.code;}
	| a=nexpr MUL_OP b=nexpr {$code=$a.code + $b.code + $MUL_OP.getText();}
	| a=nexpr ADD_OP b=nexpr {$code=$a.code + $b.code + $ADD_OP.getText();}
	| '-' INT {$code = $code + "PUSHI "+ -$INT.int + "\n";} 
	| INT {$code = $code + "PUSHI " + $INT.int + "\n";}
;

bexpr returns [String code]
@init{$code = new String();}
// TODO: implication, lazy or
	:'(' a=bexpr ')' {$code = $a.code;}
	| NOT a=bexpr {$code = "PUSHI 1\n" + $a.code + "SUB\n";}
	| a=bexpr AND b=bexpr {$code=$a.code + $b.code + "MUL\n";}
	| a=bexpr OR b=bexpr {$code=$a.code + $b.code + "ADD\n";}
	//| a=bexpr '->' b=bexpr {}
	| BOOL {$code = $code + "PUSHI " + $BOOL.getText() +"\n";}
;

declaration returns [String code]
@init{$code = new String();}
	: TYPE ID {}
;


// LEXER
NEWLINE : '\r'? '\n' -> skip;
WS 		: (' '|'\t')+ -> skip;

INT 	: [0-9]+;
FLOAT 	: [0-9]+ ('.' [0-9]+)?;
ADD_OP 	: '+' {setText("ADD");} | '-' {setText("SUB");};
MUL_OP 	: '*' {setText("MUL");} | '/' {setText("DIV");};

BOOL 	: 'true' {setText("1");} | 'false' {setText("0");};
AND 	: 'and';
OR 		: 'or' ;
NOT 	: 'not' ;

TYPE 	: 'int' | 'float' | 'bool';
ID 		: ([a-zA-Z] | '_') [a-zA-Z0-9]*;

UNMATCH : . -> skip;
