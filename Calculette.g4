grammar Calculette_21905111;

// REGLES 
start
	: expr EOF {System.out.println($expr.code);}
	| bexpr EOF {System.out.println($bexpr.code);}
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
	: a=expr '*' b=expr {$code=$a.code + $b.code + "MUL\n";}  
	| a=expr '+' b=expr {$code=$a.code + $b.code + "ADD\n";}  
	| a=expr '/' b=expr {$code=$a.code + $b.code + "DIV\n";}
	| a=expr '-' b=expr {$code=$a.code + $b.code + "SUB\n";}
	| '-' INT {$code = $code + "PUSHI "+ "-" + $INT.int + "\n";} 
	| INT {$code = $code + "PUSHI " + $INT.int + "\n";}
;


// LEXER
NEWLINE : '\r'? '\n' -> skip;
WS : (' '|'\t')+ -> skip;
INT : ('0'..'9')+;
BOOL : 'true' | 'false';
BOP : 'and' | 'or';
NOT : 'not';
UNMATCH : . -> skip;