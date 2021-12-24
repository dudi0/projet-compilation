grammar Calculette;

// REGLES 
start
	: expr fin_instruction {System.out.println($expr.code + "WRITE\nPOP\nHALT\n");}
;

expr returns [String code]
	: nexpr fin_instruction {$code = $nexpr.code;}
	| bexpr fin_instruction {$code = $bexpr.code;}
;

fin_instruction
 	: EOF 
	| NEWLINE 
	| ';'
 ;

bexpr returns [String code]
@init{$code = new String();}
	:'(' a=bexpr ')' {$code = $a.code;}
	|'not' a=BOOL {$code = "PUSHI 1\n" + $a.code + "SUB\n";}
	| a=bexpr 'and' b=bexpr {$code=$a.code + $b.code + "MUL\n";}
	| a=bexpr 'or' b=bexpr {$code=$a.code + $b.code + "ADD\n";}
	//| 'not' a=bexpr {
	//| a=bexpr '->' b=bexpr {if($a.code=='true'){$code=$a.code + $b.code + "MUL\n"; }}
	//| BOOL {}
	| BOOL {$code = $code + "PUSHI " + $BOOL.text() +"\n";}
;

nexpr returns [String code]
@init{$code = new String();}
	:'(' a=nexpr ')' {$code = $a.code;}
	| a=nexpr '/' b=nexpr {$code=$a.code + $b.code + "DIV\n";}
	| a=nexpr '*' b=nexpr {$code=$a.code + $b.code + "MUL\n";}  
	| a=nexpr '+' b=nexpr {$code=$a.code + $b.code + "ADD\n";}  
	| a=nexpr '-' b=nexpr {$code=$a.code + $b.code + "SUB\n";}
	| '-' INT {$code = $code + "PUSHI "+ "-" + $INT.int + "\n";} 
	| INT {$code = $code + "PUSHI " + $INT.int + "\n";}
;


// LEXER
NEWLINE : '\r'? '\n' -> skip;
WS : (' '|'\t')+ -> skip;
INT : ('0'..'9')+;
BOOL : 'true' { setText("1"); } | 'false' { setText("0"); };
//BOP : 'and' | 'or';
//NOT : 'not';
UNMATCH : . -> skip;
