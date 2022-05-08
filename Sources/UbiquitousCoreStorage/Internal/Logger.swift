//
//  Logger.swift
//  
//  
//  Created by keiji0 on 2022/04/09
//  
//

import Foundation
import os

extension Logger {
    static let main: Logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!, category: "Main")
}
