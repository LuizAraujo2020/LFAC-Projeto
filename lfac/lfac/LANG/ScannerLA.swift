////
////  ScannerLA.swift
////  lfac
////
////  Created by Luiz Araujo on 13/05/24.
////
//
//import Foundation
//
//class ScannerLA {
//    /// Array que recebe todo o código digitado pelo usuário
//    private let code: String
//
//    private var token: PToken?
//
//    /// Recebe todo o código e divide em caracteres
//    private var characteres = [[String]]()
//    /// Variável que recebe o texto que representa o Token
//    var tokens = [Int : PToken]()
//
//    /// Verifica a qual tipo pertence o token
//    var tokenVerifier: TokenVerifier
////    private let regex: any RegexSourceable
//
//    // MARK: - Estados
//    /// Index usado para percorrer o código
//    private var next: Int
//    /// Linha e Coluna: posição do input
//    private var row: Int
//    private var column: Int
//
//    internal init(
//        code: String,
//        token: PToken? = nil,
//        tokenVerifier: TokenVerifier,
//        next: Int = 0,
//        row: Int = 0,
//        column: Int = 0
////        regex: any RegexSourceable = RegexSource()
//    ) {
//        self.code = code
//        self.token = token
//        self.tokenVerifier = tokenVerifier
//        self.next = next
//        self.row = row
//        self.column = column
////        self.regex = regex
//
//        /// Separa o código lido em lexemas válidos ou não
//        scanCode(code)
//    }
//
//    private func scanCode(_ code: String) {
//        var tokenID = 0
//
//        /// Divide o código em caracteres
//        characteres = splitCode(code)
//
//        for row in characteres.indices {
//            for column in characteres[row].indices {
//                guard let token = getToken(from: characteres[row][column], row: row, column: column) else { continue }
//
//                tokens[tokenID] = token
//                tokenID += 1
//            }
//        }
//    }
//
//    private func splitCode(_ code: String) -> [[String]] {
//        var result = [[String]]()
//        let rows = code.split(separator: "\n")
//
//        for row in rows {
//            let columns = row.split(separator: " ").map(String.init)
////            let columns = Array(row).map(String.init)
//            result.append(columns)
//        }
//
//        return result
//    }
//
//    /// Metodo principal do analisador, faz a mecânica do autômato
//    func getToken(from word: String, row: Int, column: Int) -> PToken? {
//        /// Verifica se é o fim do código
//        guard row < characteres.count && column < characteres[characteres.count - 1].count else { return nil }
//        guard !word.isEmpty, word != "\0", word != "\r" else { return nil }
//
////        guard let type = tokenVerifier.getLexemeType(word) else { return nil }
//        let type = tokenVerifier.getLexemeType(word)
//
//        return PToken(
//            type: type,
//            name: type.name,
//            value: word,
//            line: row,
//            column: column
//        )
//    }
//}
