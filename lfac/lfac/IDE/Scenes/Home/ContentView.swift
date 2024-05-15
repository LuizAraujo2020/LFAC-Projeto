//
//  ContentView.swift
//  lfac
//
//  Created by Luiz Araujo on 08/05/24.
//

import SwiftUI

struct ContentView: View {

    @StateObject var vm = ContentViewModel()

    private let width = UIScreen.main.bounds.width

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                    HStack {
                        Text("Enter the code: ".uppercased())
                            .foregroundStyle(.primary)

                        Spacer()

                        NavigationLink {
                            LexicalAnalysisView(scannerLA: ScannerLA(code: vm.code, tokenVerifier: TokenVerifier()))
                        } label: {
                            Label("Analyze", systemImage: "play.circle.fill")
                        }
                        .disabled(!vm.isRunEnabled)
                    }

                HStack(alignment: .top) {
                    TextEditor(text: $vm.code)
                        .scrollContentBackground(.hidden)
                        .padding()
                        .foregroundStyle(.primary.opacity(0.75))
                        .background(
                            .linearGradient(
                                colors: [
                                    .gray.opacity(0.1),
                                    .gray.opacity(0.05)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(10)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .frame(width: width / 2.5)

                    Text(vm.styled)
                        .frame(width: width / 2.5)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
