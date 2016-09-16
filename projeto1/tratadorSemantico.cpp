#include "tratadorSemantico.h"
#include <iostream>
#include <string>


bool tratadorSemantico::avaliarDeclaracao(std::map<std::string, atributo> tabela_simbolos, atributo value){

 //SE o nome da variável não for vazio, é porque é uma variável, e se ela não estiver na tabela de símbolos é porque não foi declarada.
         if (tabela_simbolos.find(std::string(value.var)) == tabela_simbolos.end()){
              std::cout<<"semantic error: undeclared variable  "<<value.var<<"\n";
              exit(0);
	      return false;					   
         }
         //std::cout<<"semantic ok: declared variable  " << value.var<<"\n";
         return true;
}

bool tratadorSemantico::avaliarRepeticaoDeclaracao(std::map<std::string, atributo> tabela_simbolos, atributo value){

 //SE o nome da variável já existe na tabela de simbolos, é porque já foi declarado.
         if (tabela_simbolos.find(std::string(value.var)) != tabela_simbolos.end()){
              std::cout<<"semantic error: re-declaration of variable  "<<value.var<<"\n";
	      return false;					   
         }
         return true;
}

bool tratadorSemantico::avaliarTipoDefinido(atributo value){

 //A variável é indexada na tabela de símbolos antes do seu tipo ser declarado na primeira regra chamada "tipo:".
 //Assim só permito definir um tipo para variável, se ela não tiver o tipo definido antes
         if (std::string(value.type) == ""){
  
	      return true;					   
         }
         return false;
}


bool tratadorSemantico::avaliarOperacao(atributo value_1, atributo value_2, char sinal) {

 //SE o tipo da variável mais a esquerda for diferente do operando a direita, temos erro semântico.
         if (std::string(value_1.type) != std::string(value_2.type)) {
              std::cout <<"semantic error: " << nomeDaOperacaoBinaria(sinal) << " operation expected " <<std::string(value_1.type)<< " but received " <<std::string(value_2.type) <<"\n";       
	      exit(0);
	      return false;					   
         }
         //std::cout <<"semantic ok: " << nomeDaOperacaoBinaria(sinal) << " operation expected " <<std::string(value_1.type)<< " and received " <<std::string(value_2.type) <<"\n";
         return true;
}


bool tratadorSemantico::avaliarOperacao(std::string tipo, atributo value_2, char sinal) {

 //SE o tipo da variável mais a esquerda for diferente do operando a direita, temos erro semântico.
         if (tipo != std::string(value_2.type)) {
              std::cout <<"semantic error: a: " << nomeDaOperacaoBinaria(sinal) << " operation expected " <<tipo<< " but received " << std::string(value_2.type) <<"\n";       
	      exit(0);
	      return false;					   
         }
         return true;
}

std::string tratadorSemantico::nomeDaOperacaoBinaria(char operacao) {
    switch(operacao) {
            case 'a':
                return "attribution";
            case '+':
                return "addition";
            case '-':
                return "subtraction";
            case '*':
                return "multiplication";
            case '/':
                return "division";
            case '&':
                return "and";
            case '|':
                return "or";
            case 'e': // ==
                return "equal";
            case 'd': // !=
                return "different";
            case 'm': // >
                return "greater then";
            case 'h': // >=
                return "greater or equal then";
            case 'r': // <
                return "less then";
            case 'l': // <=
                return "less or equal then";
	}
        return "not found";
}
