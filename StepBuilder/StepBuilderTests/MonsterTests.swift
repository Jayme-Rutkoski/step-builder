//
//  MonsterTests.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/22/25.
//

import XCTest
import Foundation
@testable import StepBuilder

final class MonsterTests: XCTestCase {

    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        super.tearDown()

    }
    
    func testCommonMonsters() async {
        let result = MonsterHelper.getCommonMonsters()
        let allMonsters = Factory.shared().monsters
        let filteredMonsters = allMonsters.filter({ result.contains($0.id) })
        for monster in filteredMonsters {
            XCTAssertTrue(monster.rarity == 1)
        }
    }
    
    func testUncommonMonsters() async {
        let result = MonsterHelper.getUncommonMonsters()
        let allMonsters = Factory.shared().monsters
        let filteredMonsters = allMonsters.filter({ result.contains($0.id) })
        for monster in filteredMonsters {
            XCTAssertTrue(monster.rarity == 2)
        }
    }
    
    func testRareMonsters() async {
        let result = MonsterHelper.getRareMonsters()
        let allMonsters = Factory.shared().monsters
        let filteredMonsters = allMonsters.filter({ result.contains($0.id) })
        for monster in filteredMonsters {
            XCTAssertTrue(monster.rarity == 3)
        }
    }
    
    func testLegendaryMonsters() async {
        let result = MonsterHelper.getLegendaryMonsters()
        let allMonsters = Factory.shared().monsters
        let filteredMonsters = allMonsters.filter({ result.contains($0.id) })
        for monster in filteredMonsters {
            XCTAssertTrue(monster.rarity == 4)
        }
    }

    func testRandomMonster() async {
        let total: CGFloat = 10000
        let common = MonsterHelper.getCommonMonsters()
        let uncommon = MonsterHelper.getUncommonMonsters()
        let rare = MonsterHelper.getRareMonsters()
        let legendary = MonsterHelper.getLegendaryMonsters()
        
        var foundCommon = [Int]()
        var foundUncommon = [Int]()
        var foundRare = [Int]()
        var foundLegendary = [Int]()
        var noneFound = [Int]()
        
        print("Calculating....")
        for num in 0..<Int(total) {
            if (num == Int(total) / 2) {
                print("Halfway there...")
            } else if (CGFloat(num) == total * 0.9) {
                print("Almost done...")
            }
                
            let mon = MonsterHelper.getMonster()
            if (common.contains(mon)) {
                foundCommon.append(mon)
            } else if (uncommon.contains(mon)) {
                foundUncommon.append(mon)
            } else if (rare.contains(mon)) {
                foundRare.append(mon)
            } else if (legendary.contains(mon)) {
                foundLegendary.append(mon)
            } else {
                noneFound.append(mon)
            }
        }
        
        print("Expected percentages:\n50% Common\n20% Uncommon\n10% Rare\n3% Legendary\n17% None Found\n")
        
        let commonPercentage = (CGFloat(foundCommon.count) / total) * 100
        let uncommonPercentage = (CGFloat(foundUncommon.count) / total) * 100
        let rarePercentage = (CGFloat(foundRare.count) / total) * 100
        let legendaryPercentage = (CGFloat(foundLegendary.count) / total) * 100
        let noneFoundPercentage = (CGFloat(noneFound.count) / total) * 100
        
        print("Actual percentages:\n\(commonPercentage)% Common\n\(uncommonPercentage)% Uncommon\n\(rarePercentage)% Rare\n\(legendaryPercentage)% Legendary\n\(noneFoundPercentage)% None Found\n")
        
        XCTAssertTrue(commonPercentage >= 45 && commonPercentage <= 55, "Common percentage out of range: \(commonPercentage)%")
        XCTAssertTrue(uncommonPercentage >= 15 && uncommonPercentage <= 25, "Uncommon percentage out of range: \(uncommonPercentage)%")
        XCTAssertTrue(rarePercentage >= 5 && rarePercentage <= 15, "Rare percentage out of range: \(rarePercentage)%")
        XCTAssertTrue(legendaryPercentage >= 1 && legendaryPercentage <= 4, "Legendary percentage out of range: \(legendaryPercentage)%")
        XCTAssertTrue(noneFoundPercentage >= 15 && noneFoundPercentage <= 25, "None Found percentage out of range: \(noneFoundPercentage)%")
    }
}
