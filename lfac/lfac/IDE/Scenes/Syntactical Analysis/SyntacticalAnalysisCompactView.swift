//
//  SyntacticalAnalysisCompactView.swift
//  lfac
//
//  Created by Luiz Araujo on 22/06/24.
//

import SwiftUI

struct SyntacticalAnalysisCompactView: View {
    let analyzer: SyntacticalAnalyzer

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if analyzer.errors.count > 0 {
                    ErrorsView(errors: analyzer.errors)
                } else {
                    Text("✅ Análise Sintática bem sucedida!")
                }
            }

            Spacer()
        }
    }
}

#Preview {
    SyntacticalAnalysisCompactView(
        analyzer: SyntacticalAnalyzer(
            tokens: [
                .init(id: 0, type: .operators, value: "+", line: 1, column: 1),
                .init(id: 1, type: .integers, value: "10", line: 1, column: 2),
                .init(id: 2, type: .keyword, value: "and", line: 1, column: 14),
                .init(id: 3, type: .identifiers, value: "valid", line: 1, column: 1),
                .init(id: 4, type: .keyword, value: "or", line: 1, column: 1),

                .init(id: 0, type: .operators, value: "-", line: 1, column: 1),
                .init(id: 1, type: .integers, value: "10", line: 1, column: 2),
                .init(id: 2, type: .keyword, value: "*", line: 1, column: 14),
                .init(id: 3, type: .identifiers, value: "qtd", line: 1, column: 1),

                .init(id: 4, type: .terminators, value: ";", line: 1, column: 1)
            ]
        )
    )
}
