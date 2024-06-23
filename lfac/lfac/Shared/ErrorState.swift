//
//  ErrorStates.swift
//  lfac
//
//  Created by Luiz Araujo on 22/06/24.
//

import Foundation

struct ErrorState: LocalizedError, Identifiable, Hashable {
    
    let type: ErrorType
    let row: Int
    let col: Int

    var id: String { UUID().uuidString }
    
    init(type: ErrorState.ErrorType, row: Int, col: Int) {
        self.type = type
        self.row = row
        self.col = col
    }

    var errorDescription: String? {
        var errorMessage = "ERRO \(type.rawValue):\n"

        switch self.type {
        case .a1: errorMessage += "Uma atribuição deve começar por uma variável."
        case .a2: errorMessage += "Uma atribuição deve receber uma variável, número ou expressão."
        case .a3: errorMessage += "Uma atribuição deve terminar com `;`."


            /// Generic errors.
        case .e1(let char): errorMessage += "Caracter inválido: \(char)"
        case .e2: errorMessage += "Identificadores não podem conter caracteres especiais."
        case .e3: errorMessage += "Números não podem conter letras."
        case .e4: errorMessage += "Números não podem conter caracteres especiais, separe-os com espaço."
        case .e5: errorMessage += "Números não podem conter mais que um ponto `.`."
        case .e6: errorMessage += "Símbolo inválido."
        case .e7: errorMessage += "Operador inválido."
        case .e8: errorMessage += "Tipo inválido."
        case .e9: errorMessage += "Fator inválido. Espera-se um número, variável, expressão ou outro fator."


            /// Program errors.
        case .p1: errorMessage += "O ERRO   return\nprograma deve iniciar com `program`"
        case .p2(let token):
            return "A palavra reservada `\(token)` ainda não foi implementada."


            /// Comandos
        case .c1: errorMessage += "A parte de Comandos deve começar com `begin`"
        case .c2: errorMessage += "A parte de Comandos deve ser fechada com `end`."
        case .c3: errorMessage += "A parte de Comandos deve terminar com `.`"
        case .c4: errorMessage += "Um Comando Composto deve ter um `end` após seu conteúdo."
        case .c5: errorMessage += "O Comando `readln` e `writeln` devem ser seguido por `(...)`."
        case .c6: errorMessage += "O Comando `readln` e `writeln` devem receber um fator dentro dos parenteses."
        case .c7: errorMessage += "O Comando `readln` e `writeln` deve, ser finalizado por `;`."
        case .c8: errorMessage += "Um Comando deve ser fechado com `end`."
        case .c9: errorMessage += "Um Comando deve ser finalizado com `;`."


            /// Declaration errors.
        case .d1: errorMessage += "Declaração de variáveis deve começar com um Identificador."
        case .d2: errorMessage += "Declaração de múltiplas variáveis devem ter uma sequencia de Identificadores separados por vírgula."
        case .d3: errorMessage += "Declaração de variáveis deve ter um `:` entre os Identificadores e o Tipo de variável."
        case .d4: errorMessage += "Declaração de parâmetros formais deve iniciar com `(`"
        case .d5: errorMessage += "O fim da declaração de parâmetros formais deve finalizar com `)`"
        case .d6: errorMessage += "Declaração de procedimentos deve começar com `procedure"
        case .d7: errorMessage += "Comando condicional deve começar com `if`"
        case .d8: errorMessage += "Comando condicional deve conter `then`"
        case .d9: errorMessage += "Comando repetitivo deve começar com `while`"
        case .d10: errorMessage += "Comando repetitivo deve conter `do`"
        case .d11: errorMessage += "Declaração de variáveis com valoresdeve ter um `:` antes do `=`."

            /// Identifier errors.
        case .i1: errorMessage += "Um Identificador é esperado."


            /// Terminator errors.
        case .t1: errorMessage += "Terminador necessário."
        case .t2: errorMessage += "Terminador inválido."
        case .t3: errorMessage += "Terminador de bloco inválido."
        case .t4: errorMessage += "Terminador de instruções inválido, deve ser `;`."


            /// Final errors
        case .f1: errorMessage += "Programa terminou inesperadamente."
        case .f2: errorMessage += "Programa deve terminar com `.`"
        }

        return errorMessage
    }
}

extension ErrorState {

    enum ErrorType: Hashable {
        case a1, a2, a3
        case e1(String), e2, e3, e4, e5, e6, e7, e8, e9
        case p1, p2(String)
        case c1, c2, c3, c4, c5, c6, c7, c8, c9
        case d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11
        case f1, f2
        case i1
        case t1, t2, t3, t4



        var rawValue: String {
            switch self {
            case .a1: return "a1"
            case .a2: return "a2"
            case .a3: return "a3"
            case .e1(let string): return "e1"
            case .e2: return "e2"
            case .e3: return "e3"
            case .e4: return "e4"
            case .e5: return "e5"
            case .e6: return "e6"
            case .e7: return "e7"
            case .e8: return "e8"
            case .e9: return "e9"
            case .p1: return "p1"
            case .p2(let string): return "p2"
            case .c1: return "c1"
            case .c2: return "c2"
            case .c3: return "c3"
            case .c4: return "c4"
            case .c5: return "c5"
            case .c6: return "c6"
            case .c7: return "c7"
            case .c8: return "c8"
            case .c9: return "c9"
            case .d1: return "d1"
            case .d2: return "d2"
            case .d3: return "d3"
            case .d4: return "d4"
            case .d5: return "d5"
            case .d6: return "d6"
            case .d7: return "d7"
            case .d8: return "d8"
            case .d9: return "d9"
            case .d10: return "d10"
            case .d11: return "d11"
            case .f1: return "f1"
            case .f2: return "f2"
            case .i1: return "i1"
            case .t1: return "t1"
            case .t2: return "t2"
            case .t3: return "t3"
            case .t4: return "t4"
            }
        }
    }

    static func == (lhs: ErrorState, rhs: ErrorState) -> Bool {
        lhs.id == rhs.id ||
        lhs.type == rhs.type &&
        lhs.row == rhs.row &&
        lhs.col == rhs.col
    }
}
