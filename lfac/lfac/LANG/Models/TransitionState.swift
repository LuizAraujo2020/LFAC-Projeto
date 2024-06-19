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
    case e1, e2, e3, e4, e5, e6, e7, e8, e9
    case p1
    case c1, c2, c3
    case d1, d2, d3
    case f1, f2
    case i1
    case t1, t2, t3, t4

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
            return "Números não podem conter mais que um ponto `.`."
        case .e6:
            return "Símbolo inválido."
        case .e7:
            return "Operador inválido."
        case .e8:
            return "Tipo inválido."
        case .e9:
            return "Fator inválido. Espera-se um número, variável, expressão ou outro fator."


            /// Program errors.
        case .p1:
            return "O programa deve iniciar com `program`"
            

            /// Comandos
        case .c1:
            return "A parte de Comandos deve começar com `begin`"
        case .c2:
            return "A parte de Comandos deve fechar com com `end`"
        case .c3:
            return "A parte de Comandos deve terminar com `.`"


            /// Declaration errors.
        case .d1:
            return "Declaração de variáveis deve começar com um Identificador."
        case .d2:
            return "Declaração de múltiplas variáveis devem ter uma sequencia de Identificadores separados por vírgula."
        case .d3:
            return "Declaração de variáveis deve ter um `:` entre os Identificadores e o Tipo de variável."


            /// Identifier errors.
        case .i1:
            return "Um Identificador é esperado."


            /// Terminator errors.
        case .t1:
            return "Terminador necessário."
        case .t2:
            return "Terminador inválido."
        case .t3:
            return "Terminador de bloco inválido."
        case .t4:
            return "Terminador de instruções inválido, deve ser `;`."


        /// Final errors
        case .f1:
            return "Programa terminou inesperadamente."
        case .f2:
            return "Programa deve terminar com `.`."
        }
    }
}
