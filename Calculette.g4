grammar Calculette;

@header {
	import java.util.HashMap;
}

@members { 
	HashMap<String, Integer> memory = new HashMap<String, Integer>();
	int var_len = 0;
	int label = -1;
}

// REGLES
start returns [String code]
@init{int i; $code = new String();}
@after{ for(i = 0; i < var_len; i++) {$code += "POP\n";}
		$code += "HALT\n";
		System.out.println($code);}
	: (declaration fin_instruction+ {$code += $declaration.code;})*
	  (instruction fin_instruction+ {$code += $instruction.code;})* 
	  //(comparaison fin_instruction+ {$code += $comparaison.code + "POP\n";})*
	  EOF
;

instruction returns [String code]
	: assignation 	{$code = $assignation.code;}
	| expr 			{$code = $expr.code + "POP\n";}
	| afficher 		{$code = $afficher.code;}
	//| comparaison 	{$code = $comparaison.code + "POP\n";}
	| if_instr		{$code=$if_instr.code;}
	//| while_instr{}
;

fin_instruction
	: SEMICOLON
    | NEWLINE
;

expr returns [String code]
	: nexpr {$code = $nexpr.code;}
	| bexpr {$code = $bexpr.code;}	
;

nexpr returns [String code]
// TODO: pow
	: LPAR a=nexpr RPAR 		{$code = $a.code;}
	| a=nexpr MUL_OP b=nexpr 	{$code = $a.code + $b.code + $MUL_OP.getText();}
	| a=nexpr MINUS b=nexpr 	{$code = $a.code + $b.code + $MINUS.getText();}
	| a=nexpr ADD b=nexpr 		{$code = $a.code + $b.code + $ADD.getText();}
	| MINUS INT {$code = "PUSHI "+ "-" + $INT.int + "\n";} 
	| INT 		{$code = "PUSHI " + $INT.int + "\n";}
	| ID 		{$code = "PUSHG " + memory.get($ID.text) + "\n";}
;

bexpr returns [String code]
	: LPAR a=bexpr RPAR 		{$code = $a.code;}
	| NOT a=bexpr 				{$code = "PUSHI 1\n" + $a.code + "SUB\n";}
	| a=bexpr AND b=bexpr 		{$code = $a.code + $b.code + "MUL\n";}
	| a=bexpr OR b=bexpr 		{$code = $a.code + $b.code + "ADD\n" + "PUSHI 0\n" + "NEQ\n";}
	| BOOL 	{$code = "PUSHI " + $BOOL.getText();}
	| ID 	{$code = "PUSHG " + memory.get($ID.text) + "\n";}
;

comparaison returns [String code]
    : a=expr COMP b=expr {$code = $a.code + $b.code + $COMP.getText();}
    | NOT comparaison {$code = "PUSHI 1\n" + $comparaison.code + "SUB\n";}
    | bexpr {$code = $bexpr.code;}
;

declaration returns [String code]
	: TYPE ID {
		memory.put($ID.text, var_len);
		var_len++;
		$code = "PUSHI 0\n";
	}
;

assignation returns [String code]
	: ID EQ expr {
		$code = $expr.code;
		$code += "STOREG " + memory.get($ID.text) + "\n";
	}
;

afficher returns [String code]
	: PRINT LPAR expr RPAR {$code = $expr.code + "WRITE\n" + "POP\n";}
	| PRINT LPAR comparaison RPAR {$code = $comparaison.code + "WRITE\n" + "POP\n";}
;

bloc returns [String code]
	: LACC NEWLINE+ 
		(instruction {$code += $instruction.code;} fin_instruction+)+
	  RACC 
;

condition returns [String code]
    : bexpr {$code = $bexpr.code;}
    | comparaison {$code = $comparaison.code;}
;

if_instr returns [String code]
@init{ 	label++;
		int label_if = label;
		label++;
		int label_else = label;
		String else_instr = new String();
	 }
	: IF LPAR condition RPAR {
		$code = $condition.code;
		$code += "JUMPF " + label_if + "\n";
	 }
	 (bloc {$code += $bloc.code;}
	 | NEWLINE* instruction {$code += $instruction.code;}) 
	 NEWLINE*
	 (ELSE {$code += "JUMP " + label_else + "\n";} 
	 (bloc {else_instr = $bloc.code;} 
	 | NEWLINE* instruction {else_instr = $instruction.code;}))? 
	 {
		$code += "LABEL " + label_if + "\n";
		if(else_instr != "") {
			$code += else_instr;
			$code += "LABEL " + label_else + "\n";
		}	
	 }
	 NEWLINE*
;


// LEXER
NEWLINE : '\r'? '\n';
WS 		: (' '|'\t')+ -> skip;

SEMICOLON : ';';

LPAR	: '(';
RPAR	: ')';
LACC	: '{';
RACC	: '}';

EQ		: '=';
PRINT	: 'afficher' | 'print';
IF		: 'si' | 'if';
ELSE 	: 'sinon' | 'else';

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

COMMENT : '/*' .*? '*/' -> skip;

UNMATCH : . -> skip;