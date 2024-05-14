//
//  PToken.swift
//  lfac
//
//  Created by Luiz Araujo on 08/05/24.
//

struct PToken {
    var type: PTokenType
    var name: String
    var value: String
    var line: Int
    var column: Int

    internal init(
        type: PTokenType,
        name: String,
        value: String,
        line: Int,
        column: Int
    ) {
        self.type = type
        self.name = name
        self.value = value
        self.line = line
        self.column = column
    }

    internal init(
        type: PTokenType,
        value: String,
        line: Int,
        column: Int
    ) {
        self.type = type
        self.name = type.name
        self.value = value
        self.line = line
        self.column = column
    }


}
