//
//  ContentView.swift
//  lfac
//
//  Created by Luiz Araujo on 08/05/24.
//

import SwiftUI

struct ContentView: View {

    let code = """
            var numero1 = +3
            numero1 = 3 + 3
            """

    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text(code)

                NavigationLink("Analyze") {
                    ResutlView(scannerLA: ScannerLA(code: code, tokenVerifier: TokenVerifier()))
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

struct ResutlView: View {
    let scannerLA: ScannerLA

    var body: some View {
        VStack {
            List {
                ForEach(scannerLA.tokens.keys.sorted(), id: \.self) { item in

                    HStack {
                        Text("Key:\t\t\(item)\t\t\t")
                        Text("Name:\t\(scannerLA.tokens[item]?.name ?? "")")
                        Text("Value:\t\(scannerLA.tokens[item]?.value ?? "")")
                        Spacer()
                    }
                }
            }

        }
    }
}
