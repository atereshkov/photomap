//
//  FileManagerService.swift
//  PhotoMap
//
//  Created by yurykasper on 16.06.21.
//

import Foundation

protocol FileManagerServiceType {
    func configureFilePath(for fileName: String) -> URL?
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
}
