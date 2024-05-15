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
//        var result = PTokenType.invalidToken

        do {
            var regex = try Regex(PTokenType.keyword.regex)
            guard word.matches(of: regex).isEmpty else {
                return .keyword
            }



            regex = try Regex(PTokenType.identifier.regex)
            guard word.matches(of: regex).isEmpty else {
                return PTokenType.identifier
            }

            regex = try Regex(PTokenType.real.regex)
            guard word.matches(of: regex).isEmpty else {
                return PTokenType.real
            }

            regex = try Regex(PTokenType.integer.regex)
            guard word.matches(of: regex).isEmpty else {
                return PTokenType.integer
            }

            regex = try Regex(PTokenType.operatorAttribution.regex)
            guard word.matches(of: regex).isEmpty else {
                return .operatorAttribution
            }

            regex = try Regex(PTokenType.operatorCompare.regex)
            guard word.matches(of: regex).isEmpty else {
                return .operatorCompare
            }

            regex = try Regex(PTokenType.operatorMath.regex)
            guard word.matches(of: regex).isEmpty else {
                return .operatorMath
            }

            regex = try Regex(PTokenType.symbol.regex)
            guard word.matches(of: regex).isEmpty else {
                return .symbol
            }

            regex = try Regex(PTokenType.space.regex)
            guard word.matches(of: regex).isEmpty else {
                return PTokenType.space
            }

            regex = try Regex(PTokenType.commentary.regex)
            guard word.matches(of: regex).isEmpty else {
                return .commentary
            }

            regex = try Regex(PTokenType.terminators.regex)
            guard word.matches(of: regex).isEmpty else {
                return .terminators
            }

//            regex = try Regex(PTokenType.endLine.regex)
//            guard word.matches(of: regex).isEmpty else {
//                return PTokenType.endLine
//            }





















            

        } catch {
            print("PROBLEMA NO REGEX")
        }



        return .invalidToken




        //        for type in PTokenType.allCases {
        //            if type == .invalidToken {
        //
        //                let alphabet = Dictionary().alphabet
        //
//                let intersection = Set(alphabet).intersection(Set(Array(arrayLiteral: word)))
//                if intersection.count == word.count {
//                    result = .invalidToken
//                }
//            } else {
//
//                do {
//                    var regex = try Regex(type.regex)
//                    guard !word.matches(of: regex).isEmpty else { continue }
//
//                    result = type
//
//                    if result == .keyword {
//                        regex = try Regex(PTokenType.keyword.regex)
//                        if word.matches(of: regex).isEmpty {
//                            result = .identifier
//                        }
//
//                    }
//
//                } catch {
//                    print("PROBLEMA NO REGEX: \(type.rawValue)")
//                }
//            }
//        }
    }
}
