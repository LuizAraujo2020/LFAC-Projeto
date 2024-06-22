//
//  CodePickerView.swift
//  lfac
//
//  Created by Luiz Araujo on 21/06/24.
//

import SwiftUI

struct CodePickerView: View {
    @Binding var code: FileScanner.FilesName

    var body: some View {
        Picker("Selecione um código", selection: $code) {
            ForEach(FileScanner.FilesName.allCases) { option in
                Text(option.name)
                    .tag(option)
                    .id(option)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    CodePickerView(code: .constant(.code1))
}
