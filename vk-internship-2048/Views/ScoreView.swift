//
//  ScoreView.swift
//  vk-internship-2048
//
//  Copyright © 2019 Vsevolod Konyakhin. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    
    var scoreLabel: UILabel
    let scoreSubstring: String
    
    public var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(scoreSubstring): \(score)"
        }
    }
    
    init(width: CGFloat, height: CGFloat, radius: CGFloat, substring: String) {
        scoreSubstring = substring
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        layer.cornerRadius = radius
        setupView()
        setupShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        scoreLabel.textAlignment = NSTextAlignment.center
        scoreLabel.minimumScaleFactor = 0.5
        scoreLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        
        addSubview(scoreLabel)
        
        backgroundColor = .white
        scoreLabel.textColor = .black
        scoreLabel.text = "\(scoreSubstring): \(score)"
    }
    
    func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
