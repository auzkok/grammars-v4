grammar HJSON;

// Parser rules

hjson
   : ENDL* object ENDL*
   | ENDL* pair_list ENDL*
   ;

object
   : '{' ENDL* pair_list '}'
   ;

pair_list
   //: pair (separator+ pair)* separator?
   : (pair | q_pair)*
   ;

pair
   : key ENDL* ':' ENDL* value separator+
   ;

q_pair
   : key ENDL* ':' ENDL* q_string ENDL+
   ;
key
   : J_STRING
   | KEYNAME
   ;

value
   : LITERAL
   | object
   | array
   | NUMBER
   | j_string
   | m_string
   ;

array
   : '[' value (separator value)* separator? ']'
   | '[' ']'
   ;

string
   : j_string
   | m_string
   | q_string
   ;

j_string
   : J_STRING
   ;

m_string
   : M_STRING
   ;

q_string
   : K_CHAR Q_CHAR*
   | KEYNAME ','?  q_string?
   ;

separator
   : separator ENDL
   | ENDL
   | COMMA
   ;

// Lexer rules

LITERAL
   : 'true'
   | 'false'
   | 'null'
   ;



NUMBER
   : '-'? INT FRAC? EXP?
   ;

J_STRING
   : '"' J_CHAR*? '"'
   ;

M_STRING
   : '\'\'\'' M_CHAR* '\'\'\''
   ;

KEYNAME
   : K_CHAR+
   ;

K_CHAR
   //: ~[ ,:[\]{}\t\r\n]
   : [\u0021-\u002B]
   | [\u002D-\u0039]
   | [\u003B-\u005A]
   | [\u005C]
   | [\u005E-\u007A]
   | [\u007C]
   | [\u007E-\u{10FFFF}]
   ;

fragment J_CHAR
   : ESCAPED
   | UNICODE
   | [\u0020-\u0021]
   | [\u0023-\u005B]
   | [\u005D-\u{10FFFF}]
   ;

fragment M_CHAR
   : ' '
   | '\t'
   | '\n'
   | [\u0021-\u{10FFFF}]
   ;

fragment INT
   : [1-9] DIGIT*
   | '0'
   ;

fragment FRAC
   : '.' DIGIT+
   ;

fragment EXP
   : [eE] [+\-] DIGIT+
   ;

fragment DIGIT
   : [0-9]
   ;

fragment ESCAPED
   : SLOSH '"'
   | SLOSH SLOSH
   | SLOSH '/'
   | SLOSH 'b'
   | SLOSH 'f'
   | SLOSH 'n'
   | SLOSH 'r'
   | SLOSH 't'
   ;

fragment UNICODE
   : SLOSH 'u' HEX HEX HEX HEX
   ;

fragment HEX
   : [0-9a-fA-F]
   ;

fragment SLOSH
   : '\u005C'
   ;

//VALUE_SEP
//   : ','
//   | '\n'
//   ;

COMMENT
   : (LINE_COMMENT | BLOCK_COMMENT) -> skip
   ;

fragment LINE_COMMENT
   : ('#' | '//') .*? ('\n' | EOF)
   ;

fragment BLOCK_COMMENT
   : '/*' .*? '*/'
   ;

WS
   : [ \t\r] -> skip
   ;

ENDL
   : '\n'
   ;

COMMA
   : ','
   ;

Q_CHAR
   : [\t\r]
   | [\u0020-\u{10FFFF}]
   ;

PUNCTUATION
   : [ ,:[\]{}\t\r]
   ;