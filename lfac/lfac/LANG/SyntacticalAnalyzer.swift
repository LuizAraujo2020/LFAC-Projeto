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

    /// Errors
    var errors = [ErrorState]()

    /// States
    private var currentTokenIndex: Int


    internal init(
        tokens: [PToken],
        currentTokenIndex: Int = 0
    ) {
        self.tokens = tokens
        self.currentTokenIndex = currentTokenIndex
    }


    // MARK: - Methods
    func analyze() {
        do {
            try programa()
        } catch let error as ErrorState {
            errors.append(error)
        } catch {
            print("🚨 ERRO NÃO TRATADO: \(error.localizedDescription)")
        }

        do {
            nextSymbol()
            try fimCodigo()
        } catch let error as ErrorState {
            errors.append(error)
        } catch {
            print("🚨 ERRO NÃO TRATADO: \(error.localizedDescription)")
        }

        do {
            try bloco()
        } catch let error as ErrorState {
            errors.append(error)
        } catch {
            print("🚨 ERRO NÃO TRATADO: \(error.localizedDescription)")
        }

        do {
            nextSymbol()
            try fimCodigo()
        } catch let error as ErrorState {
            errors.append(error)
        } catch {
            print("🚨 ERRO NÃO TRATADO: \(error.localizedDescription)")
        }
    }

    func getNextSymbol() -> PToken {
        currentTokenIndex += 1
        return tokens[currentTokenIndex]
    }

    func nextSymbol() {
        if currentTokenIndex < tokens.count - 1 {
            currentTokenIndex += 1
        }
    }
    
    func previousSymbol() {
        currentTokenIndex -= 1
    }

    // MARK: - Programa e Bloco

    func fimCodigo() throws {
        if currentTokenIndex < tokens.count - 1 && tokens[currentTokenIndex].value == "." {
            throw ErrorState.f1
        }

        if currentTokenIndex == tokens.count - 1 && tokens[currentTokenIndex].value != "." {
            throw ErrorState.f2
        }
    }

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
    }

    /// <bloco> ::=
    ///     <parte de declarações de variáveis>
    ///     <parte de declarações de procedimentos>
    ///     <comando composto>
    func bloco() throws {
        try parteDeDeclaracoesDeVariaveis()

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

        var newIteration = tokens[currentTokenIndex + 1].type == .identifiers || tokens[currentTokenIndex + 1].value == "var"

        while newIteration {
            nextSymbol()
            try declaracaoDeVariaveis()

            newIteration = tokens[currentTokenIndex + 1].type == .identifiers || tokens[currentTokenIndex + 1].value == "var"
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

    /// <declaração de procedimento> ::=
    ///     { procedure <identificador> [ <parâmetros formais>] ; <bloco> }
    func declarationProcedure() throws {
        guard tokens[currentTokenIndex].value == "procedure" else {
            throw ErrorState.d6
        }
        
        nextSymbol()
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState.i1
        }

        nextSymbol()
        try declarationFormalParameter()
        
        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState.t4
        }
        
        nextSymbol()
        try bloco()
    }

    /// <parâmetros formais> ::=
    ///     ( <seção de parâmetros formais> { ; <seção de parâmetros formais>} )
    func declarationFormalParameter() throws {
        var continuarSecao = false
        guard tokens[currentTokenIndex].value == "(" else {
            throw ErrorState.d4
        }
        
        try declarationFormalParameterSection()

        let nextSymbolValue = tokens[currentTokenIndex + 1].value
        if nextSymbolValue == ";" {
            continuarSecao = true
            nextSymbol()
        }
        
        while continuarSecao {
            continuarSecao = false

            nextSymbol()
            try declarationFormalParameterSection()
            
            let nextSymbolValue = tokens[currentTokenIndex + 1].value
            if nextSymbolValue == ";" {
                continuarSecao = true
                nextSymbol()
            }
        }
        
        nextSymbol()
        guard tokens[currentTokenIndex].value == ")" else {
            throw ErrorState.d5
        }
    }

    /// <seção de parâmetros formais> ::=
    ///     [ var ]  <lista de identificadores> : <tipo>
    func declarationFormalParameterSection() throws {
        if tokens[currentTokenIndex].value == "var" {
            nextSymbol()
        }
        
        try listaDeIdentificadores()
        
        nextSymbol()
        guard tokens[currentTokenIndex].value == ":" else {
            throw ErrorState.d3
        }
        
        nextSymbol()
        try tipo()
    }


    // MARK: - Comandos
    /// <comando composto> ::= 
    ///     begin <comando> { ; <comando> } end
    func comandoComposto() throws {
        guard tokens[currentTokenIndex].type == .keyword, tokens[currentTokenIndex].value == "begin" else {
            // Ver se esse next é necessário
//            nextSymbol()

            try fimCodigo()
            return
        }

        /// Comandos

        /// Verifica se o próximo token inicia um dos seguintes comandos:
        ///     - atribuição;
        ///     - comando composto;
        ///     - comando condicional 1;
        ///     - comando repetitivo 1.
        var shouldLoop = tokens[currentTokenIndex + 1].type == .identifiers ||
                        tokens[currentTokenIndex + 1].value == "begin" ||
                        tokens[currentTokenIndex + 1].value == "if" ||
                        tokens[currentTokenIndex + 1].value == "while"

        while shouldLoop {
            nextSymbol()
            try comando()

            shouldLoop = tokens[currentTokenIndex + 1].type == .identifiers ||
                        tokens[currentTokenIndex + 1].value == "begin" ||
                        tokens[currentTokenIndex + 1].value == "if" ||
                        tokens[currentTokenIndex + 1].value == "while"
        }

        nextSymbol()
        guard tokens[currentTokenIndex].type == .keyword, tokens[currentTokenIndex].value == "end" else {
            throw ErrorState.c2
        }
    }

    /// <comado> ::=
    ///     <atribuição> | <chamada de procedimento> | <comando composto> | <comando condicional 1> | <comando repetitivo 1>
    func comando() throws {
        /// atribuição
        if tokens[currentTokenIndex].type == .identifiers {
            try atribuicao()

        /// comando composto.
        } else if tokens[currentTokenIndex].value == "begin" {
            try comandoComposto()

        /// comando condicional 1.
        } else if tokens[currentTokenIndex].value == "if" {
            try comandoCondicional()

        /// comando repetitivo 1.
        } else if tokens[currentTokenIndex].value == "while" {
            try comandoRepetitivo()
        }
    }

    /// <atribuição> ::= 
    ///     <variável> := <expressão>
    func atribuicao() throws {
        try variavel()

        nextSymbol()
        guard tokens[currentTokenIndex].value == ":=" else {
            throw ErrorState.e7
        }
        
        nextSymbol()
        try expressao()

        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState.t4
        }
    }

    /// <chamada de procedimento> ::=
    ///     <identificador> [ ( <lista de expressões> ) ]
    func commandProcedureCall() throws {
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState.i1
        }
        
        try listaDeExpressoes()
    }

    /// <comando condicional 1> ::=
    ///     if <expressão> then <comando> [ else <comando> ]
    func comandoCondicional() throws {
        guard tokens[currentTokenIndex].value == "if" else {
            throw ErrorState.d7
        }
        
        nextSymbol()
        try expressao()
        
        nextSymbol()
        guard tokens[currentTokenIndex].value == "then" else {
            throw ErrorState.d8
        }
        
        nextSymbol()
        try comando()
        
        if tokens[currentTokenIndex + 1].value == "else" {
            nextSymbol()
            
            nextSymbol()
            try comando()
        }
    }


    /// <comando repetitivo 1> ::=
    ///     while <expressão> do <comando>
    func comandoRepetitivo() throws {
        guard tokens[currentTokenIndex].value == "while" else {
            throw ErrorState.d9
        }
        
        nextSymbol()
        try expressao()
        
        nextSymbol()
        guard tokens[currentTokenIndex].value == "do" else {
            throw ErrorState.d9
        }
        
        nextSymbol()
        try comando()
    }


    // MARK: - Expressões

    /// <expressão> ::=
    ///     <expressão simples> [ <relação> <expressão simples> ]
    func expressao() throws {
        try expressaoSimples()

        var shouldLoop = tokens[currentTokenIndex + 1].type == .relationals
        while shouldLoop {
            nextSymbol()
            try expressaoSimples()

            shouldLoop = tokens[currentTokenIndex + 1].type == .relationals
        }
    }

    /// <relação> ::=
    ///     = | <> | < | <= | >= | >
    func relacao() throws {
        guard tokens[currentTokenIndex].value == "=" ||
                tokens[currentTokenIndex].value == "<>" ||
                tokens[currentTokenIndex].value == "<" ||
                tokens[currentTokenIndex].value == "<=" ||
                tokens[currentTokenIndex].value == ">=" ||
                tokens[currentTokenIndex].value == ">" else {
            throw ErrorState.e7
        }
    }

    /// <expressão simples> ::=
    ///     [ + | - ] <termo> { ( + | - | or ) <termo> }
    func expressaoSimples() throws {
        var continuarTermo = false
        
        if tokens[currentTokenIndex].value == "+" || tokens[currentTokenIndex].value == "-" {
            nextSymbol()
        }
        
        try termo()

        try fimCodigo()

        let nextSymbolValue = tokens[currentTokenIndex + 1].value
        if nextSymbolValue == "+" || nextSymbolValue == "-" || nextSymbolValue == "or" {
            continuarTermo = true
            nextSymbol()
        }
        
        while continuarTermo {
            continuarTermo = false

            nextSymbol()
            try termo()
            
            let nextSymbolValue = tokens[currentTokenIndex + 1].value
            if nextSymbolValue == "+" || nextSymbolValue == "-" || nextSymbolValue == "or" {
                continuarTermo = true
                nextSymbol()
            }
        }
    }

    /// <termo> ::=
    ///     <fator> { ( * | / | div | and ) <fator> }
    func termo() throws {
        var continuarFator = false
        
        try fator()

        try fimCodigo()

        let nextSymbolValue = tokens[currentTokenIndex + 1].value
        if nextSymbolValue == "*" || nextSymbolValue == "/" || nextSymbolValue == "div" || nextSymbolValue == "and" {
            continuarFator = true
            nextSymbol()
        }
        
        while continuarFator {
            continuarFator = false

            nextSymbol()
            try termo()
            
            let nextSymbolValue = tokens[currentTokenIndex + 1].value
            if nextSymbolValue == "*" || nextSymbolValue == "/" || nextSymbolValue == "div" || nextSymbolValue == "and" {
                continuarFator = true
                nextSymbol()
            }
        }
    }

    /// <fator> ::=
    ///     <variável> | <número> | ( <expressão> ) | not <fator>
    func fator() throws {
        guard tokens[currentTokenIndex].type != .identifiers &&
              tokens[currentTokenIndex].type != .integers &&
              tokens[currentTokenIndex].type != .reals else {
             return
        }

        /// not <fator>
        guard tokens[currentTokenIndex].value != "not" else {
            nextSymbol()
            try fator()
            return
        }

        /// <expressão>
        do {
            try expressao()
            return
        } catch { }

        throw ErrorState.e9
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
        var continuarExpressao = false
        
        try expressao()

        try fimCodigo()

        let nextSymbolValue = tokens[currentTokenIndex + 1].value
        if nextSymbolValue == "," {
            continuarExpressao = true
            nextSymbol()
        }
        
        while continuarExpressao {
            continuarExpressao = false

            nextSymbol()
            try expressao()
            
            let nextSymbolValue = tokens[currentTokenIndex + 1].value
            if nextSymbolValue == "," {
                continuarExpressao = true
                nextSymbol()
            }
        }
    }
}

// MARK: - HELPERS
extension SyntacticalAnalyzer {
    func printError(_ error: LocalizedError) {
        let token = tokens[currentTokenIndex]

        print("🚨 ERRO ENCONTRADO 🚨")
        print("LINHA : \(token.line)")
        print("COLUNA: \(token.column)")
        print(error.localizedDescription)
    }
}
