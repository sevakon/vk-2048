//
//  ViewController.swift
//  vk-internship-2048
//
//  Created by Vsevolod Konyakhin on 22/05/2019.
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
    
    var scoreView: ScoreView?
    var highScoreView: ScoreView?
    var restartGameButton = RestartGameButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = GameModel(delegate: self)
        setupGame()
        restoreDate()
        setupButton()
        setupScoreView()
        setupHighScoreView()
    }
    
    
    @IBAction func swipeGestureLeft(_ sender: UISwipeGestureRecognizer) {
        if model!.performMove(direction: MoveDirection.left) {
            followUp()
        }
    }
    
    @IBAction func swipeGestureRight(_ sender: UISwipeGestureRecognizer) {
        if model!.performMove(direction: MoveDirection.right) {
            followUp()
        }
    }
    
    @IBAction func swipeGestureUp(_ sender: UISwipeGestureRecognizer) {
        if model!.performMove(direction: MoveDirection.up) {
            followUp()
        }
    }
    
    @IBAction func swipeGestureDown(_ sender: UISwipeGestureRecognizer) {
        if model!.performMove(direction: MoveDirection.down) {
            followUp()
        }
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
            let tentativeX = (vcWidth - viewWidth)/2
            return tentativeX >= 0 ? tentativeX : 0
        }
        
        func yPositionToCenterView(_ v: UIView) -> CGFloat {
            let viewHeight = v.bounds.size.height
            let tentativeY = (vcHeight - viewHeight)/2
            return tentativeY >= 0 ? tentativeY : 0
        }
        
        var f = board!.frame
        f.origin.x = xPositionToCenterView(board!)
        f.origin.y = yPositionToCenterView(board!)
        board!.frame = f
        
        view.addSubview(board!)
    
    }
    
    func followUp() {
        let randomVal = Int(arc4random_uniform(10))
        model!.insertTileAtRandomPosition(with: randomVal == 1 ? 4 : 2)
        
        if model!.userHasLost() {
            let alertControllerForLose = UIAlertController(title: "Defeat", message: "You lost 💀", preferredStyle: .alert)
            
            let actionRestart = UIAlertAction(title: "Try again", style: .default) {
                UIAlertAction in
                self.restartGame()
            }
            
            alertControllerForLose.addAction(actionRestart)
            
            self.present(alertControllerForLose, animated: true, completion: nil)
        }
        
        if model!.userHasWon() && !UserDefaults.standard.bool(forKey: "HasWonOnce") {
            UserDefaults.standard.set(true, forKey: "HasWonOnce")
            let alertControllerForWin = UIAlertController(title: "Victory!", message: "You won", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Continue playing", style: .default) {
                UIAlertAction in
            }
            
            alertControllerForWin.addAction(action)
            
            self.present(alertControllerForWin, animated: true, completion: nil)
        }
    }
    
    func restartGame() {
        UserDefaults.standard.set(false, forKey: "HasWonOnce")
        self.model!.reset()
        self.board!.resetTheView()
        self.model!.insertTileAtRandomPosition(with: 2)
        self.model!.insertTileAtRandomPosition(with: 2)
    }
    
    func restoreDate() {
        if UserDefaults.standard.array(forKey: "TilesData") == nil || UserDefaults.standard.array(forKey: "TilesData")!.isEmpty {
            model!.insertTileAtRandomPosition(with: 2)
            model!.insertTileAtRandomPosition(with: 2)
        } else {
            model!.restoreData(from: UserDefaults.standard.array(forKey: "TilesData")  as! [Int])
            model!.restoreScore(from: UserDefaults.standard.integer(forKey: "Score"))
        }
    }
    
    func setTiles(to tiles: [((Int, Int), Int)]) {
        board!.setTiles(to: tiles)
    }
    
    func scoreChanged(to score: Int) {
        if scoreView != nil {
            scoreView!.score = score
        }
        if highScoreView != nil {
            highScoreView!.score = UserDefaults.standard.integer(forKey: "HighScore")
        }
    }
    
    func setupButton() {
        view.addSubview(restartGameButton)
        restartGameButton.translatesAutoresizingMaskIntoConstraints = false
        restartGameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        restartGameButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        restartGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restartGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        addActionToRestartButton()
    }
    
    func setupScoreView() {
        scoreView = ScoreView(width: 280, height: 50, radius: 9.0, substring: "Score")
        view.addSubview(scoreView!)

        scoreView!.translatesAutoresizingMaskIntoConstraints = false
        scoreView!.widthAnchor.constraint(equalToConstant: 280).isActive = true
        scoreView!.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scoreView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
    }
    
    func setupHighScoreView() {
        highScoreView = ScoreView(width: 280, height: 50, radius: 9.0, substring: "High score")
        highScoreView!.score = UserDefaults.standard.integer(forKey: "HighScore")
        view.addSubview(highScoreView!)
        
        highScoreView!.translatesAutoresizingMaskIntoConstraints = false
        highScoreView!.widthAnchor.constraint(equalToConstant: 280).isActive = true
        highScoreView!.heightAnchor.constraint(equalToConstant: 50).isActive = true
        highScoreView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        highScoreView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 105).isActive = true
    }
    
    func addActionToRestartButton() {
        restartGameButton.addTarget(self, action: #selector(restartGameButtonTapped), for: .touchUpInside)
    }
    
    @objc func restartGameButtonTapped() {
        restartGameButton.shake()
        restartGame()
    }
}

