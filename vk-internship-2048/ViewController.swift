//
//  ViewController.swift
//  vk-internship-2048
//
//  Created by Владимир Коняхин on 22/05/2019.
//  Copyright © 2019 Vsevolod Konyakhin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var model: GameModel = GameModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func swipeGestureLeft(_ sender: UISwipeGestureRecognizer) {
        model.performMove(direction: MoveDirection.left)
        followUp()
    }
    
    @IBAction func swipeGestureRight(_ sender: UISwipeGestureRecognizer) {
        model.performMove(direction: MoveDirection.right)
        followUp()
    }
    
    @IBAction func swipeGestureUp(_ sender: UISwipeGestureRecognizer) {
        model.performMove(direction: MoveDirection.up)
        followUp()
    }
    
    @IBAction func swipeGestureDown(_ sender: UISwipeGestureRecognizer) {
        model.performMove(direction: MoveDirection.down)
        followUp()
    }
    
    
    func setupGame() {
        model.insertTileAtRandomPosition(with: 2)
        model.insertTileAtRandomPosition(with: 2)
    }
    
    func followUp() {
        let randomVal = Int(arc4random_uniform(10))
        model.insertTileAtRandomPosition(with: randomVal == 1 ? 4 : 2)
        model.printCurrentGameBoardToConsole()
        
        if model.userHasLost() {
            
        }
        
        if model.userHasWon() {
            
        }
    }
    

}

