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
        sut = SyntacticalAnalyzer(tokens: MockCodes().atribuicaoSuccessful)

        XCTAssertNoThrow(try sut.atribuicao())
    }

    func test_atribuicao_fail() throws {

    }


    // MARK: - EXPRESSOES
    func test_expressaoSimples_successful() throws {
        sut = SyntacticalAnalyzer(tokens: MockCodes().expressaoSimplesSuccessful)

        XCTAssertNoThrow(try sut.expressaoSimples())

    }

    func test_expressaoSimples_fail() throws {

    }


    func test_expressao_successful() throws {
        sut = SyntacticalAnalyzer(tokens: MockCodes().expressaoSimplesSuccessful)

        XCTAssertNoThrow(try sut.expressao())

    }

    func test_expressao_fail() throws {
        sut = SyntacticalAnalyzer(tokens: MockCodes().expressaoSimplesSuccessful)

        XCTAssertNoThrow(try sut.expressaoSimples())

    }


    // MARK: - RELACAO
    func test_relacao_successful() throws {
        sut = SyntacticalAnalyzer(tokens: MockCodes().relacaoSuccessful)

        XCTAssertNoThrow(try sut.relacao())
    }


    func test_relacao_fail() throws {
    }


    // MARK: - FATOR
    func test_fator_successful() throws {
        sut = SyntacticalAnalyzer(tokens: MockCodes().fatorSuccessfulVariavel)
        XCTAssertNoThrow(try sut.fator())

        sut = SyntacticalAnalyzer(tokens: MockCodes().fatorSuccessfulNumero)
        XCTAssertNoThrow(try sut.fator())

        sut = SyntacticalAnalyzer(tokens: MockCodes().fatorSuccessfulNot)
        XCTAssertNoThrow(try sut.fator())

        sut = SyntacticalAnalyzer(tokens: MockCodes().expressaoSimplesSuccessful)
        XCTAssertNoThrow(try sut.fator())

        sut = SyntacticalAnalyzer(tokens: MockCodes().expressaoSuccessful)
        XCTAssertNoThrow(try sut.fator())
    }


    func test_fator_fail() throws {
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

    var expressaoSimplesSuccessful: [PToken] {[
        .init(id: 0, type: .operators, value: "+", line: 1, column: 1),
        .init(id: 1, type: .integers, value: "10", line: 1, column: 2),
        .init(id: 2, type: .keyword, value: "and", line: 1, column: 14),
        .init(id: 3, type: .identifiers, value: "valid", line: 1, column: 1),
        .init(id: 4, type: .keyword, value: "or", line: 1, column: 1),

        .init(id: 0, type: .operators, value: "-", line: 1, column: 1),
        .init(id: 1, type: .integers, value: "10", line: 1, column: 2),
        .init(id: 2, type: .keyword, value: "*", line: 1, column: 14),
        .init(id: 3, type: .identifiers, value: "qtd", line: 1, column: 1),

        .init(id: 4, type: .terminators, value: ";", line: 1, column: 1),
    ]}

    var expressaoSuccessful: [PToken] {[
        .init(id: 0, type: .operators, value: "+", line: 1, column: 1),
        .init(id: 1, type: .integers, value: "10", line: 1, column: 2),
        .init(id: 2, type: .keyword, value: "and", line: 1, column: 14),
        .init(id: 3, type: .identifiers, value: "valid", line: 1, column: 1),
        .init(id: 4, type: .keyword, value: "or", line: 1, column: 1),

        .init(id: 0, type: .operators, value: "-", line: 1, column: 1),
        .init(id: 1, type: .integers, value: "10", line: 1, column: 2),
        .init(id: 2, type: .keyword, value: "*", line: 1, column: 14),
        .init(id: 3, type: .identifiers, value: "qtd", line: 1, column: 1),

        .init(id: 4, type: .relationals, value: "<>", line: 1, column: 22),

        .init(id: 0, type: .operators, value: "+", line: 1, column: 1),
        .init(id: 1, type: .integers, value: "10", line: 1, column: 2),
        .init(id: 2, type: .keyword, value: "and", line: 1, column: 14),
        .init(id: 3, type: .identifiers, value: "valid", line: 1, column: 1),
        .init(id: 4, type: .keyword, value: "or", line: 1, column: 1),

        .init(id: 0, type: .operators, value: "-", line: 1, column: 1),
        .init(id: 1, type: .integers, value: "10", line: 1, column: 2),
        .init(id: 2, type: .keyword, value: "*", line: 1, column: 14),
        .init(id: 3, type: .identifiers, value: "qtd", line: 1, column: 1)
    ]}

    var fatorSuccessfulVariavel: [PToken] {[
        .init(id: 0, type: .identifiers, value: "soma", line: 1, column: 1)
    ]}

    var fatorSuccessfulNumero: [PToken] {[
        .init(id: 0, type: .integers, value: "21", line: 1, column: 1)
    ]}

    var fatorSuccessfulNot: [PToken] {[
        .init(id: 0, type: .keyword, value: "not", line: 1, column: 1),
        .init(id: 1, type: .identifiers, value: "varivael", line: 5, column: 1),
    ]}
}
