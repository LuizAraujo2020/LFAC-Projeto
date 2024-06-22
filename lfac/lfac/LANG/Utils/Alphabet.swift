//
//  Dictionary.swift
//  lfac
//
//  Created by Luiz Araujo on 12/05/24.
//

import Foundation

protocol Dictionaryable {

    var alphabet: [String] { get }
    var keywords: [String] { get }
    var relationals: [String] { get }
    var operators: [String] { get }
    var attribution: [String] { get }
    var space: [String] { get }
    var commentary: String { get }
    var terminators: [String] { get }
    var booleans: [String] { get }
    var separators: String { get }
    var integers: Regex<(Substring, Substring)> { get }
    var identifiers: Regex<(Substring)> { get }
    var symbols: [String] { get }
}
struct Dictionary: Dictionaryable {
    
    let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
                    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
                    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                    "=", ">", "<", "+", "-", "*", "/", "!", ".", ",", ":", ";", "(", ")", ";", "\r", "\n", "\t", "\0", "", " "
    ]
    
    var keywords = ["program", "var", "integer", "real", "boolean", "procedure", "begin", "end", "if", "then", "else", "while", "do", "or", "div", "and", "not", "READ", "WRITE", "readln", "writeln"]
    
    var relationals = ["=", "<>", "<", "<=", ">=", ">"]
    var operators = ["+", "*", "/", "-"]
    var attribution = [":", ":="]

    var commentary = "//" //^([\/]{2,})$/

    var terminators = [".", ";"]
    var separators = ","

    var symbols = ["(", ")", "[", "]", "{", "}", "!"]

    var booleans = ["true", "false"]
    var integers = /^([0-9]+)$/
    var identifiers = /^[a-zA-Z_$][\w$]*$/


    var space = [" ", "\t"]
}
