//
//  TokenVerifierTests.swift
//  lfacTests
//
//  Created by Luiz Araujo on 13/05/24.
//

import XCTest
@testable import lfac

final class TokenVerifierTests: XCTestCase {
    var sut: TokenVerifier!

    override func setUpWithError() throws {
        sut = TokenVerifier()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_getLexemeType_shouldReturnIdentifier() throws {
        let correctType = PTokenType.identifier
        let valids = [
            "nome", "nome2", "asdave12qwasd",
        ]

        for word in valids {
            let type = sut.getLexemeType(word)
            XCTAssertEqual(correctType, type, "\(word) type != identifier")
        }
    }

    func test_getLexemeType_shouldntReturnIdentifier() throws {
        let correctType = PTokenType.identifier
        let invalids = [
            "1nome", "213", "+", "=", " ", "\n", "\r", "\0", "\t"
        ]

        for word in invalids {
            let type = sut.getLexemeType(word)
            XCTAssertNotEqual(correctType, type)
        }
    }

    func test_getLexemeType_shouldReturnNumber() throws {
        let correctType = PTokenType.number
        let valids = [
            "0", "1", "123", "0123", "1.432", "11.12e13",
            "-45.3", "+45.3", "-0", "+0", "1e2", "1e2.43",
            "1e+33", "63.0e-56", "63e-56.234", "+56476","-45223"
        ]

        for word in valids {
            let type = sut.getLexemeType(word)
            XCTAssertEqual(correctType, type, "\(word) type != number")
        }
    }

    func test_getLexemeType_shouldntReturnNumber() throws {
        let wrongType = PTokenType.number
        let invalids = [
            "+","-","1e", "e1", "e", "63.e-56", "1d223", "nome1",
            "123.2421.1231","133,33","123e2313e213", "31e23.21e312",
            "+=", "<", ">", " ", ""
        ]

        for word in invalids {
            let type = sut.getLexemeType(word)
            XCTAssertNotEqual(wrongType, type, "\(word) type == number")
        }
    }

    func test_getLexemeType_shouldReturnKeyword() throws {
        let correctType = PTokenType.keyword
        let valids = [
            "program", "var", "integer", "real", "procedure", "begin", "end", "if", "then", "else", "while", "do", "or",
            "boolean", "true", "false", "div", "and", "not", "READ", "WRITE"
        ]

        for word in valids {
            let type = sut.getLexemeType(word)
            XCTAssertEqual(correctType, type, "\(word) type != keyword")
        }
    }

    func test_getLexemeType_shouldntReturnKeyword() throws {
        let correctType = PTokenType.keyword
        let invalids = [
            "prasogram", "1var", "intedadger", "raaeal", "procedure1", "b3gin", "e_nd", "if", "then", "elif", "while",
        ]

        for word in invalids {
            let type = sut.getLexemeType(word)
            XCTAssertNotEqual(correctType, type, "\(word) type == keyword")
        }
    }

//    func test_getLexemeType_shouldntReturn<#TYPE#>() throws {
//        let correctType = PTokenType.<#TYPE#>
//        let invalids = [
//            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
//        ]
//
//        for word in invalids {
//            let type = sut.getLexemeType(word)
//            XCTAssertNotEqual(correctType, type)
//        }
//    }

//    func test_getLexemeType_shouldntReturn<#TYPE#>() throws {
//        let correctType = PTokenType.<#TYPE#>
//        let invalids = [
//            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
//        ]
//
//        for word in invalids {
//            let type = sut.getLexemeType(word)
//            XCTAssertNotEqual(correctType, type)
//        }
//    }

//    func test_getLexemeType_shouldntReturn<#TYPE#>() throws {
//        let correctType = PTokenType.<#TYPE#>
//        let invalids = [
//            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
//        ]
//
//        for word in invalids {
//            let type = sut.getLexemeType(word)
//            XCTAssertNotEqual(correctType, type)
//        }
//    }
}
