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
