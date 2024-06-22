//
//  LexicalAnalysisView.swift
//  lfac
//
//  Created by Luiz Araujo on 14/05/24.
//

import SwiftUI

struct LexicalAnalysisView: View {
    let analyzer: LexicalAnalyzer

    var body: some View {
        VStack {
            List {
                ForEach(analyzer.tokens) { token in
                    TokenListItem(token: token, id: token.id)
                }
            }
        }
    }
}

#Preview {
    LexicalAnalysisView(
        analyzer: LexicalAnalyzer(
            code: """
                program testeA
                var qtd = 12
                var numero = 3245
                """//,
//            states: TransitionState.allCases,
//            initialState: TransitionState.q0,
//            finalStates: TransitionState.finals
        )
    )

}
