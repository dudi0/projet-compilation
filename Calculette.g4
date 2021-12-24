grammar Calculette;

// REGLES 
start
	: expr fin_instruction {System.out.println($expr.code + "WRITE\nPOP\nHALT\n");}
	| bexpr fin_instruction {System.out.println($bexpr.code  + "WRITE\nPOP\nHALT\n");}
;

fin_instruction
 	: EOF 
	| NEWLINE 
	| ';'
 ;

bexpr returns [String code]
@init{$code = new String();}
	: a=bexpr 'and' b=bexpr {$code=$a.code + $b.code + "MUL\n";}
	| a=bexpr 'or' b=bexpr {$code=$a.code + $b.code + "ADD\n";}
	//| 'not' a=bexpr {
	//| a=bexpr '->' b=bexpr {if($a.code=='true'){$code=$a.code + $b.code + "MUL\n"; }}
	//| BOOL {}
	| 'true' {$code = $code + "PUSHI " + "1\n";} 
	| 'false' {$code = $code + "PUSHI " + "0\n";}
;

expr returns [String code]
@init{$code = new String();}
	:'(' expr ')' {$code = $expr;}
	| a=expr '*' b=expr {$code=$a.code + $b.code + "MUL\n";}  
	| a=expr '/' b=expr {$code=$a.code + $b.code + "DIV\n";}
	| a=expr '+' b=expr {$code=$a.code + $b.code + "ADD\n";}  
	| a=expr '-' b=expr {$code=$a.code + $b.code + "SUB\n";}
	| '-' INT {$code = $code + "PUSHI "+ "-" + $INT.int + "\n";} 
	| INT {$code = $code + "PUSHI " + $INT.int + "\n";}
;


// LEXER
NEWLINE : '\r'? '\n' -> skip;
WS : (' '|'\t')+ -> skip;
INT : ('0'..'9')+;
//BOOL : 'true' | 'false';
//BOP : 'and' | 'or';
//NOT : 'not';
UNMATCH : . -> skip;
