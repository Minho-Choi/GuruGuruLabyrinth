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
    
    private var buttonFrame = CGRect()
    private var buttonCR = CGFloat()
    private var buttonStrokeT = CGFloat()
    
    private var popUpFrame = CGRect()
    private var popUpCR = CGFloat()
    
    private var isPauseButtonPushed = false
    
    private lazy var popUpSquare = SKShapeNode(rect: popUpFrame, cornerRadius: popUpCR)
    
    private var timerNode = SKLabelNode(text: "0.0")
    private var timer = Float()
    
    func makeButton() {
        
        let buttonBack = SKShapeNode(rect: buttonFrame, cornerRadius: buttonCR)
        buttonBack.fillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        buttonBack.strokeColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        buttonBack.lineWidth = buttonStrokeT
        buttonBack.fillTexture = SKTexture(image: UIImage(named: "art.scnassets/pause.png")!)
        buttonBack.name = "pause"

        self.addChild(buttonBack)
        
        timerNode.fontSize = 48
        timerNode.color = .white
        timerNode.fontColor = .black
        timerNode.horizontalAlignmentMode = .center
        timerNode.position = CGPoint(x: popUpFrame.minX + popUpFrame.width / 2, y: popUpFrame.maxY + popUpFrame.height / 5)
        let actionWait = SKAction.wait(forDuration: 0.1)
        let actionRun = SKAction.run { [unowned self] in
            self.timer += 0.1
            self.timerNode.text = String(format: "%.1f", self.timer)
        }
        self.addChild(timerNode)
        timerNode.run(SKAction.repeatForever(SKAction.sequence([actionWait, actionRun])))
    }
    
    func stopTimer() {
        timerNode.isPaused = true
    }
    
    func getTime() -> Float {
        return timer
    }
    
    func setSizes(buttonFrame: CGRect, buttonBoundsT: CGFloat, buttonCR: CGFloat, popUpFrame: CGRect, popUpCR: CGFloat) {
        self.buttonFrame = buttonFrame
        self.buttonStrokeT = buttonBoundsT
        self.buttonCR = buttonCR
        self.popUpFrame = popUpFrame
        self.popUpCR = popUpCR
    }
        
    
    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.nodes(at: positionInScene)
        // print(touchedNode)
        if let node = touchedNode.first {
            if node.name! == "pause" &&  !isPauseButtonPushed{
                // do popup, notify scene
                isPauseButtonPushed.toggle()
                popUp()
                NotificationCenter.default.post(name: .gameButton, object: self, userInfo: ["status" : "paused"])
            } else if node.name! == "resume" {
                //  undo popup, notify scene
                removePopUp()
                NotificationCenter.default.post(name: .gameButton, object: self, userInfo: ["status" : "resumed"])
                isPauseButtonPushed.toggle()
            } else if node.name! == "goMain" {
                // go to Main
                NotificationCenter.default.post(name: .gameButton, object: self, userInfo: ["status" : "goMain"])
            }
        }
    }
    
    func popUp() {
        popUpSquare.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        popUpSquare.name = "popUpWindow"
        self.addChild(popUpSquare)
        
        timerNode.isPaused = true
        
        let buttonSize = CGSize(width: popUpFrame.width * 0.7, height: popUpFrame.height * 0.2)
        let resumeButtonOrientation = CGPoint(x: popUpFrame.width * 0.15 + popUpFrame.minX, y: popUpFrame.height * 0.6 + popUpFrame.minY)
        let goToMainButtonOrientation = CGPoint(x: popUpFrame.width * 0.15 + popUpFrame.minX, y: popUpFrame.height * 0.2 + popUpFrame.minY)
        
        let resumeButton = SKShapeNode(rect: CGRect(origin: resumeButtonOrientation, size: buttonSize))
        resumeButton.fillColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        resumeButton.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        resumeButton.lineWidth = buttonStrokeT
        let resumeLabel = SKLabelNode(text: "RESUME")
        resumeLabel.fontSize = 24
        resumeLabel.horizontalAlignmentMode = .left
        resumeLabel.position = CGPoint(x: resumeButtonOrientation.x, y: resumeButtonOrientation.y)
        resumeLabel.name = "resume"
        
        resumeButton.addChild(resumeLabel)
        resumeButton.name = "resume"
        
        let goMainButton = SKShapeNode(rect: CGRect(origin: goToMainButtonOrientation, size: buttonSize))
        goMainButton.fillColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        goMainButton.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        goMainButton.lineWidth = buttonStrokeT
        let goMainLabel = SKLabelNode(text: "Go To Main")
        goMainLabel.fontSize = 24
        goMainLabel.horizontalAlignmentMode = .left
        goMainLabel.position = CGPoint(x: goToMainButtonOrientation.x, y: goToMainButtonOrientation.y)
        goMainLabel.name = "goMain"
        
        goMainButton.addChild(goMainLabel)
        goMainButton.name = "goMain"
        
        
        popUpSquare.addChild(resumeButton)
        popUpSquare.addChild(goMainButton)
    }
    
    func removePopUp() {
        popUpSquare.removeFromParent()
        timerNode.isPaused = false
    }

}
