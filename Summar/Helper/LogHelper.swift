//
//  log.swift
//  Summar
//
//  Created by plsystems on 2023/01/11.
//

import Foundation


internal func log(_ description: String,
           fileName: String = #file,
           lineNumber: Int = #line,
           functionName: String = #function) {

    // swiftlint:disable:next line_length
    let traceString = "\(fileName.components(separatedBy: "/").last!) -> \(functionName) -> \(description) (line: \(lineNumber))"
    print(traceString)
}
