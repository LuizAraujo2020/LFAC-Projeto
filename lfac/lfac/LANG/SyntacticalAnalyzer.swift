//
//  SyntacticalAnalyzer.swift
//  lfac
//
//  Created by Luiz Araujo on 17/06/24.
//

import Foundation

final class SyntacticalAnalyzer {
    // MARK: - Properties
    
    /// Tokens
    private var tokens: [PToken]
    
    /// States
    private var currentTokenIndex: Int


    internal init(tokens: [PToken], currentTokenIndex: Int = 0) {
        self.tokens = tokens
        self.currentTokenIndex = currentTokenIndex
    }


    // MARK: - Methods
    func analyze() throws {
        try programa()

        nextSymbol()
        try bloco()

    }

    func getNextSymbol() -> PToken {
        currentTokenIndex += 1
        return tokens[currentTokenIndex]
    }

    func nextSymbol() {
        currentTokenIndex += 1
    }

    // MARK: - Programa e Bloco

    /// <programa> ::=
    ///     program <identificador> ; <bloco> .
    func programa() throws {
        guard tokens[currentTokenIndex].value == "program" else {
            throw ErrorState.p1
        }
        
        nextSymbol()
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState.i1
        }

        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState.t2
        }

        print("program correto.")
    }

    /// <bloco> ::=
    ///     <parte de declarações de variáveis>
    ///     <parte de declarações de procedimentos>
    ///     <comando composto>
    func bloco() throws {
        try parteDeDeclaracoesDeVariaveis()

        nextSymbol()
        try comandoComposto()

        nextSymbol()
        guard tokens[currentTokenIndex].value == "." else {
            throw ErrorState.t3
        }

        guard currentTokenIndex == tokens.count - 1 else {
            throw ErrorState.f1
        }

        print("Bloco de código livre de erros")
    }


    // MARK: - Declarações
    /// <parte de declarações de variáveis> ::=
    ///     <vazio> |
    ///     var <declaração de variáveis>;
    ///     { <declaração de variáveis>; }
    func parteDeDeclaracoesDeVariaveis() throws {
        guard tokens[currentTokenIndex].value == "var" else {
            /// empty, vazio, não tem declarações no código
            return
        }

        nextSymbol()
        while tokens[currentTokenIndex].type == .identifiers {
            try declaracaoDeVariaveis()
            nextSymbol()
        }
    }

    /// <declaração de variáveis> ::=
    ///     <identificador>{,<identificador>} : <tipo>
    ///     var sum: integer;
    func declaracaoDeVariaveis() throws {

        try listaDeIdentificadores()

        guard tokens[currentTokenIndex].value == ":" else {
            throw ErrorState.d3
        }

        nextSymbol()
        try tipo()

        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState.t4
        }
    }

    /// <lista de identificadores> ::= 
    ///     <identificador> { , <identificador> }
    func listaDeIdentificadores() throws {
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState.d1
        }

        nextSymbol()
        while tokens[currentTokenIndex].value == "," {

            nextSymbol()
            guard tokens[currentTokenIndex].type == .identifiers else {
                throw ErrorState.d2
            }

            nextSymbol()
        }
    }

    /// <tipo> ::=
    ///     integer  | real | boolean
    func tipo() throws {
        guard tokens[currentTokenIndex].type == .integers || tokens[currentTokenIndex].type == .reals || tokens[currentTokenIndex].type == .booleans else {
            throw ErrorState.e8
        }
    }

//    /// <declaração de procedimento> ::=
//    ///      { procedure <identificador> [ <parâmetros formais>] ; <bloco> }
//    func declarationProcedure() throws {
//
//    }
//
//    /// <parâmetros formais> ::=
//    ///      ( <seção de parâmetros formais> { ; <seção de parâmetros formais>} )
//    func declarationFormalParameter() throws {
//
//    }
//
//    /// <seção de parâmetros formais> ::=
//    ///      { var } <lista de identificadores> : <tipo>
//    func declarationFormalParameterSection() throws {
//
//    }


    // MARK: - Comandos
    /// <comando composto> ::= 
    ///     begin <comando> { ; <comando> } end
    func comandoComposto() throws {
        var rodandoComandos = true

        guard tokens[currentTokenIndex].type == .keyword, tokens[currentTokenIndex].value == "begin" else {
            // Ver se esse next é necessário
//            nextSymbol()

            /// Se não tem a parte de comandos mas não termina com `.`
            if tokens[currentTokenIndex].value == "." {
                throw ErrorState.f2
            }
            /// Se tem código mas não tá dentro de `begin`
            throw ErrorState.c1
        }


        /// Comandos
        nextSymbol()
        while rodandoComandos {
            rodandoComandos = false

            nextSymbol()
            try comando()

            /// Verifica se o próximo token inicia um dos seguintes comandos:
            ///     - atribuição;
            ///     - comando composto;
            ///     - comando condicional 1;
            ///     - comando repetitivo 1.
            nextSymbol()
            if tokens[currentTokenIndex].type == .identifiers ||
                tokens[currentTokenIndex].value == "begin" ||
                tokens[currentTokenIndex].value == "if" ||
                tokens[currentTokenIndex].value == "while" {
                rodandoComandos = true
            }
        }


        nextSymbol()
        guard tokens[currentTokenIndex].type == .keyword, tokens[currentTokenIndex].value == "end" else {
            throw ErrorState.c2
        }


        // talvez tirar depois
        nextSymbol()
        guard tokens[currentTokenIndex].type == .terminators, tokens[currentTokenIndex].value == "." else {
            throw ErrorState.c3
        }
    }

    /// <comado> ::=
    ///     <atribuição> | <chamada de procedimento> | <comando composto> | <comando condicional 1> | <comando repetitivo 1>
    func comando() throws {
        /// atribuição.
        if tokens[currentTokenIndex].type == .identifiers {
            try atribuicao()

        } else if tokens[currentTokenIndex].value == "begin" {
            /// comando composto.
            try comandoComposto()

        } else if tokens[currentTokenIndex].value == "if" {
            /// comando condicional 1.
            try comandoCondicional()
            
        } else if tokens[currentTokenIndex].value == "while" {
            /// comando repetitivo 1.
            try comandoRepetitivo()
        }
    }

    /// <atribuição> ::= 
    ///     <variável> := <expressão>
    func atribuicao() throws {
        try variavel()
        
        nextSymbol()
        // TODO: Identificar o :=
        
        nextSymbol()
        try expressao()
    }

//    /// <chamada de procedimento> ::=
//    ///     <identificador> [ ( <lista de expressões> ) ]
//    func commandProcedureCall() throws {
//
//    }

    /// <comando condicional 1> ::=
    ///     if <expressão> then <comando> [ else <comando> ]
    func comandoCondicional() throws {

    }

    /// <comando repetitivo 1> ::=
    ///     while <expressão> do <comando>
    func comandoRepetitivo() throws {

    }


    // MARK: - Expressões

    /// <expressão> ::=
    ///     <expressão simples> [ <relação> <expressão simples> ]
    func expressao() throws {

    }

    /// <relação> ::=
    ///     = | <> | < | <= | >= | >
    func relacao() throws {
    }

    /// <expressão simples> ::=
    ///     [ + | - ] <termo> { ( + | - | or ) <termo> }
    func expressaoSimples() throws {

    }

    /// <termo> ::=
    ///     <fator> { ( * | / | div | and ) <fator> }
    func termo() throws {

    }

    /// <fator> ::=
    ///     <variável> | <número> | ( <expressão> ) | not <fator>
    func fator() throws {

    }

    /// <variável> ::=
    ///     <identificador>
    func variavel() throws {
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState.i1
        }
    }

    /// <lista de expressões> ::=
    ///     <expressão> { , <expressão> }
    func listaDeExpressoes() throws {

    }
}

// MARK: - HELPERS
extension SyntacticalAnalyzer {
    func printError(_ error: Error) {
        let token = tokens[currentTokenIndex]

        print("🚨 ERRO ENCONTRADO 🚨")
        print("LINHA : \(token.line)")
        print("COLUNA: \(token.column)")
        print(error.localizedDescription)
    }
}
