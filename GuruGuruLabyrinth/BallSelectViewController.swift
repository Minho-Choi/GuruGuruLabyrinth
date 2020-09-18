//
//  BallSelectViewController.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/09/01.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit
import SceneKit

class BallSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, SCNSceneRendererDelegate {
    
    
    @IBOutlet weak var settingSCNView: SCNView!
    
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.delegate = self
            picker.dataSource = self
            picker.backgroundColor = .black
            picker.setValue(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), forKey: "textColor")
        }
    }
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBAction func enterButtonDidPushed(_ sender: Any) {
        //perform segue
    }
    
    let ballArray: [Ball] = DataSet().ballArray
    let wallArray: [WallTexture] = DataSet().wallArray
    var pickScene: SCNScene!
    lazy var ball = pickScene.rootNode.childNode(withName: "sphere", recursively: true)!
    lazy var wall = pickScene.rootNode.childNode(withName: "plane", recursively: true)!
    var rotationAngle = CGFloat()
    var action = SCNAction()
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneSetup()
    }
    
    // MARK: - Setting Up the Scene
    
    func sceneSetup() {
        pickScene = SCNScene(named: "art.scnassets/Ball.scn")!
        pickScene.isPaused = false
        settingSCNView.delegate = self
        settingSCNView.scene = pickScene
        settingSCNView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        settingSCNView.layer.borderWidth = 3.0
    }
    
    func nodeSetup(dataRow: Int) {
        
        let ballData = ballArray[dataRow]
        let wallData = wallArray[dataRow]
        
        // ball material setting
        if let diffuse = ballData.diffuse,
           let metallic = ballData.metallic,
           let normal = ballData.normal,
           let roughness = ballData.roughness,
           let occlusion = ballData.occlusion,
           let displacement = ballData.displacement,
           let emissive = ballData.emissive,
           let mask = ballData.mask,
           let alpha = ballData.alpha {
            
            ball.geometry?.firstMaterial?.diffuse.contents = UIImage(named: diffuse)
            ball.geometry?.firstMaterial?.metalness.contents = UIImage(named: metallic)
            ball.geometry?.firstMaterial?.normal.contents = UIImage(named: normal)
            ball.geometry?.firstMaterial?.roughness.contents = UIImage(named: roughness)
            ball.geometry?.firstMaterial?.ambientOcclusion.contents = UIImage(named: occlusion)
            ball.geometry?.firstMaterial?.displacement.contents = UIImage(named: displacement)
            ball.geometry?.firstMaterial?.emission.contents = UIImage(named: emissive)
            ball.geometry?.firstMaterial?.multiply.contents = UIImage(named: mask)
            ball.geometry?.firstMaterial?.transparent.contents = UIImage(named: alpha)
        }
        
        if let diffuse = wallData.diffuse,
           let metallic = ballData.metallic,
           let normal = ballData.normal,
           let roughness = ballData.roughness,
           let occlusion = ballData.occlusion,
           let displacement = ballData.displacement,
           let emissive = ballData.emissive,
           let mask = ballData.mask,
           let alpha = ballData.alpha {
            
            wall.geometry?.firstMaterial?.diffuse.contents = UIImage(named: diffuse)
            wall.geometry?.firstMaterial?.metalness.contents = UIImage(named: metallic)
            wall.geometry?.firstMaterial?.normal.contents = UIImage(named: normal)
            wall.geometry?.firstMaterial?.roughness.contents = UIImage(named: roughness)
            wall.geometry?.firstMaterial?.ambientOcclusion.contents = UIImage(named: occlusion)
            wall.geometry?.firstMaterial?.displacement.contents = UIImage(named: displacement)
            wall.geometry?.firstMaterial?.emission.contents = UIImage(named: emissive)
            wall.geometry?.firstMaterial?.multiply.contents = UIImage(named: mask)
            wall.geometry?.firstMaterial?.transparent.contents = UIImage(named: alpha)
        }
           
        
        // ball physics setting
        
//        ball.physicsBody = .dynamic()
//        ball.physicsBody?.mass = ballData.mass
//        ball.physicsBody?.friction = ballData.friction
//        ball.physicsBody?.damping = ballData.damping
//        ball.physicsBody?.angularDamping = ballData.angularDamping
        
        
    }
    
    // MARK: - Picker Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return ballArray.count
        } else {
            return wallArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return ballArray[row].name
        } else {
            return wallArray[row].name
        }
    }
    
    // rotating ball
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            ball.removeAllActions()
            nodeSetup(dataRow: row)
            action = SCNAction.rotate(by: CGFloat.pi, around: SCNVector3(1, 1, 1), duration: 5)
            ball.runAction(action)
        } else {
            
        }
    }
    
    
    // segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameView" {
            let gameViewControlelr = segue.destination as! GameViewController
            gameViewControlelr.gameData = sender as? Level
        }
    }

}
