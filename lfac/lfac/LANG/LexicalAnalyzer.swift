//
//  LexicalAnalyzer.swift
//  lfac
//
//  Created by Luiz Araujo on 12/05/24.
//

import Foundation

protocol LexicalAnalyzeable {

}

// Autômato Finito Determinístico
// Um autômato finito determinístico (AFD) é um modelo para definição de linguagens regulares composto de cinco elementos ⟨Σ, S, s0 , δ, F ⟩, onde:
// Σ é o alfabeto sobre o qual a linguagem é definida; 
// S é um conjunto finito não vazio de estados;
// s0 é o estado inicial, s0 ∈ S;
// δ éafunçãodetransiçãodeestados,δ:S×Σ→S;
// F é o conjunto de estados finais, F ⊆ S.

class LexicalAnalyzer {

    let alphabet: [String]
    let states: [PStateable]
    var initialState: PStateable
    let finalStates: [PStateable]

    internal init(
        alphabet: [String],
        states: [any PStateable],
        initialState: any PStateable,
        finalStates: [any PStateable]//,
    ) {
        self.alphabet = alphabet
        self.states = states
        self.initialState = initialState
        self.finalStates = finalStates
//        self.regex = regex
    }

    func transitionState(S states: [PStateable], Σ alphabet: [String]) throws -> PState {
        // TODO: Fazer depois

        throw Errors.ET
    }

//    func search(_ entrada: String) {
//        guard !terminators.contains(entrada) else {
//            return
//        }
//    }
}
