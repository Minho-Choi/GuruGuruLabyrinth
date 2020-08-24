//
//  ClearView.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/18.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class ClearView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var time = Float()
    var customFrame = CGRect()
    var customRadius = CGFloat()
    
    override func addSubview(_ view: UIView) {
        let clearLabel = UILabel()
        
        let roundedTime = round(time * 10)/10
    
        clearLabel.frame = CGRect(x: customFrame.minX, y: customFrame.minY, width: customFrame.width, height: customFrame.height)
        clearLabel.layer.cornerRadius = customRadius
        clearLabel.numberOfLines = 2
        let attribute: [NSAttributedString.Key : Any] = [.font : UIFont(name: "Chalkduster", size: 36.0) as Any, .foregroundColor : UIColor.white]
        clearLabel.attributedText = NSAttributedString(string: "Maze Clear!\n\(roundedTime) sec", attributes: attribute)
        clearLabel.textAlignment = .center
        clearLabel.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        clearLabel.isOpaque = false
        
        view.addSubview(clearLabel)
    }

}
