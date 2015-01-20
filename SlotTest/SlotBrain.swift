//
//  SlotBrain.swift
//  SlotTest
//
//  Created by Marcus Dunlap on 1/19/15.
//  Copyright (c) 2015 Marcus Dunlap. All rights reserved.
//

import Foundation
import UIKit

class SlotBrain {
    
    //slot = [[slot1, slot2], [slot4, slot5], [slot7, slot8]]
    
    class func unpackSlotIntoSlotRows(slots: [[Slot]]) -> [[Slot]]{
        
        var slotRow:[Slot] = []
        var slotRow2:[Slot] = []
        var slotRow3:[Slot] = []
        
        for slotArray in slots {
            for var index = 0; index < slotArray.count; index++ {
                let slot = slotArray[index]
                if index == 0 {
                    slotRow.append(slot)
                }
                else if index == 1 {
                    slotRow2.append(slot)
                }
                else if index == 2 {
                    slotRow3.append(slot)
                }
                else {
                    println("Error")
                }
            }
        }
        
        var slotInRows:[[Slot]] = [slotRow, slotRow2, slotRow3]
        
        return slotInRows
    }
    
    class func computeWinnings (slots: [[Slot]]) -> Int {
        
        var slotInRows = unpackSlotIntoSlotRows(slots)
        var winnings = 0
        
        var flushWinCount = 0
        var threeOfAKindWinCount = 0
        var straightWinCount = 0
        
        for slotRow in slotInRows {
            if checkFlush(slotRow) == true {
                println("Flush")
                winnings += 1
                flushWinCount += 1
            }
            if checkThreeInARow(slotRow) == true {
                println("Three In A Row")
                winnings += 5
                straightWinCount += 1
            }
            if checkThreeOfAKind(slotRow) == true {
                println("Three Of A Kind")
                winnings += 10
                threeOfAKindWinCount += 1
            }
        }
        if flushWinCount == 3 {
            println("Royal Flush")
            winnings += 15
        }
        if straightWinCount == 3 {
            println("Epic Straight")
            winnings += 1000
        }
        if threeOfAKindWinCount == 3 {
            println("Threes All Around")
            winnings += 50
        }
        return winnings
    }
    
    class func checkFlush (slotRow: [Slot]) -> Bool {
        
            let slot1 = slotRow[0]
            let slot2 = slotRow[1]
            let slot3 = slotRow[2]
        if slot1.isRed == true && slot2.isRed == true && slot3.isRed == true {
            return true
        }
        else if slot1.isRed == false && slot2.isRed == false && slot3.isRed == false {
            return true
        }
        else
        {
            return false
        }
    }
    
    class func checkThreeInARow (slotRow: [Slot]) -> Bool {
        
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if slot1.value == slot2.value - 1 && slot1.value == slot3.value - 2 {
            return true
        }
        else if slot1.value == slot2.value + 1 && slot1.value == slot3.value + 2 {
            return true
        }
        else {
            return false
        }
    }
    
    class func checkThreeOfAKind (slotRow: [Slot]) -> Bool {
        
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if slot1.value == slot2.value && slot1.value == slot3.value {
            return true
        }
        else{
            return false
        }
    }
}