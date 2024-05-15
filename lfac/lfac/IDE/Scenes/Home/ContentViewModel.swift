//
//  ContentViewModel.swift
//  lfac
//
//  Created by Luiz Araujo on 14/05/24.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var code: String = ""
    @Published var styled: AttributedString = ""

    ///  View Elements States
    @Published var isRunEnabled = false

    private var cancellables = Set<AnyCancellable>()
    private let styling: CodeStyler?

    internal init(
        code: String = "",
        isRunEnabled: Bool = false,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        styling: CodeStyler = BasicStyling()
    ) {
        self.code = code
        self.isRunEnabled = isRunEnabled
        self.cancellables = cancellables
        self.styling = styling

        enableRunButton()
    }

    func enableRunButton() {
        self.$code.sink { [unowned self] value in

            /// Validate input to enable Run Button
            self.isRunEnabled = self.validateInput(self.code)
            if let styling {
                self.styled = styling.style(code.description)
            }
        }
        .store(in: &cancellables)
    }

    private func validateInput(_ input: String) -> Bool {
        // TODO: Fazer validações

        guard input.description.count >= 3 else { return false }
        guard !input.description.contains(PTokenType.invalidToken.regex) else { return false }

        return true
    }

    deinit {
        self.cancellables.removeAll()
    }
}


protocol CodeStyler { 
    func style(_ text: String) -> AttributedString
}

struct BasicStyling: CodeStyler {

    func style(_ text: String) -> AttributedString {
        var styled = AttributedString()

//        let test: [AttributedString] = text.split(separator: /[\s|\n]/).map(String.init).map(AttributedString.init)
        let rows: [String] = text.split(separator: "\n").map(String.init)
        var table = [[String]]()

        rows.forEach { row in
            let words = row.split(separator: " ").map(String.init)
            table.append(words)
        }

        /// terminators
        /// commentary
        /// operatorMath
        /// operatorCompare
        /// operatorAttribution
        /// keyword
        /// integer
        /// real
        /// symbol
        /// identifier
        /// invalidToken
        
//        var regexString = PTokenType.keyword.regex
//        var container = AttributeContainer()
//
//        guard let range = styled.range(of: regexString, options: .regularExpression) else { return styled }
//        container[AttributeScopes.SwiftUIAttributes.ForegroundColorAttribute.self] = .blue
//        styled[range].setAttributes(container)
//
//        regexString = PTokenType.identifier.regex
//        container = AttributeContainer()
//
//        guard let range = styled.range(of: regexString, options: .regularExpression) else { return styled }
//        container[AttributeScopes.SwiftUIAttributes.FontAttribute.self] = container.font?.italic()
//        styled[range].mergeAttributes(container)

        for row in table {
            for word in row {
                var aux = AttributedString(stringLiteral: word)
                var regexString = PTokenType.keyword.regex


                if let range = aux.range(of: regexString, options: .regularExpression) {
                    aux.foregroundColor = .blue

                    styled += aux + " "
                    continue
                }

                regexString = PTokenType.identifier.regex

                if let range = aux.range(of: regexString, options: .regularExpression) {
                    aux.foregroundColor = .green

                    styled += aux + " "
                    continue
                }

                regexString = PTokenType.integer.regex

                if let range = aux.range(of: regexString, options: .regularExpression) {
                    aux.foregroundColor = .yellow
                    //                container[AttributeScopes.SwiftUIAttributes.ForegroundColorAttribute.self] = .yellow
                    //                aux.mergeAttributes(container)

                    styled += aux + " "
                    continue
                }

                regexString = PTokenType.invalidToken.regex
                if let range = aux.range(of: regexString, options: .regularExpression) {
                    aux.foregroundColor = .red

                    styled += aux + " "
                    continue
                }

                styled += aux + " "
            }
            styled += "\n"
        }

        return styled
    }
}
