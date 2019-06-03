//
//  GameModel.swift
//  vk-internship-2048
//
//  Created by Vsevolod Konyakhin on 24/05/2019.
//  Copyright © 2019 Vsevolod Konyakhin. All rights reserved.
//

import Foundation

protocol GameModelProtocol : class {
    func setTiles(to tiles: [((Int, Int), Int)])
}

class GameModel {
    
    var gameboard: GameBoard
    
    unowned let delegate: GameModelProtocol
    
    var score = 0 {
        didSet {

        }
    }
    
    init(delegate: GameModelProtocol) {
        gameboard = GameBoard(initialValue: .empty)
        self.delegate = delegate
    }
    
    func reset() {
        score = 0
        gameboard.setAll(to: .empty)
    }
    
    func saveDataToArray() {
        var data = [Int]()
        for i in 0..<gameboard.dimension {
            for j in 0..<gameboard.dimension {
                if case .empty = gameboard[i, j] {
                    data.append(0)
                }
                if case let .tile(value) = gameboard[i, j] {
                    data.append(value)
                }
            }
        }
        UserDefaults.standard.set(data, forKey: "TilesData")
    }
    
    func restoreData(from data: [Int]) {
        for i in 0..<gameboard.dimension {
            for j in 0..<gameboard.dimension {
                if data[gameboard.dimension * i + j] == 0 {
                    gameboard[i, j] = .empty
                } else {
                    gameboard[i, j] = .tile(data[gameboard.dimension * i + j])
                }
            }
        }
        delegate.setTiles(to: getArrayOfCurrentTiles())
    }

    func insertTile(at index: (Int, Int), with value: Int) {
        let (x, y) = index
        gameboard[x, y] = .tile(value)
        delegate.setTiles(to: getArrayOfCurrentTiles())
        saveDataToArray()
    }
    
    func insertTileAtRandomPosition(with value: Int) {
        let emptyPositions = getEmptyPositions()
        if !emptyPositions.isEmpty {
            let randomIndex = Int(arc4random_uniform(UInt32(emptyPositions.count - 1)))
            let (x, y) = emptyPositions[randomIndex]
            insertTile(at: (x, y), with: value)
        }
    }
    
    func getEmptyPositions() -> [(Int, Int)] {
        var buffer = [(Int, Int)]()
        for i in 0..<gameboard.dimension {
            for j in 0..<gameboard.dimension {
                if case .empty = gameboard[i, j] {
                    buffer.append((i, j))
                }
            }
        }
        return buffer
    }
    
    func userHasWon() -> Bool {
        for i in 0..<gameboard.dimension {
            for j in 0..<gameboard.dimension {
                if case .tile(2048) = gameboard[i, j] {
                    return true
                }
            }
        }
        return false
    }
    
    func userHasLost() -> Bool {
        if !getEmptyPositions().isEmpty {
            return false
        }
        for i in 0..<gameboard.dimension {
            for j in 0..<gameboard.dimension {
                if case let .tile(v) = gameboard[i, j] {
                    if tileBelowHasSameValue(at: (i, j), value: v) ||
                        tileToRightHasSameValue(at: (i, j), value: v) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func tileBelowHasSameValue(at index: (Int, Int), value: Int) -> Bool {
        let (x, y) = index
        if y + 1 >= gameboard.dimension {
            return false
        }
        if case let .tile(v) = gameboard[x, y + 1]   {
            return v == value
        }
        return false
    }
    
    func tileToRightHasSameValue(at index: (Int, Int), value: Int) -> Bool {
        let (x, y) = index
        if x + 1 >= gameboard.dimension {
            return false
        }
        if case let .tile(v) = gameboard[x + 1, y]   {
            return v == value
        }
        return false
    }
    
    func performMove(direction: MoveDirection) -> Bool {
        switch direction {
        case .up:
            let resultForSlide1 = slideUp()
            let resultForCombine = combineUp()
            let resultForSlide2 = slideUp()
            return resultForSlide1 || resultForCombine || resultForSlide2
        case .down:
            let resultForSlide1 = slideDown()
            let resultForCombine = combineDown()
            let resultForSlide2 = slideDown()
            return resultForSlide1 || resultForCombine || resultForSlide2
        case .left:
            let resultForSlide1 = slideLeft()
            let resultForCombine = combineLeft()
            let resultForSlide2 = slideLeft()
            return resultForSlide1 || resultForCombine || resultForSlide2
        case .right:
            let resultForSlide1 = slideRight()
            let resultForCombine = combineRight()
            let resultForSlide2 = slideRight()
            return resultForSlide1 || resultForCombine || resultForSlide2
        }
    }
    
    func slideUp() -> Bool {
        var atLeastOneMove = false
        for j in 0..<gameboard.dimension {
             for _ in 0...gameboard.dimension - 1 {
                for i in 0..<gameboard.dimension - 1 {
                    if case .empty = gameboard[i, j] {
                        if case .tile(_) = gameboard[i + 1, j] {
                            atLeastOneMove = true
                        }
                        gameboard[i, j] = gameboard[i + 1, j]
                        gameboard[i + 1, j] = .empty
                    }
                }
            }
        }
        return atLeastOneMove
    }
    
    func slideDown() -> Bool {
        var atLeastOneMove = false
        for j in 0..<gameboard.dimension {
            for _ in 0...gameboard.dimension - 1{
                for i in stride(from: gameboard.dimension - 1, to: 0, by: -1) {
                    if case .empty = gameboard[i, j] {
                        if case .tile(_) = gameboard[i - 1, j] {
                            atLeastOneMove = true
                        }
                        gameboard[i, j] = gameboard[i - 1, j]
                        gameboard[i - 1, j] = .empty
                    }
                }
            }
        }
        return atLeastOneMove
    }
    
    func slideLeft() -> Bool {
        var atLeastOneMove = false
        for i in 0..<gameboard.dimension {
            for _ in 0...gameboard.dimension - 1 {
                for j in 0..<gameboard.dimension - 1 {
                    if case .empty = gameboard[i, j] {
                        if case .tile(_) = gameboard[i, j + 1] {
                            atLeastOneMove = true
                        }
                        gameboard[i, j] = gameboard[i, j + 1]
                        gameboard[i, j + 1] = .empty
                    }
                }
            }
        }
        return atLeastOneMove
    }
    
    func slideRight() -> Bool {
        var atLeastOneMove = false
        for i in 0..<gameboard.dimension {
            for _ in 0...gameboard.dimension - 1 {
                for j in stride(from: gameboard.dimension - 1, to: 0, by: -1) {
                    if case .empty = gameboard[i, j] {
                        if case .tile(_) = gameboard[i, j - 1] {
                            atLeastOneMove = true
                        }
                        gameboard[i, j] = gameboard[i, j - 1]
                        gameboard[i, j - 1] = .empty
                    }
                }
            }
        }
        return atLeastOneMove
    }
    
    func combineUp() -> Bool {
        var atLeastOneMove = false
        for j in 0..<gameboard.dimension {
            for i in 0..<gameboard.dimension - 1 {
                if gameboard[i + 1, j].getValue() == gameboard[i, j].getValue() && gameboard[i + 1, j].getValue() != nil {
                    score += gameboard[i + 1, j].getValue()!
                    let newValue: Int = 2 * gameboard[i + 1, j].getValue()!
                    gameboard[i, j] = .tile(newValue)
                    gameboard[i + 1, j] = .empty
                    atLeastOneMove = true
                }
            }
        }
        return atLeastOneMove
    }
    
    func combineDown() -> Bool {
        var atLeastOneMove = false
        for j in 0..<gameboard.dimension {
            for i in stride(from: gameboard.dimension - 1, to: 0, by: -1) {
                if gameboard[i - 1, j].getValue() == gameboard[i, j].getValue() && gameboard[i - 1, j].getValue() != nil {
                    score += gameboard[i - 1, j].getValue()!
                    let newValue: Int = 2 * gameboard[i - 1, j].getValue()!
                    gameboard[i, j] = .tile(newValue)
                    gameboard[i - 1, j] = .empty
                    atLeastOneMove = true
                }
            }
        }
        return atLeastOneMove
    }
    
    func combineLeft() -> Bool {
        var atLeastOneMove = false
        for i in 0..<gameboard.dimension {
            for j in 0..<gameboard.dimension - 1 {
                if gameboard[i, j].getValue() == gameboard[i, j + 1].getValue() && gameboard[i, j].getValue() != nil {
                    score += gameboard[i, j].getValue()!
                    let newValue: Int = 2 * gameboard[i, j].getValue()!
                    gameboard[i, j] = .tile(newValue)
                    gameboard[i, j + 1] = .empty
                    atLeastOneMove = true
                }
            }
        }
        return atLeastOneMove
    }
    
    func combineRight() -> Bool {
        var atLeastOneMove = false
        for i in 0..<gameboard.dimension {
            for j in stride(from: gameboard.dimension - 1, to: 0, by: -1) {
                if gameboard[i, j].getValue() == gameboard[i, j - 1].getValue() && gameboard[i, j].getValue() != nil {
                    score += gameboard[i, j].getValue()!
                    let newValue: Int = 2 * gameboard[i, j].getValue()!
                    gameboard[i, j] = .tile(newValue)
                    gameboard[i, j - 1] = .empty
                    atLeastOneMove = true
                }
            }
        }
        return atLeastOneMove
    }
    
    func printCurrentGameBoardToConsole() {
        for i in 0..<gameboard.dimension {
            var line = ""
            for j in 0..<gameboard.dimension {
                if case .empty = gameboard[i, j] {
                    line += "0"
                }
                if case let .tile(v) = gameboard[i, j] {
                    line += String(v)
                }
                line += " "
            }
            print(line)
        }
    }
    
    func getArrayOfCurrentTiles() -> [((Int, Int), Int)] {
        var buffer = [((Int, Int), Int)]()
        for i in 0..<gameboard.dimension {
            for j in 0..<gameboard.dimension {
                if case let .tile(v) = gameboard[i, j] {
                    buffer.append(((i, j), v))
                }
            }
        }
        return buffer
    }
    
}
