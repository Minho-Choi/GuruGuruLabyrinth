//
//  LevelSelectCollectionViewCell.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/29.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class LevelSelectCollectionViewCell: UICollectionViewCell {
    
    var mazeSize: Int = 0
    var levelName: String = ""
    var fogDistance: CGFloat = 0.0
    var skyType: String = ""
    
    let font = UIFont(name: "Chalkduster", size: 22)
    
    
    
    @IBOutlet weak var LevelLabel: UILabel! {
        didSet {
            let attributes: [NSAttributedString.Key: Any] = [.font: font, .backgroundColor: UIColor.white]
            LevelLabel.attributedText = NSAttributedString(string: levelName, attributes: attributes)
            LevelLabel.textAlignment = .center
            LevelLabel.layer.cornerRadius = 10.0
            LevelLabel.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            LevelLabel.layer.borderWidth = 3.0
            
        }
    }
    
}
