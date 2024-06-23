//
//  ErrorsView.swift
//  lfac
//
//  Created by Luiz Araujo on 22/06/24.
//

import SwiftUI

struct ErrorsView: View {
    var errors: [ErrorState]

    var plural: String { errors.count > 1 ? "S" : "" }

    var body: some View {
        VStack {
            Text("⚠️ ERRO ENCONTRADO")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom)

            List(errors) { element in
                VStack(alignment: .leading) {
                    Text("🔴  " + element.localizedDescription)
                        .font(.title3)
                        .padding(2)

                    if let row = element.row{
                        HStack {
                            Text("LINHA:\t").bold()
                            Text("\(row)")
                        }
                    }

                    if let col = element.col {
                        HStack {
                            Text("COLUNA:\t").bold()
                            Text("\(col)")
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.top, 36)
    }
}


#Preview {
    ErrorsView(
        errors: [
            ErrorState(type: .c2, row: 1, col: 0),
            ErrorState(type: .c3, row: 2, col: 4),
            ErrorState(type: .e6, row: 3, col: 7),
            ErrorState(type: .e8, row: 4, col: 3),
            ErrorState(type: .f2, row: 5, col: 9)
        ]
    )
}
