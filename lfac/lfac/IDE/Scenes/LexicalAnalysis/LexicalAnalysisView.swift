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
//                    Text(token.name)
                    TokenListItem(token: token, id: token.id)
                }
//                ForEach(analyzer.tokens) { item in
////                ForEach(analyzer.tokens.keys.sorted(), id: \.self) { item in
//                    TokenListItem(
//                        token: analyzer.tokens[item],
//                        id: item//,
////                        styling: BasicStyling()
//                    )
//                }
            }
        }
    }
}

#Preview {
    LexicalAnalysisView(
//        scannerLA: ScannerLA(
//            code: """
//                program testeA
//                var qtd = 12
//                var numero = 3245
//                """,
//            tokenVerifier: TokenVerifier()
//        )
        analyzer: LexicalAnalyzer(
            code: """
                program testeA
                var qtd = 12
                var numero = 3245
                """,
            states: TransitionState.allCases,
            initialState: TransitionState.q0,
            finalStates: TransitionState.finals
        )
    )

}
