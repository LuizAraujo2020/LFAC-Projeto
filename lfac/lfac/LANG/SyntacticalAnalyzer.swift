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

        do {
            try analyze()
        } catch let error as ErrorState {
            errors.append(error)
        } catch {
            print("🚨 ERRO NÃO TRATADO: \(error.localizedDescription)")
        }
    }


    // MARK: - Methods
    func analyze() throws {
        guard currentTokenIndex < tokens.count else { return }

        do {
            try programa()
//        } catch let error as ErrorState {
//            errors.append(error)
//        } catch {
//            print("🚨 ERRO NÃO TRATADO: \(error.localizedDescription)")
//        }

//        do {
            nextSymbol()
            try fimCodigo()
//        } catch let error as ErrorState {
//            errors.append(error)
//        } catch {
//            print("🚨 ERRO NÃO TRATADO: \(error.localizedDescription)")
//        }

//        do {
            try bloco()
//        } catch let error as ErrorState {
//            errors.append(error)
//        } catch {
//            print("🚨 ERRO NÃO TRATADO: \(error.localizedDescription)")
//        }

//        do {
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
            throw ErrorState.f1(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }

        if currentTokenIndex == tokens.count - 1 && tokens[currentTokenIndex].value != "." {
            throw ErrorState.f2(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
    }

    /// <programa> ::=
    ///     program <identificador> ; <bloco> .
    func programa() throws {
        guard tokens[currentTokenIndex].value == "program" else {
            throw ErrorState.p1(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
        
        nextSymbol()
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState.i1(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }

        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState.t2(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
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
            throw ErrorState.t3(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }

        guard currentTokenIndex == tokens.count - 1 else {
            throw ErrorState.f1(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
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
            
            nextSymbol()
        }
    }

    /// <declaração de variáveis> ::=
    ///     <identificador>{,<identificador>} : <tipo>
    ///     var sum: integer;
    func declaracaoDeVariaveis() throws {

        try listaDeIdentificadores()

        guard tokens[currentTokenIndex].value == ":" else {
            throw ErrorState.d3(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try tipo()

        nextSymbol()
        
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState.t4(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
    }

    /// <lista de identificadores> ::= 
    ///     <identificador> { , <identificador> }
    func listaDeIdentificadores() throws {
        
        
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState.d1(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }

        nextSymbol()
        while tokens[currentTokenIndex].value == "," {
            
            nextSymbol()
            guard tokens[currentTokenIndex].type == .identifiers else {
                throw ErrorState.d2(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
            }

            nextSymbol()
        }
    }

    /// <tipo> ::=
    ///     integer  | real | boolean
    func tipo() throws {
        

        guard tokens[currentTokenIndex].type == .type else {
            throw ErrorState.e8(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
    }

    /// <declaração de procedimento> ::=
    ///     { procedure <identificador> [ <parâmetros formais>] ; <bloco> }
    func declarationProcedure() throws {
        guard tokens[currentTokenIndex].value == "procedure" else {
            throw ErrorState.d6(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
        
        nextSymbol()
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState.i1(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try declarationFormalParameter()
        
        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState.t4(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
        
        nextSymbol()
        try bloco()
    }

    /// <parâmetros formais> ::=
    ///     ( <seção de parâmetros formais> { ; <seção de parâmetros formais>} )
    func declarationFormalParameter() throws {
        var continuarSecao = false
        guard tokens[currentTokenIndex].value == "(" else {
            throw ErrorState.d4(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
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
            throw ErrorState.d5(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
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
            throw ErrorState.d3(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
        
        nextSymbol()
        try tipo()
    }

    
    private func findEndIndex(beginIndex: Int) -> Int {
        
        
        var index = beginIndex + 1
        var beginCount = 0
        
        while index < tokens.count {
            
            let currentToken = tokens[index]
            
            if (currentToken.value == "begin") {
                beginCount += 1
            }
            
            if (currentToken.value == "end") {
                if (beginCount == 0) {
                    
                    return index
                    
                } else {
                    beginCount -= 1
                }
            }
            
            index += 1
        }
        
        return -1
    }
    
    func runBeginEndScope(beginIndex: Int, endIndex: Int) throws {
        
        
        while currentTokenIndex < endIndex {
            nextSymbol()
            
            let token = currentToken()
            
            if (token.type == .identifiers) {
                try atribuicao()
                
                continue
            }
            
            switch (token.value) {
                case "if":
                    try comandoCondicional()
                case "while":
                    try comandoRepetitivo()
                case "begin":
                    let beginIndex: Int = findEndIndex(beginIndex: currentTokenIndex)
                    try runBeginEndScope(beginIndex: currentTokenIndex, endIndex: beginIndex)
                default:
                    break
            }
        }
        
        
    }
            
    private func currentToken() -> PToken {
        return tokens[currentTokenIndex]
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
        
        let beginIndex: Int = findEndIndex(beginIndex: currentTokenIndex)
    
        try runBeginEndScope(beginIndex: currentTokenIndex, endIndex: beginIndex)
        
        return

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
            throw ErrorState.c2(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
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
            throw ErrorState.e7(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
        
        nextSymbol()
        try expressao()

        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState.t4(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
    }

    /// <chamada de procedimento> ::=
    ///     <identificador> [ ( <lista de expressões> ) ]
    func commandProcedureCall() throws {
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState.i1(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
        
        try listaDeExpressoes()
    }

    /// <comando condicional 1> ::=
    ///     if <expressão> then <comando> [ else <comando> ]
    func comandoCondicional() throws {
        guard tokens[currentTokenIndex].value == "if" else {
            throw ErrorState.d7(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
        
        nextSymbol()
        
        // TODO: MUDAR DPS
        guard tokens[currentTokenIndex].value == "(" else {
            throw ErrorState.d4(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
        
        nextSymbol()
        
        try expressao()
        
        nextSymbol()
        
        guard tokens[currentTokenIndex].value == ")" else {
            throw ErrorState.d5(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
        
        nextSymbol()
        guard tokens[currentTokenIndex].value == "then" else {
            throw ErrorState.d8(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
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
            throw ErrorState.d9(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
        }
        
        nextSymbol()
        try expressao()
        
        nextSymbol()
        guard tokens[currentTokenIndex].value == "do" else {
            throw ErrorState.d9(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
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
            throw ErrorState.e7(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
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

        throw ErrorState.e9(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
    }

    /// <variável> ::=
    ///     <identificador>
    func variavel() throws {
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState.i1(tokens[currentTokenIndex].line, tokens[currentTokenIndex].column)
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
