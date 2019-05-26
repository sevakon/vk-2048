//
//  GameBoardView.swift
//  vk-internship-2048
//
//  Created by Vsevolod Konyakhin on 26/05/2019.
//  Copyright © 2019 Vsevolod Konyakhin. All rights reserved.
//

import UIKit

class GameBoardView: UIView {
    
    let dimension = 4
    var tileWidth: CGFloat
    var tilePadding: CGFloat
    var cornerRadius: CGFloat
    
    let provider = AppearanceProvider()
    
    init(tileWidth width: CGFloat, tilePadding padding: CGFloat, cornerRadius radius: CGFloat) {
        tileWidth = width
        tilePadding = padding
        cornerRadius = radius
        let totalLength = CGFloat(dimension) * width + CGFloat(dimension + 1) * padding
        super.init(frame: CGRect(x: 0, y: 0, width: totalLength, height: totalLength))
        setupBackground()
    }
    
    func setupBackground() {
        var xPointer = tilePadding
        var yPointer: CGFloat
        for _ in 0..<dimension {
            yPointer = tilePadding
            for _ in 0..<dimension {
                let backgroundTile = UIView(frame: CGRect(x: xPointer, y: yPointer, width: tileWidth, height: tileWidth))
                backgroundTile.layer.cornerRadius = cornerRadius
                backgroundTile.backgroundColor = provider.tileColor(value: 0)
                addSubview(backgroundTile)
                yPointer += tilePadding + tileWidth
            }
            xPointer += tilePadding + tileWidth
        }
    }
    
    func resetTheView() {
        self.subviews.forEach({ $0.removeFromSuperview() })
        setupBackground()
    }
    
    func setTiles(to tiles: [((Int, Int), Int)]) {
        resetTheView()
        for tile in tiles {
            let (x, y) = tile.0
            let value = tile.1
            var xPointer = tilePadding
            var yPointer: CGFloat
            for i in 0..<dimension {
                yPointer = tilePadding
                for j in 0..<dimension {
                    if j == x && i == y {
                        let tile = TileView(position: CGPoint(x: xPointer, y: yPointer), width: tileWidth, value: value, radius: cornerRadius, delegate: provider)
                        addSubview(tile)
                    }
                    yPointer += tilePadding + tileWidth
                }
                xPointer += tilePadding + tileWidth
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not suported")
    }
}
