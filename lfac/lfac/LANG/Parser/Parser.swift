//
//  Parser.swift
//  lfac
//
//  Created by Gabriel Eduardo on 12/06/24.
//

import Foundation

class Parser {
//    private var listOfTokens:
    private var token: String
    private var indexToken: Int
    
    init(token: String, indexToken: Int) {
        self.token = token
        self.indexToken = indexToken
    }

    /**
             * Verifica se eh um tipo valido
             */
//            private bool IsValidType(string token)
//            {
//                if (token.Equals("TOKEN.STRING") || token.Equals("TOKEN.INTEGER") || token.Equals("TOKEN.FLOAT"))
//                {
//                    return true;
//                }
//
//                return false;
//            }
    
    // Verifica se um tipo é válido
    private func isValidType(token: String) -> Bool {
        // Se o token for integer, real ou boolean -> retorna true
        if (token == "INTEIRO" || token == "REAL" || token == " BOOLEANO") {
            return true
        }
        return false
    }
}
