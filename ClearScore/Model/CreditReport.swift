//
//  CreditReport.swift
//  ClearScore
//
//  Created by Osagie Zogie-Odigie on 29/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import Foundation

class CreditReport : Codable {
    let score :Int
    let maxScoreValue :Int
    
    enum CodingKeys: String, CodingKey {
        case score
        case maxScoreValue
    }
}


