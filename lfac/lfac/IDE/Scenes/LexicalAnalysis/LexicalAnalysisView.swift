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
        VStack(alignment: .leading) {
            NavigationLink(value: analyzer.tokens) {
                Label("Analyze Syntax", systemImage: "play.circle.fill")
            }
            .padding(.top)

            if analyzer.errors.count > 0 {
                ErrorsView(errors: analyzer.errors)

            } else {
                List {
                    ForEach(analyzer.tokens) { token in
                        TokenListItem(token: token, id: token.id)
                    }
                }
            }
        }
        .navigationDestination(for: String.self) { code in
            LexicalAnalysisView(
                analyzer: LexicalAnalyzer(
                    code: code//,
                    //                        states: TransitionState.allCases,
                    //                        initialState: TransitionState.q0,
                    //                        finalStates: TransitionState.finals
                )
            )
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
