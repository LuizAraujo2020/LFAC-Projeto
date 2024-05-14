//
//  Errors.swift
//  lfac
//
//  Created by Luiz Araujo on 12/05/24.
//

import Foundation

enum Errors: Int, LocalizedError {
    /// ERRO de TRANSICAO
    case ET = -1
    /// SIMBOLO INVALIDO
    case SI = -5
    /// ESTADO de PARADA
    case EP = -9

    /// REGEX
    case regexInvalido = -11

    /// Verificações de Entradas
    case dontContains = -20
    case wasntFound = -21

    var errorDescription: String? {
        switch self {
        case .ET: return "Erro de transição."
        case .SI: return "Símbolo inválido!"
        case .EP: return "Estado de parada."
        case .regexInvalido: return "Regex inválido."
        case .dontContains: return "A entrada não pertence ao alfabeto desta linguagem."
        case .wasntFound: return "A entrada não foi encontrada no alfabeto desta linguagem."
        }
    }
}
