grammar Calculette;
@header {
	import java.util.HashMap;
}
@members { 
	HashMap<String, Integer> variables = new HashMap<String, Integer>();
	int var_len = 0;
}

// REGLES
start returns [String code]
@init{$code = new String();}
@after {System.out.println("HALT\n");}
	: (calcul fin_instruction+ {System.out.println($calcul.code);})+ EOF
;

calcul returns [String code]
	//: (declaration fin_instruction {$code = $declaration.code;})*
	//  (affectation fin_instruction {$code = $affectation.code;})*
	:  (expr {$code = $expr.code+ "WRITE\n" + "POP\n";})*
;

fin_instruction
	: NEWLINE
	| ';'
;

expr returns [String code]
	: nexpr {$code = $nexpr.code;}
	| bexpr {$code = $bexpr.code;}
;
nexpr returns [String code]
// TODO: pow
	: LPAR a=nexpr RPAR 		{$code = $a.code;}
	| a=nexpr MUL_OP b=nexpr 	{$code=$a.code + $b.code + $MUL_OP.getText();}
	| a=nexpr MINUS b=nexpr 	{$code=$a.code + $b.code + $MINUS.getText();}
	| a=nexpr ADD b=nexpr 		{$code=$a.code + $b.code + $ADD.getText();}
	| MINUS INT {$code = $code + "PUSHI "+ "-" + $INT.int + "\n";} 
	| INT 		{$code = $code + "PUSHI " + $INT.int + "\n";}
	| ID 		{$code = "PUSHG " + variables.get($ID.text) + "\n";}
;

bexpr returns [String code]
	: LPAR a=bexpr RPAR 		{$code = $a.code;}
	| NOT a=bexpr 				{$code = "PUSHI 1\n" + $a.code + "SUB\n";}
	| a=bexpr AND b=bexpr 		{$code = $a.code + $b.code + "MUL\n";}
	| a=bexpr OR b=bexpr 		{$code = $a.code + $b.code + "ADD\n" + "PUSHI 0\n" + "NEQ\n";}
	| c=nexpr COMP d=nexpr		{$code = $c.code + $d.code + $COMP.getText() + "\n";}
	| BOOL 	{$code += "PUSHI " + $BOOL.getText();}
	| ID 	{$code = "PUSHG " + variables.get($ID.text) + "\n";}
;

declaration returns [String code]
	: TYPE ID (EQUAL nexpr | bexpr){
		variables.put($ID.text, var_len);
		var_len++;
		$code = "PUSHI 0\n";
	}
	| TYPE affectation
;

affectation returns [String code]
	: ID EQUAL expr{
		$code = $expr.code;
		$code += "STOREG " + variables.get($ID.text);
	}
;

// LEXER
NEWLINE : '\r'? '\n';
WS 		: (' '|'\t')+ -> skip;

LPAR	: '(';
RPAR	: ')';
LACC	: '{';
RACC	: '}';

INT 	: [0-9]+;
FLOAT 	: [0-9]+ ('.' [0-9]+)?;

MINUS 	: '-' {setText("SUB\n");};
ADD 	: '+' {setText("ADD\n");};
MUL_OP 	: '*' {setText("MUL\n");} | '/' {setText("DIV\n");};

BOOL 	: 'true' {setText("1\n");} | 'false' {setText("0\n");};
AND 	: 'and';
OR 		: 'or' ;
NOT 	: 'not' ;
COMP 
	: '=='	{setText("EQUAL\n");}
	| '<>'	{setText("NEQ\n");}
	| '>' 	{setText("SUP\n");}
	| '<' 	{setText("INF\n");}
	| '>='	{setText("SUPEQ\n");}
	| '<='	{setText("INFEQ\n");}
;

TYPE 	: 'int' | 'float' | 'bool';
ID 		: ([a-zA-Z] | '_') [a-zA-Z0-9]*;
EQUAL	: '=';

COMMENT : '/*' .*? '*/' -> skip;

UNMATCH : . -> skip;
