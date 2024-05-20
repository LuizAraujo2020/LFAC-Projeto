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
    static var mock: Self {
        PToken(
            id: 0,
            type: .keyword,
            value: "var",
            line: 1,
            column: 1
        )
    }
}
