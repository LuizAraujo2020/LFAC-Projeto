//
//  TokenListItem.swift
//  lfac
//
//  Created by Luiz Araujo on 14/05/24.
//

import SwiftUI

struct TokenListItem: View {
    let token: PToken
    let id: Int
//    let styling: CodeStyler
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundStyle(Color(uiColor: .opaqueSeparator))
                .clipShape(RoundedRectangle(cornerRadius: 12), style: FillStyle())
            
            
            
            HStack {
                ZStack {
                    Rectangle()
//                        .foregroundStyle(styling.getColorBy(type: token.type))
                        .clipShape(RoundedRectangle(cornerRadius: 12), style: FillStyle())
                    
                    Text("\(id)")
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                }
                .frame(maxWidth: 200)
                
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
                .padding([.top, .horizontal])
            }
        }
        .padding(.vertical, 8)
        .shadow(radius: 10)
    }
}

#Preview {
    TokenListItem(
        token: PToken(
            id: 0,
            type: .keyword,
            value: "var",
            line: 1,
            column: 1
        ), id: 0//,
//        styling: BasicStyling()
    )
}
