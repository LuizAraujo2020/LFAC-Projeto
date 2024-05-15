//
//  CodeStyler.swift
//  lfac
//
//  Created by Luiz Araujo on 15/05/24.
//

import SwiftUI

protocol CodeStyler {
    func style(_ text: String) -> AttributedString
}

struct BasicStyling: CodeStyler {

    func style(_ text: String) -> AttributedString {
        var styled = AttributedString()

        let rows: [String] = text.split(separator: "\n").map(String.init)
        var table = [[String]]()

        rows.forEach { row in
            let words = row.split(separator: " ").map(String.init)
            table.append(words)
        }

        for row in table {
            for word in row {
                var aux = AttributedString(stringLiteral: word)

                for type in PTokenType.allCases {
                    if aux.range(of: type.regex, options: .regularExpression) != nil {
                        aux.foregroundColor = getColorBy(type: type)

                        styled += aux + " "
                        break
                    }
                }

            }
            styled += "\n"
        }

        return styled
    }

    private func getColorBy(type: PTokenType) -> Color {
        switch type {
        case .space: .clear
        case .terminators: .blue
        case .commentary: .gray
        case .operatorMath, .operatorCompare, .operatorAttribution: .yellow
        case .keyword: .blue
        case .integer, .real: .green
        case .symbol: .cyan
        case .identifier: .indigo
        case .invalidToken: .red
        }
    }
}
