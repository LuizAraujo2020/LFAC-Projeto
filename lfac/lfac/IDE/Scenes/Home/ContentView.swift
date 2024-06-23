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
                HStack(spacing: 18) {
                        Text("Enter the code: ".uppercased())
                            .foregroundStyle(.primary)

                        Spacer()

                        CodePickerView(code: $vm.codeFile)

                        Button {
                            vm.runAnalysis()
                        } label: {
                            Label(
                                "Analyze",
                                systemImage: "play.circle.fill"
                            )
                        }
                        .disabled(!vm.isRunEnabled)
                    }

                // MARK: - ENTER THE CODE
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
                    
                    // MARK: - RESULT
                    // TODO: ⚠️ Fazer extrair depois
                    VStack(alignment: .leading) {
                        if vm.lexicalAnalyzer.errors.count > 0 || vm.syntacticalAnalyzer.errors.count > 0 {
                            ErrorsView(errors: vm.lexicalAnalyzer.errors.count > 0 ? vm.lexicalAnalyzer.errors:  vm.syntacticalAnalyzer.errors)

                        } else {
                            List {
                                Section(header: AnalysisTypePicker(type: $vm.selectedAnalysis)) {

                                    switch vm.selectedAnalysis{
                                    case .lexical:
                                        LexicalAnalysisCompactView(
                                            analyzer: LexicalAnalyzer(
                                                code: vm.code
                                            )
                                        )
                                    case .syntactical:
                                        SyntacticalAnalysisCompactView(
                                            analyzer: SyntacticalAnalyzer(
                                                tokens: vm.lexicalAnalyzer.tokens
                                            )
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
