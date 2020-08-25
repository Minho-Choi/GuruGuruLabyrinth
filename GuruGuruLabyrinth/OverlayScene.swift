//
//  OverlayScene.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/24.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit
import SpriteKit

class OverlayScene: SKScene {
    
    var buttonFrame = CGRect()
    var buttonCR = CGFloat()
    var buttonStrokeT = CGFloat()
    
    func makeButton() {
        
        let buttonBack = SKShapeNode(rect: buttonFrame, cornerRadius: buttonCR)
        buttonBack.fillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        buttonBack.strokeColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        buttonBack.lineWidth = buttonStrokeT
        buttonBack.fillTexture = SKTexture(image: UIImage(named: "art.scnassets/65-01.png")!)

        self.addChild(buttonBack)
        
        
    }
    
}
