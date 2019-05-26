//
//  AppearanceProvider.swift
//  vk-internship-2048
//
//  Created by Vsevolod Konyakhin on 26/05/2019.
//  Copyright © 2019 Vsevolod Konyakhin. All rights reserved.
//

import UIKit

protocol AppearanceProviderProtocol: class {
    func tileColor(value: Int) -> UIColor
    func numberColor(value: Int) -> UIColor
    func fontForNumbers(value: Int) -> UIFont
}

class AppearanceProvider: AppearanceProviderProtocol {
    func tileColor(value: Int) -> UIColor {
        switch value {
        case 2:
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        case 4:
            return UIColor(red: 225/255, green: 227/255, blue: 230/255, alpha: 1.0)
        case 8:
            return UIColor(red: 153/255, green: 221/255, blue: 255/255, alpha: 1.0)
        case 16:
            return UIColor(red: 92/255, green: 179/255, blue: 255/255, alpha: 1.0)
        case 32:
            return UIColor(red: 28/255, green: 138/255, blue: 235/255, alpha: 1.0)
        case 64:
            return UIColor(red: 0/255, green: 100/255, blue: 214/255, alpha: 1.0)
        case 128:
            return UIColor(red: 0/255, green: 73/255, blue: 184/255, alpha: 1.0)
        case 256:
            return UIColor(red: 27/255, green: 62/255, blue: 133/255, alpha: 1.0)
        case 512:
            return UIColor(red: 11/255, green: 43/255, blue: 133/255, alpha: 1.0)
        case 1024:
            return UIColor(red: 0/255, green: 24/255, blue: 184/255, alpha: 1.0)
        case 2048:
            return UIColor(red: 17/255, green: 5/255, blue: 112/255, alpha: 1.0)
        default:
            return UIColor(red: 184/255, green: 193/255, blue: 204/255, alpha: 1.0)
        }
    }
    
    func numberColor(value: Int) -> UIColor {
        if value <= 32 {
            return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        } else {
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
    }
    
    func fontForNumbers(value: Int) -> UIFont {
        if value < 128 {
            return UIFont(name: "HelveticaNeue-Bold", size: 40) ?? UIFont.systemFont(ofSize: 40)
        } else if value < 1024 {
            return UIFont(name: "HelveticaNeue-Bold", size: 40) ?? UIFont.systemFont(ofSize: 40)
        } else {
            return UIFont(name: "HelveticaNeue-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34)
        }
    }
    
    
}
