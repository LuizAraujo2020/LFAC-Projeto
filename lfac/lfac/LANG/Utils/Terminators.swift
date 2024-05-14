//
//  Terminators.swift
//  lfac
//
//  Created by Luiz Araujo on 12/05/24.
//

import Foundation

enum Terminators: String, CaseIterable {
    /// Término de cadeia
    case space = "\\s"
    case lineBreak = "\n"
    case tab = "\t"
    case carriageReturn = "\r"
    case EOL = "\0"
    case EOF = "EOF"
}
