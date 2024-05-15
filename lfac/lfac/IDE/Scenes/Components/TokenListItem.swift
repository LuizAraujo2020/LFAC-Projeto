//
//  TokenListItem.swift
//  lfac
//
//  Created by Luiz Araujo on 14/05/24.
//

import SwiftUI

struct TokenListItem: View {
    let token: PToken

    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                Text("**TIPO :**\t\t\(token.type.id)")
                Text("**NOME :**\t\(token.name)")
                Text("**VALOR:**\t\(token.value)")

                HStack(spacing: 40) {
                    Spacer()
                    Label(String(token.line), systemImage: "arrow.up.and.down.text.horizontal")

                    Label(String(token.column), systemImage: "arrow.left.and.right.text.vertical")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
        }
    }
}

#Preview {
    TokenListItem(
        token: PToken(
            type: .keyword,
            value: "var",
            line: 1,
            column: 1
        )
    )
}
