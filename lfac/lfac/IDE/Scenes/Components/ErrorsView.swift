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
                Text("🔴  " + element.localizedDescription)
                    .font(.title3)
                    .padding(2)
            }

            Spacer()
        }
        .padding(.top, 36)
    }
}


#Preview {
    ErrorsView(
        errors: [
            .c2(1, 0),
            .c3(2, 4),
            .e6(3, 7),
            .e8(4, 3),
            .f2(5, 9)
        ]
    )
}
