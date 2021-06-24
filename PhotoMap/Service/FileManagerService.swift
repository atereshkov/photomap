//
//  FileManagerService.swift
//  PhotoMap
//
//  Created by yurykasper on 16.06.21.
//

import Foundation



protocol FileManagerServiceType {
    func configureFilePath(for fileName: String) -> URL?
    func clearCache()
}

final class FileManagerService: FileManagerServiceType {
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func configureFilePath(for fileName: String) -> URL? {
        let fileURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        return fileURL?.appendingPathComponent(fileName)
    }
    
    func clearCache() {
        guard let cacheURL =  fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        do {
            // swiftlint:disable line_length
            let directoryContents = try fileManager.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil, options: [])
            // swiftlint:enable line_length
            for file in directoryContents {
                do {
                    try fileManager.removeItem(at: file)
                } catch let error {
                    debugPrint("Ooops! Something went wrong: \(error.localizedDescription)")
                }
                
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
