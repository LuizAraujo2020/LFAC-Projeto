//
//  TransitionState.swift
//  lfac
//
//  Created by Luiz Araujo on 12/05/24.
//

import Foundation

enum TransitionState: String, Identifiable, CaseIterable {
    case q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14

    var id: String { self.rawValue }

    var isFinal: Bool {
        switch self {
        case .q0, .q1, .q2, .q5, .q7, .q8, .q12, .q10: return false
        case .q3, .q4, .q6, .q9, .q11, .q13, .q14: return true
        }
    }

    var tokenType: PTokenType? {
        switch self {
        case .q3:
            return .keyword
        case .q4:
            return .identifiers
        case .q6:
            return .integers
        case .q9:
            return .reals
        case .q11:
            return .symbols
        case .q13:
            return .operators

        default: return nil
        }
    }

    static var finals: [Self] {
        Self.allCases.filter( { $0.isFinal })
    }
}

enum ErrorState: LocalizedError {
    case e1, e2, e3, e4, e5, e6, e7
    case i1
    case t1, t2

    var errorDescription: String? {
        switch self {
        /// Generic errors.
        case .e1:
            return "Caracter inválido."
        case .e2:
            return "Identificadores não podem conter caracteres especiais."
        case .e3:
            return "Números não podem conter letras."
        case .e4:
            return "Números não podem conter caracteres especiais, separe-os com espaço."
        case .e5:
            return "Números não podem conter mais que um ponto '.'."
        case .e6:
            return "Símbolo inválido."
        case .e7:
            return "Operador inválido."

        /// Identifier errors.
        case .i1:
            return "Um Identificador é esperado."

        /// Terminator errors.
        case .t1:
            return "Terminador necessário."
        case .t2:
            return "Terminador inválido."
        }
    }
}
