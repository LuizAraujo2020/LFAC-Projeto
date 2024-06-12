//
//  RegexSource.swift
//  lfac
//
//  Created by Luiz Araujo on 12/05/24.
//

import Foundation

struct RegexSource {
    var letters = /^[a-zA-Z]$/
    var digits = /^[0-9]$/
    var decimalSign = /^[.|,]{1}$/
    var terminators = /^[\r|\n|\t|\0|\s]$/
    var operators = /^[:|<|>|=|\+|\*|\/|\-]$/
    var keywords = /^(program|var|integer|real|boolean|procedure|begin|end|if|then|else|while|do|or|true|false|div|and|not|READ|WRITE)$/
    var symbol = /^[.|,|;|:|\(|\)|{|}|\[|\]]/
    var space = /^[\s]+$/
    var commentary = /[\/]{2,}/
    var booleans = /^(true|false)$/
    
    var keywordsArray = ["program", "var", "integer", "real", "boolean", "procedure", "begin", "end", "if", "then", "else", "while", "do", "or", "true", "false", "div", "and", "not", "READ", "WRITE"]
}
