//
//  Validator.swift
//  Kader
//
//  Created by user165579 on 6/18/20.
//  Copyright © 2020 user165579. All rights reserved.
//

import Foundation


class Validator {


    static func validName(fullName: String ) -> Bool {
        let result = fullName.range(of: "[A-Za-z]+ [A-Za-z]+", options: .regularExpression) != nil
        return result
    }
    
}
