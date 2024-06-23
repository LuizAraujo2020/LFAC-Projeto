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
    @Published var codeFile: FileScanner.FilesName = .code1
    @Published var lexicalAnalyzer: LexicalAnalyzer
    @Published var syntacticalAnalyzer: SyntacticalAnalyzer

    @Published var code: String = ""
    @Published var savedCode: String?
    @Published var styled: AttributedString = ""

    ///  View Elements States
    @Published var isRunEnabled = false
    @Published var selectedAnalysis = AnalysisTypes.lexical

    private var cancellables = Set<AnyCancellable>()

    private var fileScanner: FileScanner

    internal init(
        code: String = "",
        isRunEnabled: Bool = false,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        fileScanner: FileScanner = FileScanner(),
        lexicalAnalyzer: LexicalAnalyzer? = nil,
        syntacticalAnalyzer: SyntacticalAnalyzer? = nil
    ) {
        self.code = code
        self.isRunEnabled = isRunEnabled
        self.cancellables = cancellables
        self.fileScanner = fileScanner

        if let lexicalAnalyzer {
            self.lexicalAnalyzer = lexicalAnalyzer
        } else {
            self.lexicalAnalyzer = LexicalAnalyzer(code: code)

        }

        if let syntacticalAnalyzer {
            self.syntacticalAnalyzer = syntacticalAnalyzer
        } else {
            self.syntacticalAnalyzer = SyntacticalAnalyzer(tokens: [])
        }

        enableRunButton()
        observeCodePicker()
    }

    func enableRunButton() {
        
        self.$code.sink { [unowned self] value in

            /// Validate input to enable Run Button
            self.isRunEnabled = self.validateInput(self.code)
            self.savedCode = self.savedCode != self.code ? nil : self.code
        }
        .store(in: &cancellables)
    }

    func observeCodePicker() {
        self.$codeFile.sink { [unowned self] value in
            self.importCode(value)
            self.runAnalysis()
        }
        .store(in: &cancellables)
    }

    func observeCodeChanges() {
        self.$code.sink { [unowned self] value in
            self.importCode(codeFile)
            self.runAnalysis()
        }
        .store(in: &cancellables)
    }

    func exportCode(_ file: FileScanner.FilesName = .code1) {
        codeFile = file
        fileScanner.writeTo(fileName: file, value: code)
        savedCode = code
    }

    func importCode(_ file: FileScanner.FilesName = .code1) {
        let data = fileScanner.readFrom(fileName: file)
        code = data

        self.lexicalAnalyzer = LexicalAnalyzer(code: code)
        self.syntacticalAnalyzer = SyntacticalAnalyzer(tokens: self.lexicalAnalyzer.tokens)

        styled = AttributedString(data)
    }

    func runAnalysis() {
        self.lexicalAnalyzer = LexicalAnalyzer(code: code)
        self.syntacticalAnalyzer = SyntacticalAnalyzer(tokens: self.lexicalAnalyzer.tokens)
    }

    private func validateInput(_ input: String) -> Bool {
        // TODO: Fazer validações
        guard input.description.count >= 3 else { return false }
        return true
    }

    deinit {
        self.cancellables.removeAll()
    }
}
