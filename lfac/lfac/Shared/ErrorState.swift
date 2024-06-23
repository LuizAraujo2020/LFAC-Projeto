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
        var errorMessage = "ERRO "

        switch self.type {
            /// Generic errors.
        case .e1(let char): errorMessage += "e1f\nCaracter inválido: \(char)"
        case .e2: errorMessage += "e2\nIdentificadores não podem conter caracteres especiais."
        case .e3: errorMessage += "e3\nNúmeros não podem conter letras."
        case .e4: errorMessage += "e4\nNúmeros não podem conter caracteres especiais, separe-os com espaço."
        case .e5: errorMessage += "e5\nNúmeros não podem conter mais que um ponto `.`."
        case .e6: errorMessage += "e6\nSímbolo inválido."
        case .e7: errorMessage += "e7\nOperador inválido."
        case .e8: errorMessage += "e8\nTipo inválido."
        case .e9: errorMessage += "e9\nFator inválido. Espera-se um número, variável, expressão ou outro fator."


            /// Program errors.
        case .p1: errorMessage += "p1\nO ERRO   return\nprograma deve iniciar com `program`"
        case .p2(let token):
            return "A palavra reservada `\(token)` ainda não foi implementada."


            /// Comandos
        case .c1: errorMessage += "c1\nA parte de Comandos deve começar com `begin`"
        case .c2: errorMessage += "c2\nA parte de Comandos deve ser fechada com `end`."
        case .c3: errorMessage += "c3\nA parte de Comandos deve terminar com `.`"
        case .c4: errorMessage += "c4\nUm Comando deve ter um `end` após seu conteúdo."
        case .c5: errorMessage += "c5\nO Comando `readln` e `writeln` devem ser seguido por `(...)`."
        case .c6: errorMessage += "c6\nO Comando `readln` e `writeln` devem receber um fator dentro dos parenteses."
        case .c7: errorMessage += "c7\nO Comando `readln` e `writeln` deve, ser finalizado por `;`."
        case .c8: errorMessage += "c4\nUm Comando deve ser fechado com `;`."


            /// Declaration errors.
        case .d1: errorMessage += "d1\nDeclaração de variáveis deve começar com um Identificador."
        case .d2: errorMessage += "d2\nDeclaração de múltiplas variáveis devem ter uma sequencia de Identificadores separados por vírgula."
        case .d3: errorMessage += "d3\nDeclaração de variáveis deve ter um `:` entre os Identificadores e o Tipo de variável."
        case .d4: errorMessage += "d4\nDeclaração de parâmetros formais deve iniciar com `(`"
        case .d5: errorMessage += "d5\nO fim da declaração de parâmetros formais deve finalizar com `)`"
        case .d6: errorMessage += "d6\nDeclaração de procedimentos deve começar com `procedure"
        case .d7: errorMessage += "d7\nComando condicional deve começar com `if`"
        case .d8: errorMessage += "d8\nComando condicional deve conter `then`"
        case .d9: errorMessage += "d9\nComando repetitivo deve começar com `while`"
        case .d10: errorMessage += "d10\nComando repetitivo deve conter `do`"
        case .d11: errorMessage += "d11\nDeclaração de variáveis com valoresdeve ter um `:` antes do `=`."

            /// Identifier errors.
        case .i1: errorMessage += "i1\nUm Identificador é esperado."


            /// Terminator errors.
        case .t1: errorMessage += "t1\nTerminador necessário."
        case .t2: errorMessage += "t2\nTerminador inválido."
        case .t3: errorMessage += "t3\nTerminador de bloco inválido."
        case .t4: errorMessage += "t4\nTerminador de instruções inválido, deve ser `;`."


            /// Final errors
        case .f1: errorMessage += "f1\nPrograma terminou inesperadamente."
        case .f2: errorMessage += "f2\nPrograma deve terminar com `.`"
        }

        return errorMessage
    }
}

extension ErrorState {

    enum ErrorType: Hashable {
        case e1(String), e2, e3, e4, e5, e6, e7, e8, e9
        case p1, p2(String)
        case c1, c2, c3, c4, c5, c6, c7, c8
        case d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11
        case f1, f2
        case i1
        case t1, t2, t3, t4
    }

    static func == (lhs: ErrorState, rhs: ErrorState) -> Bool {
        lhs.id == rhs.id ||
        lhs.type == rhs.type &&
        lhs.row == rhs.row &&
        lhs.col == rhs.col
    }
}
