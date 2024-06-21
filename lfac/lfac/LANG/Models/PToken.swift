//
//  PToken.swift
//  lfac
//
//  Created by Luiz Araujo on 08/05/24.
//

struct PToken: Identifiable, Hashable {
    var id: Int
    var type: PTokenType
    var name: String
    var value: String
    var line: Int
    var column: Int

    internal init(
        id: Int,
        type: PTokenType,
        name: String,
        value: String,
        line: Int,
        column: Int
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.value = value
        self.line = line
        self.column = column
    }

    internal init(
        id: Int,
        type: PTokenType,
        value: String,
        line: Int,
        column: Int
    ) {
        self.id = id
        self.type = type
        self.name = type.name
        self.value = value
        self.line = line
        self.column = column
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension PToken {
    static var mockToken: Self {
        PToken(
            id: 0,
            type: .keyword,
            value: "var",
            line: 1,
            column: 1
        )
    }

    ///program prog1;
    ///var soma: integer;
    ///begin
    ///soma := 25;
    ///end.
    static var mockTokens: [Self] {
        [
            .init(id: 0, type: .keyword, value: "program", line: 1, column: 1),
            .init(id: 1, type: .identifiers, value: "prog1", line: 1, column: 9),
            .init(id: 2, type: .terminators, value: ";", line: 1, column: 14),
            .init(id: 3, type: .keyword, value: "var", line: 2, column: 1),
            .init(id: 4, type: .identifiers, value: "soma", line: 2, column: 5),
            .init(id: 5, type: .relationals, value: ":", line: 2, column: 9),
            .init(id: 6, type: .keyword, value: "integer", line: 2, column: 11),
            .init(id: 7, type: .terminators, value: ";", line: 2, column: 18),
            .init(id: 8, type: .keyword, value: "begin", line: 3, column: 1),
            .init(id: 9, type: .identifiers, value: "soma", line: 4, column: 1),
            .init(id: 10, type: .relationals, value: ":=", line: 4, column: 6),
            .init(id: 11, type: .integers, value: "25", line: 4, column: 9),
            .init(id: 12, type: .keyword, value: "end", line: 4, column: 1),
            .init(id: 13, type: .terminators, value: ".", line: 5, column: 4)
        ]
    }

//    static var mockTokens: [Self] {
//
//    }
}
