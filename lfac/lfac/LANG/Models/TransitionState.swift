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
    case e1(Int, String), e2(Int), e3(Int), e4(Int), e5(Int), e6(Int), e7(Int), e8(Int), e9(Int)
    case p1(Int)
    case c1(Int), c2(Int), c3(Int)
    case d1(Int), d2(Int), d3(Int), d4(Int), d5(Int), d6(Int), d7(Int), d8(Int), d9(Int), d10(Int), d11(Int)
    case f1(Int), f2(Int)
    case i1(Int)
    case t1(Int), t2(Int), t3(Int), t4(Int)

    var id: String { UUID().uuidString }

    var errorDescription: String? {
        switch self {
            /// Generic errors.
        case .e1(let row, let char):
            return "LINHA\(row): Caracter inválido: \(char)"
        case .e2(let row):
            return "LINHA\(row): Identificadores não podem conter caracteres especiais."
        case .e3(let row):
            return "LINHA\(row): Números não podem conter letras."
        case .e4(let row):
            return "LINHA\(row): Números não podem conter caracteres especiais, separe-os com espaço."
        case .e5(let row):
            return "LINHA\(row): Números não podem conter mais que um ponto `.`."
        case .e6(let row):
            return "LINHA\(row): Símbolo inválido."
        case .e7(let row):
            return "LINHA\(row): Operador inválido."
        case .e8(let row):
            return "LINHA\(row): Tipo inválido."
        case .e9(let row):
            return "LINHA\(row): Fator inválido. Espera-se um número, variável, expressão ou outro fator."


            /// Program errors.
        case .p1(let row):
            return "LINHA\(row): O programa deve iniciar com `program`"


            /// Comandos
        case .c1(let row):
            return "LINHA\(row): A parte de Comandos deve começar com `begin`"
        case .c2(let row):
            return "LINHA\(row): A parte de Comandos deve fechar com com `end`"
        case .c3(let row):
            return "LINHA\(row): A parte de Comandos deve terminar com `.`"


            /// Declaration errors.
        case .d1(let row):
            return "LINHA\(row): Declaração de variáveis deve começar com um Identificador."
        case .d2(let row):
            return "LINHA\(row): Declaração de múltiplas variáveis devem ter uma sequencia de Identificadores separados por vírgula."
        case .d3(let row):
            return "LINHA\(row): Declaração de variáveis deve ter um `:` entre os Identificadores e o Tipo de variável."
        case .d4(let row):
            return "LINHA\(row): Declaração de parâmetros formais deve iniciar com `(`"
        case .d5(let row):
            return "LINHA\(row): O fim da declaração de parâmetros formais deve finalizar com `)`"
        case .d6(let row):
            return "LINHA\(row): Declaração de procedimentos deve começar com `procedure"
        case .d7(let row):
            return "LINHA\(row): Comando condicional deve começar com `if`"
        case .d8(let row):
            return "LINHA\(row): Comando condicional deve conter `then`"
        case .d9(let row):
            return "LINHA\(row): Comando repetitivo deve começar com `while`"
        case .d10(let row):
            return "LINHA\(row): Comando repetitivo deve conter `do`"
        case .d11(let row):
            return "LINHA\(row): Declaração de variáveis com valoresdeve ter um `:` antes do `=`."

            /// Identifier errors.
        case .i1(let row):
            return "LINHA\(row): Um Identificador é esperado."


            /// Terminator errors.
        case .t1(let row):
            return "LINHA\(row): Terminador necessário."
        case .t2(let row):
            return "LINHA\(row): Terminador inválido."
        case .t3(let row):
            return "LINHA\(row): Terminador de bloco inválido."
        case .t4(let row):
            return "LINHA\(row): Terminador de instruções inválido, deve ser `;`."


        /// Final errors
        case .f1(let row):
            return "LINHA\(row): Programa terminou inesperadamente."
        case .f2(let row):
            return "LINHA\(row): Programa deve terminar com `.`."
        }
    }
}
