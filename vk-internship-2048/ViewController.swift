//
//  ViewController.swift
//  vk-internship-2048
//
//  Created by Владимир Коняхин on 22/05/2019.
//  Copyright © 2019 Vsevolod Konyakhin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameModelProtocol {
    
    var model: GameModel?
    var board: GameBoardView?
    
    let dimension = 4
    var boardWidth: CGFloat?
    let padding: CGFloat = 7.0
    let radius: CGFloat = 10.0
    var width: CGFloat?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = GameModel(delegate: self)
        setupGame()
    }
    
    
    @IBAction func swipeGestureLeft(_ sender: UISwipeGestureRecognizer) {
        model!.performMove(direction: MoveDirection.left)
        followUp()
    }
    
    @IBAction func swipeGestureRight(_ sender: UISwipeGestureRecognizer) {
        model!.performMove(direction: MoveDirection.right)
        followUp()
    }
    
    @IBAction func swipeGestureUp(_ sender: UISwipeGestureRecognizer) {
        model!.performMove(direction: MoveDirection.up)
        followUp()
    }
    
    @IBAction func swipeGestureDown(_ sender: UISwipeGestureRecognizer) {
        model!.performMove(direction: MoveDirection.down)
        followUp()
    }
    
    
    func setupGame() {
        let vcHeight = view.bounds.size.height
        let vcWidth = view.bounds.size.width
        boardWidth = vcWidth - padding * 2
        width = CGFloat(floorf(CFloat(boardWidth! - padding * CGFloat(dimension + 1))))/CGFloat(dimension)
        board = GameBoardView(tileWidth: width!, tilePadding: padding, cornerRadius: radius)
        view.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
        
        func xPositionToCenterView(_ v: UIView) -> CGFloat {
            let viewWidth = v.bounds.size.width
            let tentativeX = 0.5*(vcWidth - viewWidth)
            return tentativeX >= 0 ? tentativeX : 0
        }
        
        func yPositionToCenterView(_ v: UIView) -> CGFloat {
            let viewHeight = v.bounds.size.height
            let tentativeY = 0.5*(vcHeight - viewHeight)
            return tentativeY >= 0 ? tentativeY : 0
        }
        var f = board!.frame
        f.origin.x = xPositionToCenterView(board!)
        f.origin.y = yPositionToCenterView(board!)
        board!.frame = f
        
        view.addSubview(board!)
        
        model!.insertTileAtRandomPosition(with: 2)
        model!.insertTileAtRandomPosition(with: 2)
    }
    
    func followUp() {
        let randomVal = Int(arc4random_uniform(10))
        model!.insertTileAtRandomPosition(with: randomVal == 1 ? 4 : 2)
        
        if model!.userHasLost() {
            let alertView = UIAlertView()
            alertView.title = "Defeat"
            alertView.message = "You lost..."
            alertView.addButton(withTitle: "Cancel")
            alertView.show()
            
            //todo: reset the game
            //possibly add buttons
        }
        
        if model!.userHasWon() {
            let alertView = UIAlertView()
            alertView.title = "Victory!"
            alertView.message = "You won!"
            alertView.addButton(withTitle: "Cancel")
            alertView.show()
            
            //todo: reset the game
            //possibly add buttons
        }
    }
    
    
    func setTiles(to tiles: [((Int, Int), Int)]) {
        board!.setTiles(to: tiles)
    }
    

}

