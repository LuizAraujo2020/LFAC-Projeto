//
//  SyntacticalAnalyzerTests.swift
//  lfacTests
//
//  Created by Luiz Araujo on 19/06/24.
//

import XCTest
@testable import lfac

final class SyntacticalAnalyzerTests: XCTestCase {
    var sut: SyntacticalAnalyzer!

    override func setUpWithError() throws { sut = SyntacticalAnalyzer(tokens: PToken.mockTokens) }
    override func tearDownWithError() throws { sut = nil }

    // MARK: - CODE

    func test_code_failWithoutFinalDot() throws {
        sut = SyntacticalAnalyzer(tokens: MockCodes().codeFailNoDot)

        do {
            try sut.analyze()
            XCTFail("Deveria lançar uma exception.")

        } catch let error as ErrorState {
            XCTAssertTrue(error == .f2, "ERRO ESPERADO => ErrorState.f2: \(ErrorState.f2.localizedDescription)")

        } catch {
            XCTFail("O erro deveria ser do tipo ErrorState")
        }
    }


    // MARK: - PROGRAMA

    func test_programa_successful() throws {
        sut = SyntacticalAnalyzer(tokens: MockCodes().programaSuccessful)

        XCTAssertNoThrow(try sut.analyze())
    }


    // MARK: - COMANDO

    func test_comando_successful() throws {
    }

    func test_comando_fail() throws {

    }

//    func test_comandoComposto_successful() throws {
//        sut = SyntacticalAnalyzer(tokens: MockCodes().comandoSuccessful)
//
//        XCTAssertNoThrow(try sut.analyze())
//    }

    func test_comandoComposto_fail() throws {

    }


    // MARK: - ATRIBUICAO

    func test_atribuicao_successful() throws {
        var sut = SyntacticalAnalyzer(tokens: MockCodes().atribuicaoSuccessful)

        XCTAssertNoThrow(try sut.atribuicao())
    }

    func test_atribuicao_fail() throws {

    }


    func test_expressaoSimples_successful() throws {

    }


    func test_relacao_successful() throws {
        var sut = SyntacticalAnalyzer(tokens: MockCodes().relacaoSuccessful)

        XCTAssertNoThrow(try sut.relacao())
    }
}

struct MockCodes {

    var codeFailNoDot: [PToken] {[
            .init(id: 0, type: .keyword, value: "program", line: 1, column: 1),
            .init(id: 1, type: .identifiers, value: "prog1", line: 1, column: 9),
            .init(id: 2, type: .terminators, value: ";", line: 1, column: 14)
        ]}

    var programaSuccessful: [PToken] {[
            .init(id: 0, type: .keyword, value: "program", line: 1, column: 1),
            .init(id: 1, type: .identifiers, value: "prog1", line: 1, column: 9),
            .init(id: 2, type: .terminators, value: ";", line: 1, column: 14),
            .init(id: 3, type: .terminators, value: ".", line: 1, column: 1)
        ]}

    var comandoSuccessful: [PToken] {[
        .init(id: 0, type: .keyword, value: "program", line: 1, column: 1),
        .init(id: 1, type: .identifiers, value: "prog1", line: 1, column: 9),
        .init(id: 2, type: .terminators, value: ";", line: 1, column: 14),
        //            .init(id: 3, type: .terminators, value: "var", line: 2, column: 1),
        //            .init(id: 4, type: .terminators, value: "numero", line: 2, column: 1),
        //            .init(id: 5, type: .terminators, value: ":", line: 2, column: 1),
        //            .init(id: 6, type: .terminators, value: "integer", line: 2, column: 1),
        //            .init(id: 7, type: .terminators, value: ";", line: 2, column: 1),
            .init(id: 8, type: .keyword, value: "begin", line: 2, column: 1),
        .init(id: 9, type: .identifiers, value: "x", line: 3, column: 1),
        .init(id: 10, type: .relationals, value: ":=", line: 3, column: 3),
        .init(id: 11, type: .identifiers, value: "x", line: 3, column: 6),
        .init(id: 12, type: .operators, value: "+", line: 3, column: 8),
        .init(id: 13, type: .integers, value: "1", line: 3, column: 10),
        .init(id: 13, type: .integers, value: ";", line: 3, column: 11),
        .init(id: 2, type: .terminators, value: "end", line: 4, column: 1),
        .init(id: 3, type: .terminators, value: ".", line: 5, column: 1)
    ]}

    var atribuicaoSuccessful: [PToken] {[
        .init(id: 0, type: .identifiers, value: "soma", line: 1, column: 1),
        .init(id: 1, type: .relationals, value: ":=", line: 2, column: 9),
        .init(id: 2, type: .identifiers, value: "25", line: 3, column: 14),
        .init(id: 2, type: .terminators, value: ";", line: 4, column: 1)
    ]}

    var relacaoSuccessful: [PToken] {[
        .init(id: 0, type: .relationals, value: "<>", line: 1, column: 1)
    ]}
}

//"""
//program micro03;
//
//var
//    numero : integer;
//
//begin
//    readln(numero);
//    if(numero >= 100) then
//        begin
//        if(numero <= 200) then begin
//        writeln(1);
//    end;
//    else begin
//        writeln(0);
//        end;
//        end;
//        else begin
//        writeln(0);
//    end;
//
//end.
//"""
