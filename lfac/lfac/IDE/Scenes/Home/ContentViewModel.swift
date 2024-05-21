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
    @Published var savedCode: String?
    @Published var styled: AttributedString = ""

    ///  View Elements States
    @Published var isRunEnabled = false

    private var cancellables = Set<AnyCancellable>()

    private var fileScanner: FileScanner
//    private let styling: CodeStyler?

    internal init(
        code: String = "",
        isRunEnabled: Bool = false,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        fileScanner: FileScanner = FileScanner()//,
//        styling: CodeStyler = BasicStyling()
    ) {
        self.code = code
        self.isRunEnabled = isRunEnabled
        self.cancellables = cancellables
        self.fileScanner = fileScanner
//        self.styling = styling

        enableRunButton()
    }

    func enableRunButton() {
        
        self.$code.sink { [unowned self] value in

            /// Validate input to enable Run Button
            self.isRunEnabled = self.validateInput(self.code)
//            if let styling {
//                self.styled = styling.style(code.description)
//            }
            self.savedCode = self.savedCode != self.code ? nil : self.code
        }
        .store(in: &cancellables)
    }

    func exportCode() {
        fileScanner.writeTo(fileName: .code, value: code)
        savedCode = code
    }

    func importCode() {
        let data = fileScanner.readFrom()
        code = data
        styled = AttributedString(data)
    }

    private func validateInput(_ input: String) -> Bool {
        // TODO: Fazer validações

        guard input.description.count >= 3 else { return false }
//        guard !input.description.contains(PTokenType.invalidToken.regex) else { return false }
//        if let regex = try? Regex(PTokenType.invalidToken.regex), !input.description.matches(of: regex).isEmpty {
//            return false
//        }
        return true
    }

    deinit {
        self.cancellables.removeAll()
    }
}
