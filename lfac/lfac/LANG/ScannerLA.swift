//
//  ScannerLA.swift
//  lfac
//
//  Created by Luiz Araujo on 13/05/24.
//

import Foundation

class FileScanner {

    func writeTo(fileName: FilesName, fileExtension: FilesExtenstion = .pascalSwift, value: String) {
        if let folderURL = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false) {

            let fileURL = folderURL.appendingPathComponent(fileName.rawValue + "." + fileExtension.rawValue)

            guard let outputStream = OutputStream(url: fileURL, append: true) else {
                print("Unable to open file")
                return
            }

            outputStream.open()
            
            let result = outputStream.write(value, maxLength: 0)

            if result < 0 {
                print("🚨 Falha ao salvar o arquivo")
            } else if result < 0 {
                print("⚠️ Salvou em toda a capacidade")
            } else {
                print("✅ Salvou \(result)bytes")
            }

            outputStream.close()
        }
    }

    func readFrom(fileName: FilesName = .code, fileExtension: FilesExtenstion = .pascalSwift) -> String {
        if let fileURL = Bundle.main.url(forResource: fileName.rawValue, withExtension: fileExtension.rawValue) {
            if let dataFile = try? String(contentsOf: fileURL) {
                return dataFile
            }
        }

        return ""
    }
}

extension FileScanner {

    enum FilesName: String {
    case code = "code"
    case tokenList = "token-list"
    }

    enum FilesExtenstion: String {
    case pascalSwift = "pscs"
    }
}
