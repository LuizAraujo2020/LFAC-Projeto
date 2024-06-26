//
//  LexicalAnalyzer.swift
//  lfac
//
//  Created by Luiz Araujo on 12/05/24.
//

import SwiftUI

class LexicalAnalyzer {
    var tokens = [PToken]()
    var errors = [ErrorState]()

    var code: [String]

    private var currentIndex = 0

    private var currentRow = 1
    private var currentColumn = 1

    private var lexeme = ""

    private let alphabet: Dictionary

    internal init(
        code: String,
        alphabet: Dictionary = Dictionary()
    ) {
        self.code = code.map { String($0) }
        self.alphabet = alphabet
        analyze()
    }

    func analyze() {
        resetAnalyzer()
        
        while currentIndex < code.count {
            let currentSymbol = code[currentIndex]

            guard alphabet.alphabet.contains(currentSymbol) else {
                print("Caracter inválido: \(currentSymbol)")
//                errors.append(ErrorState.e1(currentSymbol))
                errors.append(ErrorState(type: .e1(currentSymbol), row: currentRow, col: currentColumn))
                return
            }

            /// Check if its the end of a Lexeme.
            let regexLetterOrDigit = Regex(/^[a-zA-Z0-9]$/)
            if currentSymbol.contains(regexLetterOrDigit) && currentSymbol != " " && currentSymbol != "" {
                lexeme += code[currentIndex]

            } else {

                addLexemeToTokens()

                /// Increment the row counter.
                let regexSingleSign = /^[.|,|;|:|=|<|>|\+|\*|\/|\-|\(|\)|\[|\]|{|}]$/
                if currentSymbol.contains(regexSingleSign) {

                    let regexDoubleSign = /^(:=|<>|<=|>=)$/
                    if currentSymbol.contains(regexSingleSign) {
                        self.lexeme = currentSymbol

                        if currentIndex < code.count - 1 &&
                            currentSymbol == ":" ||
                            currentSymbol == "<" ||
                            currentSymbol == ">" {
                            let auxLexeme = currentSymbol + code[currentIndex + 1]

                            if auxLexeme.contains(regexDoubleSign) {
                                self.lexeme = auxLexeme

                                currentIndex += 1
                            }
                        }
                    }
                    addLexemeToTokens()
                }

                /// Increment the row counter.
                let regexRowCol = Regex(/^([\n]+)$/)
                if code[currentIndex].contains(regexRowCol) {
                    currentRow += 1
                    currentColumn = 1
                }
            }

            currentIndex += 1
            currentColumn += 1
        }
    }


    // MARK: - Helpers

    func addLexemeToTokens() {
        guard self.lexeme != "" else { return }

        let type = PTokenType.getType(lexeme: self.lexeme)
        let token = PToken(
            id: tokens.count,
            type: type,
            name: type.name,
            value: self.lexeme,
            line: currentRow,
            column: currentColumn - self.lexeme.count
        )

        tokens.append(token)

        self.lexeme = ""
    }

    private func resetAnalyzer() {
        currentIndex = 0
        currentRow = 1
        currentColumn = 1
    }
}

#Preview {
    LexicalAnalysisView(
        analyzer: LexicalAnalyzer(
            code: """
program testeA
var qtd = 12
var numero = 3245

"""
        )
    )
}
