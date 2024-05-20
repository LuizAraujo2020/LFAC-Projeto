//
//  LexicalAnalyzer.swift
//  lfac
//
//  Created by Luiz Araujo on 12/05/24.
//

import Foundation

protocol LexicalAnalyzeable {

}

// Autômato Finito Determinístico
// Um autômato finito determinístico (AFD) é um modelo para definição de linguagens regulares composto de cinco elementos ⟨Σ, S, s0 , δ, F ⟩, onde:
// Σ é o alfabeto sobre o qual a linguagem é definida; 
// S é um conjunto finito não vazio de estados;
// s0 é o estado inicial, s0 ∈ S;
// δ éafunçãodetransiçãodeestados,δ:S×Σ→S;
// F é o conjunto de estados finais, F ⊆ S.

class LexicalAnalyzer {
    var tokens = [PToken]()

    var code: [String]

    private var currentState: TransitionState
    private var currentRow = 0
    private var currentColumn = 0
    private var currentLexeme = ""


    private let states: [TransitionState]
    private var initialState: TransitionState
    private let finalStates: [TransitionState]

    private let regexSource: RegexSource
    private let alphabet: Dictionary

    internal init(
        code: String,
        states: [TransitionState],
        initialState: TransitionState,
        finalStates: [TransitionState],
        alphabet: Dictionary = Dictionary(),
        regexSource: RegexSource = RegexSource()
    ) {
        self.code = code.map { String($0) }//Array("program testeA\nvar qtd = 12\nvar numero = 3245\n")
        self.alphabet = alphabet
        self.states = states
        self.initialState = initialState
        self.finalStates = finalStates
        self.regexSource = regexSource

        self.currentState = initialState

        analyze()
    }

    private func analyze() {
        /// Adiciona o EOF
        code.append("\0")
        currentState = .q0


        while currentRow < code.count {
            /// Obter o próximo caracter
            let currentCharacter = code[currentRow]
            let characterType = getCharType(currentCharacter)

            //            if checkIsTerminator(code[currentRow]) {
            //                print("#")
            //            } else {
            //                print(currentCharacter)
            //            }


            guard characterType != .invalid else {
                print(ErrorState.e1.localizedDescription)
                return
            }

            do {
                currentState = try transition(S: currentState, C: currentCharacter)

            } catch {
                print(error.localizedDescription)
            }

            print("LEXEME: \(currentLexeme)")
            print("STATE: \(currentState)")
            print("CHAR: \(currentCharacter)\n")

            /// Não existe caracter?
            if checkIsTerminator(currentCharacter) {
                increaseColumn(char: currentCharacter)

                /// É estado final?
                if currentState == .q2 {
                    if checkIsKeyword(currentLexeme) {
                        currentState = .q3
                    } else  {
                        currentState = .q4
                    }
                }

                if let token = createToken(
                    S: currentState,
                    id: tokens.count,
                    lexeme: currentLexeme,
                    row: currentRow,
                    column: currentColumn
                ) {
                    saveToken(token)
                    currentLexeme = ""
                    currentState = .q0
                } else {
                    print("Falha ao criar o token")
                    print("LEXEME: \(currentLexeme)")
                }
            } else {
                do {
                    currentState = try transition(S: currentState, C: currentCharacter)
                    currentLexeme += currentCharacter
                } catch {
                    print(error.localizedDescription)
                }
            }







//            do {
//                currentState = try transition(S: currentState, C: currentCharacter)
//
//            } catch {
//                print(error.localizedDescription)
//            }
//
//            if checkIsTerminator(code[currentRow]) || currentRow > code.count {
//                if code[currentRow] == "\n" { currentColumn += 1 }
//
//                do {
//                    currentState = try transition(S: currentState, C: currentCharacter)
//
//                } catch {
//                    print(error.localizedDescription)
//                }
//
//                guard currentState.isFinal else {
//                    fatalError("Código invalido")
//                }
//
//                if let token = createToken(
//                    S: currentState,
//                    id: tokens.count,
//                    lexeme: currentLexeme,
//                    row: currentRow,
//                    column: currentColumn
//                ) {
//                    tokens.append(token)
//                } else {
//                    print("Falha ao criar o token")
//                    print("LEXEME: \(currentLexeme)")
//                }
//
////                tokens.append(token)
//                currentLexeme = ""
//                currentState = .q0
//            } else {
//                print("STATE: \(currentState.id) CHARACTER: \(currentCharacter)")
//                currentLexeme += code[currentRow]
//            }





//
//
//            while !checkIsTerminator(code[currentRow]) && currentRow < code.count - 1 {
//                do {
//                    currentState = try transition(S: currentState, C: currentCharacter)
//
//                } catch {
//                    print(error.localizedDescription)
//                }
//
//                currentLexeme += currentCharacter
//
//                currentRow = nextCharacter(row: currentRow)
//            }
////
////
//            if checkIsTerminator(currentCharacter) {
//                if let token = createToken(
//                    S: currentState,
//                    lexeme: currentLexeme,
//                    row: currentRow,
//                    column: currentColumn
//                ) {
//                    tokens.append(token)
//                } else {
//                    print("Cadeia não aceita, falhou!")
//                }
//////            } else {
//////
//////                do {
//////                    currentState = try transition(S: currentState, C: currentCharacter)
//////
//////                } catch {
//////                    print(error.localizedDescription)
//////                }
//            }
////            
//            currentState = .q0
//            currentLexeme = ""
////            /// Separar linhas
////            if currentCharacter == "\n" || currentCharacter == "\0" { currentColumn += 1 }
////
            currentRow = nextCharacter(row: currentRow)
        }
    }

    private func nextCharacter(row: Int) -> Int {
        row + 1
    }

//    private func search(char: String) -> TransitionState {
//        
//    }

    private func createToken(
        S: TransitionState,
        id: Int,
        lexeme: String,
        row: Int,
        column: Int
    ) -> PToken? {
        if let type = S.tokenType {

            return PToken(
                id: id,
                type: type,
                name: type.name,
                value: lexeme,
                line: row,
                column: column
            )
        }

        return nil
    }

    private func saveToken(_ token: PToken) {
        tokens.append(token)
    }

    private func concat(lexeme: String, char: String) -> String {
        return lexeme + char
    }

    func transition(S: TransitionState, C: String) throws -> TransitionState {
        let char = getCharType(C)

        switch currentState {
        case .q0:
            switch char {
            case .letters: return .q1
            case .digits: return .q5
            case .decimalSign: throw ErrorState.e1
            case .operators: return .q12
            case .keywords: break
            case .symbols: return .q10
            case .space, .terminators, .commentary: return .q0
            case .invalid: throw ErrorState.e1
            }

        case .q1:
            switch char {
            case .letters, .digits: return .q1
            case .decimalSign: throw ErrorState.e2
            case .terminators, .space: return .q2
            case .operators, .symbols: throw ErrorState.e3
            case .keywords: return .q3
            case .commentary: return .q14
            case .invalid: throw ErrorState.e1
            }

        case .q2:
            if currentLexeme.contains(regexSource.keywords) {
                return .q3
            } else {
                return .q4
            }

        case .q3, .q4:

            switch char {
            case .terminators, .space: return .q0
            default: throw ErrorState.e1
            }

        case .q5:
            switch char {
            case .letters: throw ErrorState.e3
            case .digits: return .q5
            case .decimalSign: return .q7
            case .terminators, .space: return .q6
            case .operators, .symbols: throw ErrorState.e4
            case .keywords: return .q3
            case .commentary: return .q14
            case .invalid: throw ErrorState.e1
            }

        case .q6:
            switch char {
            case .terminators, .space: return .q0
            default: throw ErrorState.e1
            }

        case .q7:
            
            switch char {
            case .letters: throw ErrorState.e3
            case .digits: return .q8
            case .decimalSign: throw ErrorState.e5
            case .terminators, .space: throw ErrorState.e4
            case .operators, .symbols: throw ErrorState.e4
            case .keywords: return .q3
            case .commentary: return .q14
            case .invalid: throw ErrorState.e1
            }

        case .q8:
            switch char {
            case .letters: throw ErrorState.e3
            case .digits: return .q8
            case .decimalSign: throw ErrorState.e5
            case .terminators, .space: return .q9
            case .operators, .symbols: throw ErrorState.e4
            case .keywords: return .q3
            case .commentary: return .q14
            case .invalid: throw ErrorState.e1
            }

        case .q9:
            switch char {
            case .terminators, .space: return .q0
            default: throw ErrorState.e1
            }

        case .q10:
            switch char {
            case .terminators, .space: return .q11
            default: throw ErrorState.e6
            }

        case .q11:
            
            switch char {
            case .terminators, .space: return .q0
            default: throw ErrorState.e1
            }

        case .q12:
            switch char {
            case .operators: return .q12
            case .terminators, .space: return .q13
            default: throw ErrorState.e7
            }

        case .q13:
            switch char {
            case .terminators, .space: return .q0
            default: throw ErrorState.e1
            }

        case .q14:
            switch char {
            case .terminators, .space: return .q0
            default: throw ErrorState.e1
            }
        }

//        switch char {
//        case .letters:
//            if currentState == .q0 || currentState == .q1 { return .q1 }
//
//            if currentState == .q5 || currentState == .q7 || currentState == .q8 {
//                throw ErrorState.e3
//            }
//
//        case .digits:
//            if currentState == .q0 || currentState == .q5 { return .q5 }
//
//            if currentState == .q7 || currentState == .q8 { return .q8 }
//
//        case .decimalSign:
//            if currentState == .q5 { return .q7 }
//
//            if currentState == .q0 { throw ErrorState.e1 }
//
//            if currentState == .q1 { throw ErrorState.e2 }
//
//            if currentState == .q7 || currentState == .q8 { throw ErrorState.e5 }
//
//        case .terminators:
//            if currentState == .q0 { return .q0 }
//
//            if currentState == .q1 { return .q2 }
//
//            if currentState == .q5 { return .q6 }
//
//            if currentState == .q8 { return .q9 }
//
//            if currentState == .q10 { return .q11 }
//
//            if currentState == .q12 { return .q13 }
//
//            if currentState == .q7 { throw ErrorState.e4 }
//
//        case .operators:
//            if currentState == .q0 { return .q12 }
//
//            if currentState == .q1 { throw ErrorState.e3 }
//
//            if currentState == .q5 || currentState == .q7 || currentState == .q8 {
//                throw ErrorState.e4
//            }
//
//        case .symbols:
//            if currentState == .q0 { return .q10 }
//
//            if currentState == .q1 { throw ErrorState.e3 }
//
//            if currentState == .q5 || currentState == .q7 || currentState == .q8 {
//                throw ErrorState.e4
//            }
//
//        case .keywords:
//            return .q3
//
//        case .space:
//            if currentState == .q1 {
//
//
////                if currentState == .q2 {
//                    if currentLexeme.contains(regexSource.keywords) {
//                        return .q3
//                    } else {
//                        return .q4
//                    }
////                }
////                return .q2
//            }
//
//        case .commentary:
//            currentRow += 1
//
//        case .invalid:
//            throw ErrorState.e1
//        }
//
        throw ErrorState.e1
    }
}

// MARK: - HELPERS
extension LexicalAnalyzer {

    func increaseColumn(char: String) {
        if char == "\n" {
            self.currentColumn += 1
        }
    }

    func getCharType(_ char: String) -> CharType {

        guard !checkIsLetter(char) else { return CharType.letters }
        guard !checkIsDigit(char) else { return .digits }
        guard !checkIsDecimalSign(char) else { return .decimalSign }
        guard !checkIsTerminator(char) else { return .terminators }
        guard !checkIsSpace(char) else { return CharType.space }
        guard !checkIsOperator(char) else { return .operators }
        guard !checkIsSymbol(char) else { return CharType.symbols }

        return .invalid
    }

    func checkIsLetter(_ string: String) -> Bool {
        let regex = Regex(regexSource.letters)
        return string.contains(regex)
    }

    func checkIsDigit(_ string: String) -> Bool {
        let regex = Regex(regexSource.digits)
        return string.contains(regex)
    }

    func checkIsDecimalSign(_ string: String) -> Bool {
        let regex = Regex(regexSource.decimalSign)
        return string.contains(regex)
    }

    func checkIsTerminator(_ string: String) -> Bool {
        let regex = Regex(regexSource.terminators)
        return string.contains(regex)
    }

    func checkIsSpace(_ string: String) -> Bool {
        let regex = Regex(regexSource.space)
        return string.contains(regex)
    }

    func checkIsOperator(_ string: String) -> Bool {
        let regex = Regex(regexSource.operators)
        return string.contains(regex)
    }

    func checkIsSymbol(_ string: String) -> Bool {
        let regex = Regex(regexSource.symbol)
        return string.contains(regex)
    }

    func checkIsKeyword(_ string: String) -> Bool {
        for keyword in regexSource.keywordsArray {
            if keyword == string {
                return true
            }
        }

        return false
    }
}
