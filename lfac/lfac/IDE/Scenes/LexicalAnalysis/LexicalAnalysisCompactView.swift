//
//  LexicalAnalysisCompactView.swift
//  lfac
//
//  Created by Luiz Araujo on 22/06/24.
//

import SwiftUI

struct LexicalAnalysisCompactView: View {
    let analyzer: LexicalAnalyzer

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(
                analyzer.tokens.filter({ $0.type == .keyword || $0.type == .identifiers })
            ) { token in
                HStack {
                    Rectangle()
                        .frame(width: 5, alignment: .leading)
                        .foregroundStyle(token.type.color)

                    VStack(alignment: .leading) {
                        HStack {
                            Text("TIPO:\t\t").bold()
                            Text(token.type.name)
                        }

                        HStack {
                            Text("VALOR:\t").bold()
                            Text(token.value)
                        }

                        HStack {
                            Text("LINHA:\t").bold()
                            Text("\(token.line)")
                        }

                        HStack {
                            Text("COLUNA:\t").bold()
                            Text("\(token.column)")
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    LexicalAnalysisCompactView(
        analyzer: LexicalAnalyzer(
            code: """
                    program testeA
                    var qtd = 12
                    var numero = 3245
                    """
        )
    )
}
