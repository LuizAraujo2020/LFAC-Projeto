//
//  PTokenType.swift
//  lfac
//
//  Created by Luiz Araujo on 13/05/24.
//

import SwiftUI

enum PTokenType: String, Identifiable, CaseIterable, Hashable {
    case space
    //    case endLine
    case terminators
    case separators
    case commentary

    case operators
    case relationals
    case attribution
    
    
    case type
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
            return "OPERADOR_MATEMATICO"
        case .relationals:
            return "OPERADOR_RELACIONAL"
        case .attribution:
            return "OPERADOR_ATRIBUICAO"
        case .symbols:
            return "SIMBOLO"
        case .space:
            return "ESPACO"
        case .commentary:
            return "COMENTARIO"
        case .type:
            return "TIPO"
        case .booleans:
            return "BOOLEANO"
        case .integers:
            return "INTEIRO"
        case .reals:
            return "REAL"
        case .terminators:
            return "TERMINADORES"
        case .separators:
            return "SEPARADORES"
        case .invalidToken:
            return "INVALID_TOKEN"
        }
    }

    var color: Color {
        switch self {
        case .space: return Color.gray
        case .terminators: return Color.black
        case .separators: return Color.gray
        case .commentary: return Color.gray
        case .operators: return Color.orange
        case .relationals: return Color.orange
        case .attribution: return Color.orange
        case .keyword: return Color.blue
        case .type: return Color.green
        case .booleans: return Color.green
        case .integers: return Color.green
        case .reals: return Color.green
        case .symbols: return Color.gray
        case .identifiers: return Color.yellow
        case .invalidToken: return Color.red
        }
    }
}

extension PTokenType {
    static func getType(lexeme: String, dict: Dictionaryable = Dictionary()) -> Self {
        guard !String(lexeme.prefix(2)).contains(dict.commentary) else { return .commentary}

        guard !dict.space.contains(lexeme) else { return .space }

        guard !dict.relationals.contains(lexeme) else { return .relationals }
        guard !dict.operators.contains(lexeme) else { return .operators }
        guard !dict.attribution.contains(lexeme) else { return .attribution }
        guard !dict.terminators.contains(lexeme) else { return .terminators }
        guard !dict.separators.contains(lexeme) else { return .separators }
        guard !dict.symbols.contains(lexeme) else { return .symbols }
        
        guard !dict.types.contains(lexeme) else { return .type }
        
        guard !lexeme.contains(dict.integers) else { return .integers }

        guard !dict.booleans.contains(lexeme) else { return .booleans }
        guard !dict.keywords.contains(lexeme) else { return .keyword }
        guard !lexeme.contains(dict.identifiers) else { return .identifiers }

        // TODO: ⚠️ Fazer depois: .reals
        return .invalidToken
    }
}
