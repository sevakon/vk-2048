//
//  GameBoard.swift
//  vk-internship-2048
//
//  Copyright © 2019 Vsevolod Konyakhin. All rights reserved.
//

import Foundation


enum Tile {
    case empty
    case tile(Int)
    
    func getValue() -> Int? {
        switch self {
        case let .tile(value):
            return value
        default:
            return nil
        }
    }
}

enum MoveDirection {
    case up
    case left
    case down
    case right
}


struct GameBoard {
    
    var boardArray = [[Tile]]()
    
    public let dimension = 4
    
    init(initialValue: Tile) {
        for _ in 0..<dimension {
            var subArray = [Tile]()
            for _ in 0..<dimension {
                subArray.append(initialValue)
            }
            boardArray.append(subArray)
        }
    }
    
    subscript(row: Int, column: Int) -> Tile {
        get {
            assert(row >= 0 && row < dimension)
            assert(column >= 0 && column < dimension)
            return boardArray[row][column]
        } set {
            assert(row >= 0 && row < dimension)
            assert(column >= 0 && column < dimension)
            boardArray[row][column] = newValue
        }
    }
    
    mutating func setAll(to value: Tile) {
        for i in 0..<dimension {
            for j in 0..<dimension {
                boardArray[i][j] = value
            }
        }
    }
    
}
