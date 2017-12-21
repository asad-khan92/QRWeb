//
//  ArrayExtension.swift
//  QRWebView
//
//  Created by Asad Khan on 12/19/17.
//  Copyright © 2017 Asad Khan. All rights reserved.
//

import Foundation


extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
