////
////  RegexSource.swift
////  lfac
////
////  Created by Luiz Araujo on 12/05/24.
////
//
//import Foundation
//
//protocol RegexSourceable {
//
//    var keywords: String { get }
//    var symbols: String { get }
//    var identifiers: String { get }
//    var numbers: String { get }
//    var terminators: String { get }
//    var testString: String { get }
//}
//
//struct RegexSource: RegexSourceable {
//
//    ////    let regex = "[0-9]|[a-zA-Z_]+[a-zA-Z0-9_]*|[+|*|/|-|{|}|\[|\]|\||.|,|;|<|>|=|&|!]"
//    ////    let keywords = [
//    ////        "program", "var", "integer", "real", "boolean", "procedure", "begin",
//    ////        "end", "if", "then", "else", "while", "do", "or", "div", "and", "not",
//    ////        "READ", "WRITE"
//    ////    ]
//    ////
//    ////    let symbols = "[+|-|*|/|{|}|(|)|.|:|;|<|>|=]"
//    ////    let identifier = "[a-zA-Z]+[a-zA-Z0-9]*"
//    ////    let integer = "([+|-])?[0-9]+"
//    ////    let real = "([+|-])?[0-9]+[.0-9]"
//    //
//    //    private let keywords = "program|var|integer|real|boolean|procedure|begin|end|if|then|else|while|do|or|div|and|not|READ|WRITE"
//    //    private let symbols = "<|>|=|>=|<=|<>|.|,|;|:=|:|(|)|+|-|*|/"
//    //    private let identifiers = "[a-zA-Z]+[a-zA-Z0-9]*"
//    //    private let numbers = "([+|-])?[0-9]+([.][0-9])?[0-9]*([e]{1}([+|-])?[0-9]+)?"
//    //    private let ignored = [" ", "\r", "\n", "\t", "\0"]
//
//    let keywords = "program|var|integer|real|boolean|procedure|begin|end|if|then|else|while|do|or|true|false|div|and|not|READ|WRITE"
//    let symbols = "[<|>|=|>=|<=|<>|.|,|;|:=|:|(|)|+|-|*|/]"
//    let identifiers = "[a-zA-Z]+[a-zA-Z0-9]*"
//    //private let numbers = "([+|-])?[0-9]+([.][0-9])?[0-9]*([e]{1}([+|-])?[^a-zA-Z][0-9]+)?"
//    let numbers = "[+|-]?[0-9][0-9]*[.]?[0-9][0-9]*[e]?[+|-]?[0-9]*"
//    let terminators = "\\s|\\r|\\n|\\t|\\0"
//    let testString = "palavra asjdbalsd ashdb +233424.05e-353f45 lh -113.2 ew2 program jasdflajbdf jzbckghdasd adfblh dfaj dgfagdufguad lalfasldgflgudalaudflu galu"
//}
