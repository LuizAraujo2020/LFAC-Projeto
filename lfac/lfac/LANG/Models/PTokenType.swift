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

    var regex: Regex<Substring> {
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
            // TODO: Fazer depois
            return regexSource.digits
        case .reals:
            // TODO: Fazer depois
            return regexSource.digits
        case .symbols:
            // TODO: Fazer depois
            return regexSource.symbol
        case .identifiers:
            // TODO: Fazer depois
            return regexSource.letters
        case .invalidToken:
            return /[^:<>=+*\/\-.,\\r\\n\\t\\0\\s]/ //[^a-zA-Z0-9]/
        }
    }
}
