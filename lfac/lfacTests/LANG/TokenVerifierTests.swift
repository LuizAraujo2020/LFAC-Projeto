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

    // MARK: - Testing .identifier
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


    // MARK: - Testing .integer
    func test_getLexemeType_shouldReturnInteger() throws {
        let correctType = PTokenType.integer
        let valids = [
            "0", "1", "123", "0123", "-45", "-0", "+0", "+56476","-45223"//, "1e2", "1e+33", "63e-56"
        ]

        for word in valids {
            let type = sut.getLexemeType(word)
            XCTAssertEqual(correctType, type, "\(word) type != number")
        }
    }

    func test_getLexemeType_shouldntReturnInteger() throws {
        let wrongType = PTokenType.integer
        let invalids = [
            "+","-","1e", "e1", "e", "63.e-56", "1d223", "nome1", "63e-56.234",
            "123.2421.1231","133,33","123e2313e213", "31e23.21e312",
            "+=", "<", ">", " ", "", "1e2.43", "1.432", "11.12e13", "0.3", "+45.3"
        ]

        for word in invalids {
            let type = sut.getLexemeType(word)
            XCTAssertNotEqual(wrongType, type, "\(word) type == number")
        }
    }


    // MARK: - Testing .real
    func test_getLexemeType_shouldReturnReal() throws {
        let correctType = PTokenType.real
        let valids = [
            "0.0", "1.324554", "123.0", "0.123", "-4.5", "-0.0", "+0.0", "+56.476","-452.23"
        ]

        for word in valids {
            let type = sut.getLexemeType(word)
            XCTAssertEqual(correctType, type, "\(word) type != real")
        }
    }

    func test_getLexemeType_shouldntReturnReal() throws {
        let wrongType = PTokenType.real
        let invalids = [
            "+","-","1e", "e1", "e", "63.e-56", "1d223", "nome1", "63e-56.234",
            "123.2421.1231","133,33","123e2313e213", "31e23.21e312",
            "+=", "<", ">", " ", "", "1e2.43", "11.12e13", "1352.576.3", "1.352.576.3"
        ]

        for word in invalids {
            let type = sut.getLexemeType(word)
            XCTAssertNotEqual(wrongType, type, "\(word) type == real")
        }
    }


    // MARK: - Testing .keyword
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
            "prasogram", "1var", "intedadger", "raaeal", "procedure1", "b3gin", "e_nd", "ixf", "thden", "elif", "wh1le",
        ]

        for word in invalids {
            let type = sut.getLexemeType(word)
            XCTAssertNotEqual(correctType, type, "\(word) type == keyword")
        }
    }


    // MARK: - Testing space
    func test_getLexemeType_shouldReturnSpace() throws {
        let correctType = PTokenType.space
        let valids = [
            " ", "  "
        ]

        for word in valids {
            let type = sut.getLexemeType(word)
            XCTAssertEqual(correctType, type, "\(word) != space")
        }
    }

    func test_getLexemeType_shouldntReturnSpace() throws {
        let incorrectType = PTokenType.space
        let invalids = [
            "\0", "aasda", "a", "jug113", "dsg23sf23", "12",
            "+", "<=", ":=", "_"
        ]

        for word in invalids {
            let type = sut.getLexemeType(word)
            XCTAssertNotEqual(incorrectType, type, "\(word) == space")
        }
    }


    // MARK: - Testing commentary
    func test_getLexemeType_shouldReturnComment() throws {
        let correctType = PTokenType.commentary
        let valids = [
            "//", "////", "////"
        ]

        for word in valids {
            let type = sut.getLexemeType(word)
            XCTAssertEqual(correctType, type, "\(word) != commentary")
        }
    }

    func test_getLexemeType_shouldntReturnComment() throws {
        let incorrectType = PTokenType.commentary
        let invalids = [
            "hkjo/", "/n/", "123", "adasd", "123wqa", "asd12", " ", "<", "="
        ]

        for word in invalids {
            let type = sut.getLexemeType(word)
            XCTAssertNotEqual(incorrectType, type, "\(word) == commentary")
        }
    }


    // MARK: - Testing operatorMath
    func test_getLexemeType_shouldReturnOperatorMath() throws {
        let correctType = PTokenType.operatorMath
        let valids = [
            "+", "*", "/", "-"
        ]

        for word in valids {
            let type = sut.getLexemeType(word)
            XCTAssertEqual(correctType, type, "\(word) != operatorMath")
        }
    }

    func test_getLexemeType_shouldntReturnOperatorMath() throws {
        let incorrectType = PTokenType.operatorMath
        let invalids = [
            "as", "<", ">", ":=", "asd", "123", "asd1"
        ]

        for word in invalids {
            let type = sut.getLexemeType(word)
            XCTAssertNotEqual(incorrectType, type, "\(word) == operatorMath")
        }
    }


    // MARK: - Testing operatorCompare
    //    func test_getLexemeType_shouldReturn<#TYPE#>() throws {
    //        let correctType = PTokenType.<#TYPE#>
    //        let valids = [
    //            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
    //        ]
    //
    //        for word in valids {
    //            let type = sut.getLexemeType(word)
    //            XCTAssertEqual(correctType, type, "\(word) != <#TYPE#>")
    //        }
    //    }

    //    func test_getLexemeType_shouldntReturn<#TYPE#>() throws {
    //        let incorrectType = PTokenType.<#TYPE#>
    //        let invalids = [
    //            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
    //        ]
    //
    //        for word in invalids {
    //            let type = sut.getLexemeType(word)
    //            XCTAssertNotEqual(incorrectType, type, "\(word) == <#TYPE#>")
    //        }
    //    }


    // MARK: - Testing operatorAttribution
    //    func test_getLexemeType_shouldReturn<#TYPE#>() throws {
    //        let correctType = PTokenType.<#TYPE#>
    //        let valids = [
    //            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
    //        ]
    //
    //        for word in valids {
    //            let type = sut.getLexemeType(word)
    //            XCTAssertEqual(correctType, type, "\(word) != <#TYPE#>")
    //        }
    //    }

    //    func test_getLexemeType_shouldntReturn<#TYPE#>() throws {
    //        let incorrectType = PTokenType.<#TYPE#>
    //        let invalids = [
    //            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
    //        ]
    //
    //        for word in invalids {
    //            let type = sut.getLexemeType(word)
    //            XCTAssertNotEqual(incorrectType, type, "\(word) == <#TYPE#>")
    //        }
    //    }


    // MARK: - Testing symbol
    //    func test_getLexemeType_shouldReturn<#TYPE#>() throws {
    //        let correctType = PTokenType.<#TYPE#>
    //        let valids = [
    //            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
    //        ]
    //
    //        for word in valids {
    //            let type = sut.getLexemeType(word)
    //            XCTAssertEqual(correctType, type, "\(word) != <#TYPE#>")
    //        }
    //    }

    //    func test_getLexemeType_shouldntReturn<#TYPE#>() throws {
    //        let incorrectType = PTokenType.<#TYPE#>
    //        let invalids = [
    //            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
    //        ]
    //
    //        for word in invalids {
    //            let type = sut.getLexemeType(word)
    //            XCTAssertNotEqual(incorrectType, type, "\(word) == <#TYPE#>")
    //        }
    //    }


    // MARK: - Testing invalidToken
    //    func test_getLexemeType_shouldReturn<#TYPE#>() throws {
    //        let correctType = PTokenType.<#TYPE#>
    //        let valids = [
    //            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
    //        ]
    //
    //        for word in valids {
    //            let type = sut.getLexemeType(word)
    //            XCTAssertEqual(correctType, type, "\(word) != <#TYPE#>")
    //        }
    //    }

    //    func test_getLexemeType_shouldntReturn<#TYPE#>() throws {
    //        let incorrectType = PTokenType.<#TYPE#>
    //        let invalids = [
    //            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
    //        ]
    //
    //        for word in invalids {
    //            let type = sut.getLexemeType(word)
    //            XCTAssertNotEqual(incorrectType, type, "\(word) == <#TYPE#>")
    //        }
    //    }











    // MARK: - Testing endLine

    // MARK: - Testing terminators

    //    func test_getLexemeType_shouldReturn<#TYPE#>() throws {
    //        let correctType = PTokenType.<#TYPE#>
    //        let valids = [
    //            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
    //        ]
    //
    //        for word in valids {
    //            let type = sut.getLexemeType(word)
    //            XCTAssertEqual(correctType, type, "\(word) != <#TYPE#>")
    //        }
    //    }

    //    func test_getLexemeType_shouldntReturn<#TYPE#>() throws {
    //        let incorrectType = PTokenType.<#TYPE#>
    //        let invalids = [
    //            "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>", "<#TYPE#>"
    //        ]
    //
    //        for word in invalids {
    //            let type = sut.getLexemeType(word)
    //            XCTAssertNotEqual(incorrectType, type, "\(word) == <#TYPE#>")
    //        }
    //    }
}
