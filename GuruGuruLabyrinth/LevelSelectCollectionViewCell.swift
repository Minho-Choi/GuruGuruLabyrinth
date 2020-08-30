//
//  LevelSelectCollectionViewCell.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/29.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class LevelSelectCollectionViewCell: UICollectionViewCell {
    
    var levelData: LevelData? {
        didSet {
            let Titlefont = UIFont.systemFont(ofSize: 32)
            let Descfont = UIFont.systemFont(ofSize: 24)
            let titleattributes: [NSAttributedString.Key: Any] = [.font: Titlefont, .strokeColor: UIColor.white, .strokeWidth: 3.0]
            let descattributes: [NSAttributedString.Key: Any] = [.font: Descfont, .foregroundColor: UIColor.lightGray]
            DifficultyLabel.attributedText = NSAttributedString(string: levelData!.levelName, attributes: titleattributes)
            DifficultyLabel.textAlignment = .center
            
            SizeLabel.attributedText = NSAttributedString(string: "Map Size\n\(levelData!.mazeSize) X \(levelData!.mazeSize)", attributes: descattributes)
            SizeLabel.textAlignment = .center
            SizeLabel.numberOfLines = 2
            
            VisionLabel.attributedText = NSAttributedString(string: "Vision\n\(levelData!.fogDistance)", attributes: descattributes)
            VisionLabel.textAlignment = .center
            VisionLabel.numberOfLines = 2
            
            self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.layer.borderWidth = 5.0
            self.layer.cornerRadius = 10.0
            
        }
    }
    
    @IBOutlet weak var DifficultyLabel: UILabel!
        
    @IBOutlet weak var SizeLabel: UILabel!
    
    @IBOutlet weak var VisionLabel: UILabel!
    
    
}
