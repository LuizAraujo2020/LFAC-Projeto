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
//        NavigationStack {
//            VStack(alignment: .leading) {
//                HStack(spacing: 18) {
//                        Text("Enter the code: ".uppercased())
//                            .foregroundStyle(.primary)
//
//                        Spacer()
//
//                        CodePickerView(code: $vm.codeFile)
//
//                        Button {
//                            vm.exportCode()
//                        } label: {
//                            Label(
//                                "Export\(vm.savedCode != nil ? "ed" : "  ")",
//                                systemImage: "square.and.arrow.down.on.square\(vm.savedCode != nil ? ".fill" : "")"
//                            )
//                        }
//
//                        NavigationLink(value: vm.code) {
//                            Label("Analyze", systemImage: "play.circle.fill")
//                        }
//                        .disabled(!vm.isRunEnabled)
//                    }
//
//                HStack(alignment: .top) {
//                    TextEditor(text: $vm.code)
//                        .scrollContentBackground(.hidden)
//                        .padding()
//                        .foregroundStyle(.primary.opacity(0.75))
//                        .background(
//                            .linearGradient(
//                                colors: [
//                                    .gray.opacity(0.1),
//                                    .gray.opacity(0.05)
//                                ],
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
//                        )
//                        .cornerRadius(10)
//                        .autocorrectionDisabled()
//                        .textInputAutocapitalization(.never)
//                        .frame(width: width / 2.5)
//
//                    Text(vm.styled)
//                        .frame(width: width / 2.5)
//                }
//            }
//            .padding()
//            .navigationDestination(for: String.self) { code in
//                LexicalAnalysisView(
//                    analyzer: LexicalAnalyzer(
//                        code: code,
//                        states: TransitionState.allCases,
//                        initialState: TransitionState.q0,
//                        finalStates: TransitionState.finals
//                    )
//                )
//            }
//        }
        LexicalAnalysisView(
            analyzer: LexicalAnalyzer(
                code: """
program micro03;

var
    numero : integer;

begin
    readln(numero);
    if(numero >= 100) then
        begin
        if(numero <= 200) then begin
        writeln(1);
    end;
    else begin
        writeln(0);
        end;
        end;
        else begin
        writeln(0);
    end;

end.
""",
                states: [],
                initialState: .q0,
                finalStates: []
            )
        )
    }
}

#Preview {
//    ContentView()
    LexicalAnalysisView(
        analyzer: LexicalAnalyzer(
            code: """
program prog1;
    var num = 123
    var qtd = 10
""",
            states: [],
            initialState: .q0,
            finalStates: []
        )
    )
}
