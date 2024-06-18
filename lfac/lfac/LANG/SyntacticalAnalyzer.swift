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
    func analyze() {
        var token = tokens[currentTokenIndex]

//        switch token.type {
//        case .space:
//            <#code#>
//        case .terminators:
//            <#code#>
//        case .commentary:
//            <#code#>
//        case .operators:
//            <#code#>
//        case .keyword:
//            <#code#>
//        case .booleans:
//            <#code#>
//        case .integers:
//            <#code#>
//        case .reals:
//            <#code#>
//        case .symbols:
//            <#code#>
//        case .identifiers:
//            <#code#>
//        case .invalidToken:
//            <#code#>
//        }
    }

    func getNextSymbol() -> PToken {
        currentTokenIndex += 1
        return tokens[currentTokenIndex]
    }

    func handleKeyword(keyword: PToken) {
        do {
            switch keyword.value {
            case "program":
                try program()

            case "var":
                try varDeclaration()

            default:
                break
            }

        } catch {
            self.printError(error)
        }
    }


    // MARK: - Programa e Bloco

    /// <programa> ::=
    ///      program <identificador> ; <bloco> .
    func program() throws {
        guard getNextSymbol().type == .identifiers else {
            throw ErrorState.i1
        }

        guard getNextSymbol().type == .terminators else {
            throw ErrorState.t1
        }

        guard getNextSymbol().value == ";" else {
            throw ErrorState.t2
        }

        /// Deu certo
//            print("program encontrado.")
    }

    /// <bloco> ::=
    ///      <parte de declarações de variáveis> 
    ///      <parte de declarações de procedimentos>
    ///      <comando composto>
    func block() throws {

    }


    // MARK: - Declarações
    /// <parte de declarações de variáveis> ::=
    ///     <vazio> |
    ///      var <declaração de variáveis>;
    ///      { <declaração de variáveis>; }
    func declarationVarPart() throws {

    }

    /// <declaração de variáveis> ::=
    ///      <identificador>{,<identificador>} : <tipo>
    func declarationVar() throws {

    }

    /// <lista de identificadores> ::= 
    ///      <identificador> { , <identificador> }
    func declarationListIdentifier() throws {

    }

    /// <tipo> ::=
    ///     integer  | real | boolean
    func declarationType() throws {

    }

    /// <declaração de procedimento> ::=
    ///      { procedure <identificador> [ <parâmetros formais>] ; <bloco> }
    func declarationProcedure() throws {

    }

    /// <parâmetros formais> ::=
    ///      ( <seção de parâmetros formais> { ; <seção de parâmetros formais>} )
    func declarationFormalParameter() throws {

    }

    /// <seção de parâmetros formais> ::=
    ///      { var } <lista de identificadores> : <tipo>
    func declarationFormalParameterSection() throws {

    }


    // MARK: - Comandos
    /// <comando composto> ::= 
    ///      begin <comando> { ; <comando> } end
    func commandComposed() throws {

    }

    /// <comado> ::=
    ///      <atribuição> | <chamada de procedimento> | <comando composto> | <comando condicional 1> | <comando repetitivo 1>
    func command() throws {

    }

    /// <atribuição> ::= 
    ///      <variável> := <expressão>
    func commandAttribution() throws {

    }

    /// <chamada de procedimento> ::=
    ///      <identificador> [ ( <lista de expressões> ) ]
    func commandProcedureCall() throws {

    }

    /// <comando condicional 1> ::=
    ///      if <expressão> then <comando> [ else <comando> ]
    func commandConditional() throws {

    }

    /// <comando repetitivo 1> ::=
    ///      while <expressão> do <comando>
    func commandRepetition() throws {

    }


    // MARK: - Expressões

    /// <expressão> ::=
    ///      <expressão simples> [ <relação> <expressão simples> ]
    func expression() throws {

    }

    /// <relação> ::=
    ///      = | <> | < | <= | >= | >
    func expressionRelation() throws {

    }

    /// <expressão simples> ::=
    ///      [ + | - ] <termo> { ( + | - | or ) <termo> }
    func expressionSimple() throws {

    }

    /// <termo> ::=
    ///      <fator> { ( * | / | div | and ) <fator> }
    func expressionTerm() throws {

    }

    /// <fator> ::=
    ///      <variável> | <número> | ( <expressão> ) | not <fator>
    func expressionFactor() throws {

    }

    /// <variável> ::=
    ///      <identificador>
    func expressionVar() throws {

    }

    /// <lista de expressões> ::=
    ///      <expressão> { , <expressão> }
    func expressionList() throws {

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
