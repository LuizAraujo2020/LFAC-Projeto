//
//  AnalysisTypes.swift
//  lfac
//
//  Created by Luiz Araujo on 22/06/24.
//

import Foundation

enum AnalysisTypes: String, Identifiable ,Hashable, CaseIterable {
case lexical, syntactical

    var id: String { self.rawValue }
    
    var name: String {
        switch self {
        case .lexical: return "Léxico"
        case .syntactical: return "Sintático"
        }
    }
}
