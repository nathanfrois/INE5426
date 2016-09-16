// Adaptado de https://github.com/llpilla/compiler_examples/blob/master/simple_ast/ast.h

#ifndef ARVORESINTATICA_H
#define ARVORESINTATICA_H

#pragma once

#include <iostream>
#include <vector>

extern void yyerror(const char *s, ...);

namespace AST {

enum TipoDeVariavel { inteiro, real, boolean };
enum Operacao       { atribuicao, adicao, subtracao, multiplicacao, divisao, e, ou, negacao, inversao, parenteses };

class Nodo;

typedef std::vector<Nodo*> listaDeNodos;

class Nodo {
    public:
        virtual ~Nodo() {}
        virtual void imprimir(){}
        virtual int computar(){return 0;}
};

class Variavel : public Nodo {
     public:
         std::string id;
         Nodo *proximo;
         Variavel(std::string id, Nodo *proximo) : id(id), proximo(proximo) { }
         void imprimir();
         //int computar();
};

class Atribuicao : public Nodo {
     public:
         Nodo *esquerda;
         Nodo *proximo;
         Atribuicao(Nodo *esquerda, Nodo *proximo) : esquerda(esquerda), proximo(proximo) { }
         void imprimir();
         //int computar();
};

class Declaracao : public Nodo {
    public:
        TipoDeVariavel tipo;
        Nodo *direita;
        Declaracao(TipoDeVariavel tipo, Nodo *direita) : tipo(tipo), direita(direita) { }
        void imprimir();
        //int computar();
};

class Inteiro : public Nodo {
    public:
        const char *valor;
        //int valor;        
        Inteiro(const char *valor) : valor(valor) {  }
        void imprimir();
        //int computeTree();
};

class Real : public Nodo {
    public:
        const char *valor;
        //float valor;
        Real(const char *valor) : valor(valor) {  }
        void imprimir();
        //int computar();
};

class Boolean : public Nodo {
    public:
        const char *valor;
        //bool valor;
        Boolean(const char *valor) : valor(valor) {  }
        void imprimir();
        //int computar();
};

class OperacaoBinaria : public Nodo {
    public:
        Nodo *esquerda;        
        Operacao op;
        Nodo *direita;
        OperacaoBinaria(Nodo *esquerda, Operacao op, Nodo *direita) : esquerda(esquerda), op(op), direita(direita) { }
        void imprimir();
        //int computar();
};

class OperacaoUnaria : public Nodo {
    public:
        Operacao op;
        Nodo *direita;
        OperacaoUnaria(Operacao op, Nodo *direita) : op(op), direita(direita) { }
        void imprimir();
        //int computar();
};

class Bloco : public Nodo {
    public:
        listaDeNodos linhas;
        Bloco() { }
        void imprimir();
        void novaLinha(Nodo *linha);
        //int computar();
};

}

#endif 
