//
//  PTokenType.swift
//  lfac
//
//  Created by Luiz Araujo on 13/05/24.
//

import Foundation

enum PTokenType: String, Identifiable, CaseIterable, Hashable {
    case space
//    case endLine
    case terminators
    case commentary

    case operators
    case relationals

    case keyword
    case booleans
    case integers
    case reals
    case symbols
    case identifiers

    case invalidToken

    static var allCases: [PTokenType] = [
        .space, .terminators, .commentary,
        .operators, .relationals,
        .booleans, .integers, .reals, .keyword, .symbols, .identifiers,
        .invalidToken
    ]

    var id: String { self.rawValue }

    var name: String {
        switch self {
        case .keyword:
            return "PALAVRA_RESERVADA"
        case .identifiers:
            return "IDENTIFICADOR"
        case .operators:
            return "OPERADOR"
        case .relationals:
            return "OPERADOR_RELACIONAL"
        case .symbols:
            return "SIMBOLO"
        case .space:
            return "ESPACO"
        case .commentary:
            return "COMENTARIO"
        case .booleans:
            return "BOOLEANO"
        case .integers:
            return "INTEIRO"
        case .reals:
            return "REAL"
        case .terminators:
            return "TERMINADORES"
        case .invalidToken:
            return "INVALID_TOKEN"
        }
    }

    var regex: Regex<(Substring, Substring)> {
        let regexSource = RegexSource()

        switch self {
        case .space:
            return regexSource.space
        case .terminators:
            return regexSource.terminators
        case .commentary:
            return regexSource.commentary
        case .operators:
            return regexSource.operators
        case .relationals:
            return regexSource.relationals
        case .keyword:
            return regexSource.keywords
        case .booleans:
            return regexSource.booleans
        case .integers:
            return regexSource.digits
        case .reals:
            return regexSource.digits
        case .symbols:
            return regexSource.symbol
        case .identifiers:
            return regexSource.letters
        case .invalidToken:
            return /([\^])/ //[^a-zA-Z0-9]/
        }
    }

//    static func examples(type typeAux: Self) -> [String] {
//        switch self {
//        case .space: [" "]
//        case .terminators: [""] .|;|\r|\n|\t|\0|\s
//        case .commentary: [""]
//        case .operators: [""]
//        case .relationals: [""]
//        case .keyword: [""]
//        case .booleans: [""]
//        case .integers: [""]
//        case .reals: [""]
//        case .symbols: [""]
//        case .identifiers: [""]
//        case .invalidToken: [""]
//        }
//    }





//    var letters = /^([a-z]|[A-Z])$/
//    var digits = /^([0-9])$/
//    var booleans = /^(true|false)$/
//    var decimalSign = /^[.|,]{1}$/
//
//    var terminators = /^([\.|;|\r|\n|\t|\0|\s]+)$/
//    var operators = /^([:|<|>|=|\+|\*|\/|\-])$/
//
//    var relationals = /^(=|<>|<|<=|>=|>)$/
//
//    var keywords = /^\b(program|var|integer|real|boolean|procedure|begin|end|if|then|else|while|do|or|true|false|div|and|not|READ|WRITE)\b$/
//    var symbol = /^(\.|\:|;|,|\(|\)|\[|\]|{|})$/
//    var commentary = /^([\/]{2,})$/
//
//    var space = /^([\s]+)$/
//
//    var keywordsArray = ["program", "var", "integer", "real", "boolean", "procedure", "begin", "end", "if", "then", "else", "while", "do", "or", "div", "and", "not", "READ", "WRITE"]

    static func getType(lexeme: String) -> Self {
        // TODO: ⚠️ Fazer depois
        .identifiers
    }
}









