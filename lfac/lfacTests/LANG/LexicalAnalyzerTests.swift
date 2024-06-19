//
//  LexicalAnalyzerTests.swift
//  lfacTests
//
//  Created by Luiz Araujo on 13/05/24.
//

import XCTest
@testable import lfac

final class LexicalAnalyzerTests: XCTestCase {
    var sut: LexicalAnalyzer!

    override func setUpWithError() throws {
        sut = LexicalAnalyzer(
            code: """
                program testeA;
                    var qtd = 12;
                        numero = 3245;
                """,
            states: TransitionState.allCases,
            initialState: TransitionState.q0,
            finalStates: TransitionState.finals
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_getCharType() throws {
        var type = CharType.letters
        var result = sut.getCharType("v")
        XCTAssertEqual(result, type)
        
//        type = CharType.space
//        result = sut.getCharType(" ")
//        XCTAssertEqual(result, type)

        type = CharType.terminators
        var string = "\n"
        result = sut.getCharType(string)
        XCTAssertEqual(result, type)

        type = CharType.terminators
        string = "\n"
        result = sut.getCharType(string)
        XCTAssertEqual(result, type)

        type = CharType.terminators
        string = ";"
        result = sut.getCharType(string)
        XCTAssertEqual(result, type)

        type = CharType.operators
        string = ":"
        result = sut.getCharType(string)
        XCTAssertEqual(result, type)

        type = CharType.digits
        result = sut.getCharType("0")
        XCTAssertEqual(result, type)

        type = CharType.decimalSign
        result = sut.getCharType(".")
        XCTAssertEqual(result, type)

        type = CharType.symbols
        result = sut.getCharType("{")
        XCTAssertEqual(result, type)

        type = CharType.operators
        result = sut.getCharType("+")
        XCTAssertEqual(result, type)
    }
}
