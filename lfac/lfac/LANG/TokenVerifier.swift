//
//  TokenVerifiable.swift
//  lfac
//
//  Created by Luiz Araujo on 13/05/24.
//

import Foundation

protocol TokenVerifiable {

    func getLexemeType(_ string: String) -> PTokenType
}

struct TokenVerifier: TokenVerifiable {

    func getLexemeType(_ word: String) -> PTokenType {

        for type in PTokenType.allCases {
            if type == .invalidToken {

                let alphabet = Dictionary().alphabet

                let intersection = Set(alphabet).intersection(Set(Array(arrayLiteral: word)))
                if intersection.count == word.count {
                    return .invalidToken
                }
            } else {

                do {
                    let regex = try Regex(type.regex)
                    guard !word.matches(of: regex).isEmpty else { continue }

                    return type

                } catch {
                    print("PROBLEMA NO REGEX: \(type.rawValue)")
                }
            }
        }
        return .invalidToken
    }
}
