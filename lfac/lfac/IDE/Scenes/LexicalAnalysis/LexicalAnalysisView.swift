//
//  LexicalAnalysisView.swift
//  lfac
//
//  Created by Luiz Araujo on 14/05/24.
//

import SwiftUI

struct LexicalAnalysisView: View {
    let scannerLA: ScannerLA

    var body: some View {
        VStack {
            List {
                ForEach(scannerLA.tokens.keys.sorted(), id: \.self) { item in
                    TokenListItem(token: scannerLA.tokens[item] ?? .mock)
                }
            }
        }
    }
}

#Preview {
    LexicalAnalysisView(
        scannerLA: ScannerLA(
            code: """
                program testeA
                var qtd = 12
                var numero = 3245
                """,
            tokenVerifier: TokenVerifier()
        )
    )
}
