//
//  AnalysisTypePicker.swift
//  lfac
//
//  Created by Luiz Araujo on 22/06/24.
//

import SwiftUI

struct AnalysisTypePicker: View {
    @Binding var type: AnalysisTypes
    var hasError = [HasError]()

    var body: some View {
        Picker("What is your favorite color?", selection: $type) {
            ForEach(AnalysisTypes.allCases) { item in
                Text(item.name).tag(item)
            }
        }
        .pickerStyle(.segmented)
    }

    struct HasError {
        var type: AnalysisTypes
        var count: Int
    }
}

#Preview {
    AnalysisTypePicker(type: .constant(.lexical))
}
