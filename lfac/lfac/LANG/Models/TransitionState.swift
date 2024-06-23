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

enum ErrorState: LocalizedError, Identifiable, Hashable {
    case e1(Int, Int, String), e2(Int, Int), e3(Int, Int), e4(Int, Int), e5(Int, Int), e6(Int, Int), e7(Int, Int), e8(Int, Int), e9(Int, Int)
    case p1(Int, Int)
    case c1(Int, Int), c2(Int, Int), c3(Int, Int)
    case d1(Int, Int), d2(Int, Int), d3(Int, Int), d4(Int, Int), d5(Int, Int), d6(Int, Int), d7(Int, Int), d8(Int, Int), d9(Int, Int), d10(Int, Int), d11(Int, Int)
    case f1(Int, Int), f2(Int, Int)
    case i1(Int, Int)
    case t1(Int, Int), t2(Int, Int), t3(Int, Int), t4(Int, Int)

    var id: String { UUID().uuidString }

    var errorDescription: String? {
        var errorMessage = ""
        switch self {
            /// Generic errors.
        case .e1(let row, let col, let char):
            return "Caracter inválido: \(char)\nLINHA: \(row)\nCOLUNA: \(col)"
        case .e2(let row, let col):
            return "Identificadores não podem conter caracteres especiais.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .e3(let row, let col):
            return "Números não podem conter letras.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .e4(let row, let col):
            return "Números não podem conter caracteres especiais, separe-os com espaço.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .e5(let row, let col):
            return "Números não podem conter mais que um ponto `.`.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .e6(let row, let col):
            return "Símbolo inválido.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .e7(let row, let col):
            return "Operador inválido.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .e8(let row, let col):
            return "Tipo inválido.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .e9(let row, let col):
            return "Fator inválido. Espera-se um número, variável, expressão ou outro fator.\nLINHA: \(row)\nCOLUNA: \(col)"


            /// Program errors.
        case .p1(let row, let col):
            return "O programa deve iniciar com `program`\nLINHA: \(row)\nCOLUNA: \(col)"


            /// Comandos
        case .c1(let row, let col):
            return "A parte de Comandos deve começar com `begin`\nLINHA: \(row)\nCOLUNA: \(col)"
        case .c2(let row, let col):
            return "A parte de Comandos deve fechar com com `end`\nLINHA: \(row)\nCOLUNA: \(col)"
        case .c3(let row, let col):
            return "A parte de Comandos deve terminar com `.`\nLINHA: \(row)\nCOLUNA: \(col)"


            /// Declaration errors.
        case .d1(let row, let col):
            return "Declaração de variáveis deve começar com um Identificador.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .d2(let row, let col):
            return "Declaração de múltiplas variáveis devem ter uma sequencia de Identificadores separados por vírgula.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .d3(let row, let col):
            return "Declaração de variáveis deve ter um `:` entre os Identificadores e o Tipo de variável.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .d4(let row, let col):
            return "Declaração de parâmetros formais deve iniciar com `(`\nLINHA: \(row)\nCOLUNA: \(col)"
        case .d5(let row, let col):
            return "O fim da declaração de parâmetros formais deve finalizar com `)`\nLINHA: \(row)\nCOLUNA: \(col)"
        case .d6(let row, let col):
            return "Declaração de procedimentos deve começar com `procedure\nLINHA: \(row)\nCOLUNA: \(col)"
        case .d7(let row, let col):
            return "Comando condicional deve começar com `if`\nLINHA: \(row)\nCOLUNA: \(col)"
        case .d8(let row, let col):
            return "Comando condicional deve conter `then`\nLINHA: \(row)\nCOLUNA: \(col)"
        case .d9(let row, let col):
            return "Comando repetitivo deve começar com `while`\nLINHA: \(row)\nCOLUNA: \(col)"
        case .d10(let row, let col):
            return "Comando repetitivo deve conter `do`\nLINHA: \(row)\nCOLUNA: \(col)"
        case .d11(let row, let col):
            return "Declaração de variáveis com valoresdeve ter um `:` antes do `=`.\nLINHA: \(row)\nCOLUNA: \(col)"

            /// Identifier errors.
        case .i1(let row, let col):
            return "Um Identificador é esperado.\nLINHA: \(row)\nCOLUNA: \(col)"


            /// Terminator errors.
        case .t1(let row, let col):
            return "Terminador necessário.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .t2(let row, let col):
            return "Terminador inválido.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .t3(let row, let col):
            return "Terminador de bloco inválido.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .t4(let row, let col):
            return "Terminador de instruções inválido, deve ser `;`.\nLINHA: \(row)\nCOLUNA: \(col)"


        /// Final errors
        case .f1(let row, let col):
            return "Programa terminou inesperadamente.\nLINHA: \(row)\nCOLUNA: \(col)"
        case .f2(let row, let col):
            return "Programa deve terminar com `.`.\nLINHA: \(row)\nCOLUNA: \(col)"
        }
    }
}
