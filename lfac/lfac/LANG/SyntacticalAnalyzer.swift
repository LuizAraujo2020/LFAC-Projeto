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

        if checkOpenCloseScope() {
            return
        }

        do {
            try programa()

            nextSymbol()
            try fimCodigo()

            try bloco()

            nextSymbol()
            try fimCodigo()
        } catch let error as ErrorState {
            /// Isso ajudará na lógica de vários erros
            errors.append(error)
        } catch {
            print("🚨 ERRO NÃO TRATADO: \(error.localizedDescription)")
        }

    }

    // MARK: - Programa e Bloco

    func fimCodigo() throws {
        if currentTokenIndex < tokens.count - 1 && tokens[currentTokenIndex].value == "." {
            throw ErrorState(type: .f1, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        if currentTokenIndex == tokens.count - 1 && tokens[currentTokenIndex].value != "." {
            throw ErrorState(type: .f2, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        if tokens[tokens.count - 1].value != "." {
            throw ErrorState(type: .f2, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }
    }

    /// <programa> ::=
    ///     program <identificador> ; <bloco> .
    func programa() throws {
        guard tokens[currentTokenIndex].value == "program" else {
            throw ErrorState(type: .p1, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState(type: .i1, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState(type: .t2, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }
    }

    /// <bloco> ::=
    ///     <parte de declarações de variáveis>
    ///     <parte de declarações de procedimentos>
    ///     <comando composto>
    func bloco() throws {
        try parteDeDeclaracoesDeVariaveis()

        nextSymbol()
        guard tokens[currentTokenIndex].value == "begin" else {
            try fimCodigo()
            print("✅ Bloco de código livre de erros")
            return
        }

        nextSymbol()
        //        try comando()
        try comandoComposto()

        nextSymbol()
        guard tokens[currentTokenIndex].value == "end" else {
            throw ErrorState(type: .c2, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try fimCodigo()

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

        var newIteration = tokens[currentTokenIndex + 1].type == .identifiers

        while newIteration {
            nextSymbol()
            try declaracaoDeVariaveis()

            newIteration = tokens[currentTokenIndex + 1].type == .identifiers

        }

        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState(type: .t4, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }
    }

    /// <declaração de variáveis> ::=
    ///     <identificador>{,<identificador>} : <tipo>
    ///     var sum: integer;
    func declaracaoDeVariaveis() throws {

        try listaDeIdentificadores()

        guard tokens[currentTokenIndex].value == ":" else {
            throw ErrorState(type: .d3, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try tipo()

        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState(type: .t4, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }
    }

    /// <lista de identificadores> ::=
    ///     <identificador> { , <identificador> }
    func listaDeIdentificadores() throws {
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState(type: .d1, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        while tokens[currentTokenIndex].value == "," {

            nextSymbol()
            guard tokens[currentTokenIndex].type == .identifiers else {
                throw ErrorState(type: .d2, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
            }

            nextSymbol()
        }
    }

    /// <tipo> ::=
    ///     integer  | real | boolean
    func tipo() throws {
        guard tokens[currentTokenIndex].type == .type else {
            throw ErrorState(type: .e8, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }
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
        tokens[currentTokenIndex + 1].value == "while" ||
        tokens[currentTokenIndex + 1].value == "readln" ||
        tokens[currentTokenIndex + 1].value == "READ" ||
        tokens[currentTokenIndex + 1].value == "writeln" ||
        tokens[currentTokenIndex + 1].value == "WRITE"

        while shouldLoop {
            nextSymbol()
            try comando()

            shouldLoop = tokens[currentTokenIndex + 1].type == .identifiers ||
            tokens[currentTokenIndex + 1].value == "begin" ||
            tokens[currentTokenIndex + 1].value == "if" ||
            tokens[currentTokenIndex + 1].value == "while" ||
            tokens[currentTokenIndex + 1].value == "readln" ||
            tokens[currentTokenIndex + 1].value == "READ" ||
            tokens[currentTokenIndex + 1].value == "writeln" ||
            tokens[currentTokenIndex + 1].value == "WRITE"
        }

        nextSymbol()
        guard tokens[currentTokenIndex].type == .keyword, tokens[currentTokenIndex].value == "end" else {
            throw ErrorState(type: .c4, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try fimCodigo()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState(type: .c2, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }
    }

    /// <comado> ::=
    ///     <atribuição> | <chamada de procedimento> | <comando composto> | <comando condicional 1> | <comando repetitivo 1>
    func comando() throws {

        print("⚠️1 comando: ")
        print("✅ tokens[currentTokenIndex].value: \(tokens[currentTokenIndex].value) | \(tokens[currentTokenIndex].type)")
        print("✅ tokens[currentTokenIndex + 1].value: \(tokens[currentTokenIndex + 1].value)")


        /// atribuição
        if tokens[currentTokenIndex].type == .identifiers {
            try atribuicao()
            return
        }

        /// comando composto.
        if tokens[currentTokenIndex].value == "begin" {
            nextSymbol()
            try comando()

            nextSymbol()
            guard tokens[currentTokenIndex].value == "end" else {
                throw ErrorState(type: .c8, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
            }

            nextSymbol()
            guard tokens[currentTokenIndex].value == ";" else {
                throw ErrorState(type: .c9, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
            }

            return
        }

        /// comando condicional 1.
        if tokens[currentTokenIndex].value == "if" {
            try comandoCondicional()

            return
        }

        /// comando repetitivo 1.
        if tokens[currentTokenIndex].value == "while" {
            try comandoRepetitivo()

            return
        }

        /// readln e writeln
        if tokens[currentTokenIndex].value == "readln" ||
            tokens[currentTokenIndex].value == "READ" ||
            tokens[currentTokenIndex].value == "writeln" ||
            tokens[currentTokenIndex].value == "WRITE" {
            try readWriteln()
            return
        }

        previousSymbol()
    }

    /// leitura e gravação
    /// readln(numero);
    /// writeln(0);
    func readWriteln() throws {
        if tokens[currentTokenIndex].value == "readln" ||
            tokens[currentTokenIndex].value == "READ" ||
            tokens[currentTokenIndex].value == "writeln" ||
            tokens[currentTokenIndex].value == "WRITE" {

            nextSymbol()
            guard tokens[currentTokenIndex].value == "(" else {
                throw ErrorState(type: .c5, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
            }

            nextSymbol()
            // TODO: ⚠️ Deveria ser FATOR?
            guard tokens[currentTokenIndex].type == .identifiers ||
                    tokens[currentTokenIndex].type == .integers ||
                    tokens[currentTokenIndex].type == .reals else {
                throw ErrorState(type: .c7, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
            }

            nextSymbol()
            guard tokens[currentTokenIndex].value == ")" else {
                throw ErrorState(type: .c5, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
            }

            nextSymbol()
            guard tokens[currentTokenIndex].value == ";" else {
                throw ErrorState(type: .c6, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
            }
        }
    }

    /// <atribuição> ::=
    ///     <variável> := <expressão>
    func atribuicao() throws {
        try variavel()

        nextSymbol()
        guard tokens[currentTokenIndex].value == ":=" else {
            throw ErrorState(type: .e7, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try expressao()

        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState(type: .a3, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }
    }

    /// <chamada de procedimento> ::=
    ///     <identificador> [ ( <lista de expressões> ) ]
    func commandProcedureCall() throws {
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState(type: .i1, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        try listaDeExpressoes()
    }

    /// <comando condicional 1> ::=
    ///     if <expressão> then <comando> [ else <comando> ]
    func comandoCondicional() throws {
        guard tokens[currentTokenIndex].value == "if" else {
            throw ErrorState(type: .d7, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try expressao()

        nextSymbol()
        guard tokens[currentTokenIndex].value == "then" else {
            throw ErrorState(type: .d8, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
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
            throw ErrorState(type: .d9, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try expressao()

        nextSymbol()
        guard tokens[currentTokenIndex].value == "do" else {
            throw ErrorState(type: .d9, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
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
            throw ErrorState(type: .e7, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
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

        throw ErrorState(type: .e9, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
    }

    /// <variável> ::=
    ///     <identificador>
    func variavel() throws {
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState(type: .i1, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
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

    /// <declaração de procedimento> ::=
    ///     { procedure <identificador> [ <parâmetros formais>] ; <bloco> }
    func declarationProcedure() throws {
        guard tokens[currentTokenIndex].value == "procedure" else {
            throw ErrorState(type: .d6, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        guard tokens[currentTokenIndex].type == .identifiers else {
            throw ErrorState(type: .i1, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try declarationFormalParameter()

        nextSymbol()
        guard tokens[currentTokenIndex].value == ";" else {
            throw ErrorState(type: .t4, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try bloco()
    }

    /// <parâmetros formais> ::=
    ///     ( <seção de parâmetros formais> { ; <seção de parâmetros formais>} )
    func declarationFormalParameter() throws {
        var continuarSecao = false
        guard tokens[currentTokenIndex].value == "(" else {
            throw ErrorState(type: .d4, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
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
            throw ErrorState(type: .d5, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
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
            throw ErrorState(type: .d3, row: tokens[currentTokenIndex].line, col: tokens[currentTokenIndex].column)
        }

        nextSymbol()
        try tipo()
    }
}

// MARK: - HELPERS
extension SyntacticalAnalyzer {
    private func printError(_ error: LocalizedError) {
        let token = tokens[currentTokenIndex]

        print("🚨 ERRO ENCONTRADO 🚨")
        print("LINHA : \(token.line)")
        print("COLUNA: \(token.column)")
        print(error.localizedDescription)
    }

    private func getNextSymbol() -> PToken {
        currentTokenIndex += 1
        return tokens[currentTokenIndex]
    }

    private func nextSymbol() {
        if currentTokenIndex < tokens.count - 1 {
            currentTokenIndex += 1
        }
    }

    private func previousSymbol() {
    currentTokenIndex -= 1
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

    private func runBeginEndScope(beginIndex: Int, endIndex: Int) throws {
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

    private func checkOpenCloseScope() -> Bool {
        var hasError = false

        var tempIndex = currentTokenIndex

        var countBegin = 0
        var countEnd = 0
        var countParenthesisOpenning = 0
        var countParenthesisClosing = 0

        while tempIndex < tokens.count {
            if tokens[tempIndex].value == "begin" { countBegin += 1 }
            if tokens[tempIndex].value == "end" { countEnd += 1 }

            if tokens[tempIndex].value == "(" { countParenthesisOpenning += 1 }
            if tokens[tempIndex].value == ")" { countParenthesisClosing += 1 }

            tempIndex += 1
        }

        if countBegin != countEnd {
            errors.append(
                ErrorState(
                    type: .e10(countBegin, countEnd),
                    row: nil,
                    col: nil
                )
            )
            hasError = true
        }

        if countParenthesisOpenning != countParenthesisClosing {
            errors.append(
                ErrorState(
                    type: .e11(countParenthesisOpenning, countParenthesisClosing),
                    row: nil,
                    col: nil
                )
            )
            hasError = true
        }

        return hasError
    }
}
