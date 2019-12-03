//
//  ClearScoreTests.swift
//  ClearScoreTests
//
//  Created by Osagie Zogie-Odigie on 29/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import XCTest
@testable import ClearScore

class ClearScoreTests: XCTestCase {
    
    var systemUnderTest: ClearScoreViewModel!

    override func setUp() {
        
        super.setUp()
        systemUnderTest = ClearScoreViewModel(withNetworkQueryService: NetworkQueryService())
    }

    override func tearDown() {
        systemUnderTest = nil
        super.tearDown()
    }

    func testEdgeCaseMaxCreditScoreCalculation(){
        let fractionalScore = systemUnderTest.computeFractionalScore(fromScore: 700, andMaximum: 700)
        XCTAssertEqual(fractionalScore!, (2 * .pi), "Failed: Expected computed fractional score to be 2*pi. Function returned \(fractionalScore!)")
    }
    
    func testEdgeCaseMinCreditScoreCalculation(){
        let fractionalScore = systemUnderTest.computeFractionalScore(fromScore: 0, andMaximum: 700)
        XCTAssertEqual(fractionalScore!, 0.0, "Failed: Expected computed fractional score to be 0.0. Function returned \(fractionalScore!)")
    }
    
    func testErrorCaseInvalidInputCalculation(){
        let fractionalScore = systemUnderTest.computeFractionalScore(fromScore: 0, andMaximum: 0)
        XCTAssertTrue((fractionalScore == nil), "Failed: Expected computed fractional score to be nil. Function returned \(fractionalScore!)")
    }
    
    func testNormalCreditScoreCalculation(){
        let fractionalScore = systemUnderTest.computeFractionalScore(fromScore: 350, andMaximum: 700)
        XCTAssertEqual(fractionalScore!, (1 * .pi), "Failed: Expected computed fractional score to be pi. Function returned \(fractionalScore!)")
    }

}
