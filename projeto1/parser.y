%{
#include <iostream>
#include <map>
#include <string.h>
#include <string>
#include <cstdio>
#include "estruturas.h"
#include "tratadorSemantico.h"

extern int yylex();
extern void yyerror(const char* s, ...);
%}

%code requires{//estrutura complementar ao union

}


%code{//declaração de variaveis globais

std::map<std::string, atributo> tabela_simbolos;
tratadorSemantico tratador_semantico;
}


%define parse.trace

/* yylval == %union. union informs the different ways we can store data */
%union {
    atributo value;
    char signal;
}

/* token defines our terminal symbols (tokens). */
%token <value>  T_VAR
%token <value>  T_FLOAT T_INT
%token <signal> T_PLUS T_MINUS T_TIMES T_DIV 
%token T_NL T_OPEN T_CLOSE T_EQUAL T_COMMA T_TYPE_INT T_TYPE_FLOAT

/* type defines the type of our nonterminal symbols. Types should match the names used in the union. Example: %type<node> expr */
%type <value> program lines line expr atribuicao atribuicao_composta variavel declaracao tipo primitivoNumerico
%type <signal> sinal


/* Operator precedence for mathematical operators.The latest it is listed, the highest the precedence. left, right, nonassoc */

%left T_PLUS 
%left T_TIMES T_DIV
%left T_OPEN T_CLOSE

/* Starting rule */
%start program

%%

program: lines  /*$$ = $1 when nothing is said*/
       ;

lines: line        /*$$ = $1 when nothing is said*/
     | lines line
     ;

line: T_NL                                                 
    | atribuicao T_NL  { std::cout << "\n\nEntrada: ";  }  
    | tipo T_NL {std::cout <<"\n\nEntrada: ";}
                                            
    ;

primitivoNumerico: T_INT | T_FLOAT;
expr: primitivoNumerico                     {  $$.integer = $1.integer; $$.real = $1.real; 							   $$.type = $1.type;                             }     //std::cout << $$.integer << "\n"; 
//
// Adição
    | expr T_PLUS expr           {  $$.integer = $1.integer + $3.integer; $$.real = $1.real + $3.real; $$.type = $1.type;  
                                    //std::cout << "( " << $1.integer << " + " << $3.integer << " )";
                                 }
// Subtração
    | expr T_MINUS expr          { $$.integer = $1.integer-$3.integer;  $$.real = $1.real - $3.real; $$.type = $1.type;  
                                    //std::cout << "( "<< $1.integer << " - " << $3.integer << " )" << "\n";    
				 }
// Multiplicação por Escalar
    | expr T_TIMES expr        {   $$.integer = $1.integer*$3.integer; $$.real = $1.real * $3.real; $$.type = $1.type;  
                                   //std::cout << $1.integer << " * " << $3.integer  << "\n"; 
                                 }

// Divisão por Escalar
    | expr T_DIV expr          {   $$.integer = $1.integer/$3.integer; $$.real = $1.real / $3.real; $$.type = $1.type;  
                                   //std::cout << "( "<<$1.integer << " ) / " << $3.integer << "\n";
                                 }
// Parênteses
    | T_OPEN expr T_CLOSE        { $$.integer = ($2.integer);  $$.real = ($2.real); $$.type = $2.type;  
                                   //std::cout << "( " << $2.integer << " )\n";
                                 }
// Número negativo
    | T_MINUS expr                 { $$.integer = -1*($2.integer); $$.real = -1*($2.real); $$.type = $2.type;  
                                   //std::cout << "-( " << $2.integer << " )\n";
                                   }                                   
// Fim.
    ;

sinal: T_MINUS | T_PLUS | T_TIMES | T_DIV;

// Atribuição
atribuicao: T_VAR T_EQUAL atribuicao_composta  {if(tratador_semantico.avaliarDeclaracao(tabela_simbolos,$1))
					      {
                   			      	$$.var = $1.var;  $$.integer = $3.integer; $$.type = $3.type; $$.real = $3.real;
	 				   	tabela_simbolos[std::string($$.var)] = $$; //atualizo tabela de simbolos
						if(std::string($$.type) == "int")
							std::cout << "R: "<<std::string($$.var)<<" = "<< $$.integer << "\n";
						else if(std::string($$.type) == "float")
							std::cout << "R: "<<std::string($$.var)<<" = "<< $$.real << "\n";
					      }                                       
					       }          
//Fim.
    ;


//Declaração de variável
tipo: T_TYPE_INT variavel   { $2.type = strdup("int"); 	 tabela_simbolos[std::string($2.var)] = $2;}
    | T_TYPE_FLOAT variavel { $2.type = strdup("float"); tabela_simbolos[std::string($2.var)] = $2;}
    ;

variavel: declaracao {$$ = $1;}| declaracao T_COMMA variavel
    ;
declaracao: T_VAR {$$.var = $1.var;  $$.integer = 0;  $$.real = 0.0;
		  if(tratador_semantico.avaliarRepeticaoDeclaracao(tabela_simbolos, $1))
                     tabela_simbolos[std::string($$.var)] = $$; }
  

    | T_VAR T_EQUAL atribuicao_composta {$$.var = $1.var;  $$.integer = $3.integer; $$.real = $3.real; $$.type = $3.type;
				      if(tratador_semantico.avaliarRepeticaoDeclaracao(tabela_simbolos, $1))
                   			    tabela_simbolos[std::string($$.var)] = $$; } 
    ;

// Atribuição simples, variável negativa, parênteses e somente algébrica.
atribuicao_composta: T_VAR  {if(tratador_semantico.avaliarDeclaracao(tabela_simbolos,$1))
				   $$.integer = tabela_simbolos[std::string($1.var)].integer;  
				   $$.type    = tabela_simbolos[std::string($1.var)].type; 
                            }

    | T_MINUS T_VAR         {if(tratador_semantico.avaliarDeclaracao(tabela_simbolos,$2))
				   $$.integer = -1*tabela_simbolos[std::string($2.var)].integer;
				   $$.type    = tabela_simbolos[std::string($2.var)].type; 
                            }

    | T_OPEN  T_VAR T_CLOSE  { if(tratador_semantico.avaliarDeclaracao(tabela_simbolos,$2))
				   $$.integer = (tabela_simbolos[std::string($2.var)].integer);     
				   $$.type    = tabela_simbolos[std::string($2.var)].type;                         
                            }

    | T_OPEN  atribuicao_composta T_CLOSE  { $$.integer = ($2.integer); 
					     $$.type = tabela_simbolos[std::string($2.var)].type;          
			                   }

    | expr		                   { $$.integer = $1.integer;
					     $$.type = $1.type;          
 					   }

//Generalizando operações com expressões numéricas e variáveis
    | T_VAR sinal atribuicao_composta { 
                  if(tratador_semantico.avaliarDeclaracao(tabela_simbolos,$1)){ 

							   int iop1 = tabela_simbolos[std::string($1.var)].integer;
							   int iop2 = $3.integer;
							   double dop1 = tabela_simbolos[std::string($1.var)].real;
							   double dop2 = $3.real;
							   $$.type = $1.type; //tipo mais a esquerda sobe                             
							     switch($2)
                                                             {
                                                              case '+': 
                                                              $$.integer = iop1 + iop2;
                                                              $$.real = dop1 + dop2;
 							      break;

							      case '-': 
                                                              $$.integer = iop1 - iop2;
                                                              $$.real = dop1 + dop2;
 							      break;

 							      case '*': 
                                                              $$.integer = iop1 * iop2; 
                                                              $$.real = dop1 + dop2;
 							      break;

							      case '/': 
                                                              $$.integer = iop1 / iop2; 
                                                              $$.real = dop1 + dop2;
 							      break;
                                                             }
					                 }
						    }
    | expr sinal atribuicao_composta {                      
							   int iop1 = $1.integer;
							   int iop2 = $3.integer;
							   double dop1 = $1.real;
							   double dop2 = $3.real;  
							   $$.type = $1.type; //tipo mais a esquerda sobe                             
							     switch($2)
                                                             {
                                                              case '+': 
                                                              $$.integer = iop1 + iop2;
                                                              $$.real = dop1 + dop2;
 							      break;

							      case '-': 
                                                              $$.integer = iop1 - iop2;
                                                              $$.real = dop1 + dop2;
 							      break;

 							      case '*': 
                                                              $$.integer = iop1 * iop2; 
                                                              $$.real = dop1 + dop2;
 							      break;

							      case '/': 
                                                              $$.integer = iop1 / iop2; 
                                                              $$.real = dop1 + dop2;
 							      break;
                                                             }
					                 }
						   
						   
//Fim.
    ;

%%

