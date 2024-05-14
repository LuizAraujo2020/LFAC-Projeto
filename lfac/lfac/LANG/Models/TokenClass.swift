//
//  TokenClass.swift
//  lfac
//
//  Created by Luiz Araujo on 13/05/24.
//

import Foundation

//enum TokenClass: String, Identifiable, CaseIterable {
//    case keyword = "Keyword"
//    case symbol = "Symbol"
//    case identifier = "Identifier"
//    case number = "Number"
//    case terminator = "Terminator"
//
//    var id: String { self.rawValue }
//}

enum PTokenType: String, Identifiable, CaseIterable {
    case space
    case endLine
    case terminators
    case commentary

    case operatorMath
    case operatorCompare
    case operatorAttribution

    case keyword
    case number
    case symbol
    case identifier

    case invalidToken

    static var allCases: [PTokenType] = [
        .space, .endLine, .terminators, .commentary,
        .operatorMath, .operatorCompare, .operatorAttribution,
        .number, .keyword, .symbol, .identifier,
        .invalidToken
    ]

    var id: String { self.rawValue }

    var name: String {
        switch self {
        case .keyword:
            return "PALAVRA_RESERVADA"
        case .identifier:
            return "NOME_VARIAVEL"
        case .operatorMath:
            return "OPERADOR_MATEMATICO"
        case .operatorCompare:
            return "OPERADOR_COMPARACAO"
        case .operatorAttribution:
            return "OPERADOR_ATRIBUICAO"
        case .symbol:
            return "SIMBOLO"
        case .space:
            return "ESPACO"
        case .commentary:
            return "COMENTARIO"
        case .number:
            return "NUMEROS"
        case .endLine:
            return "FINAL_LINHA"
        case .terminators:
            return "TERMINADORES"
        case .invalidToken:
            return "INVALID_TOKEN"
        }
    }

    var regex: String {
        switch self {
        case .identifier:
            return "^[a-z]+[a-zA-Z0-9]*$"
        case .keyword:
            return "^[program|var|integer|real|boolean|procedure|begin|end|if|then|else|while|do|or|true|false|div|and|not|READ|WRITE]$"
        case .operatorMath:
            return "[+|-|*|/]$"
        case .number:
            return "^(e.*([+|-]?[0-9]+)(([.]?[0-9]+){0,1}([e]{1}[+|-]?[0-9]+)?)*/1)$"//"^(([+|-])?[0-9]+)([.](([0-9]+)?))?(([e|E])(([+|-])?)[0-9]+)?$"//
        case .operatorCompare:
            return "[<|>|=|>=|<=|<>]"
        case .operatorAttribution:
            return "[:=]"
        case .symbol:
            return "^[<|>|=|>=|<=|<>|.|,|;|:=|:|(|)|+|-|*|/]$"
        case .space:
            return "[\\s]"
        case .commentary:
            return "[/]{2}"
        case .endLine:
            return "[\n|\0]"
        case .terminators:
            return "[\\s|\\r|\\n|\\t|\\0]"
        case .invalidToken:
            return ""
        }
    }
}
