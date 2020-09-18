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
        levelData?.ballType = ballRow
        levelData?.wallType = wallRow
        performSegue(withIdentifier: "GameView", sender: levelData)
    }
    
    let ballArray: [Ball] = DataSet().ballArray
    let wallArray: [WallTexture] = DataSet().wallArray
    var pickScene: SCNScene!
    lazy var ball = pickScene.rootNode.childNode(withName: "sphere", recursively: true)!
    lazy var wall = pickScene.rootNode.childNode(withName: "plane", recursively: true)!
    var rotationAngle = CGFloat()
    var action = SCNAction()
    
    var ballRow = 0;
    var wallRow = 0;
    
    var levelData: Level?
    
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
    
    func nodeSetup(ballDataRow: Int, wallDataRow: Int) {
        
        let ballData = ballArray[ballDataRow]
        let wallData = wallArray[wallDataRow]
        let ballTexture = ball.geometry?.firstMaterial
        let wallTexture = wall.geometry?.firstMaterial
        // ball material setting
        if let diffuse = ballData.diffuse {
            ballTexture?.diffuse.contents = UIImage(named: diffuse)
        } else { ballTexture?.diffuse.contents = nil }
        if let metallic = ballData.metallic {
            ballTexture?.metalness.contents = UIImage(named: metallic)
        } else { ballTexture?.metalness.contents = nil}
        if let normal = ballData.normal {
            ballTexture?.normal.contents = UIImage(named: normal)
        } else { ballTexture?.normal.contents = nil }
        if let roughness = ballData.roughness {
            ballTexture?.roughness.contents = UIImage(named: roughness)
        } else { ballTexture?.roughness.contents = nil }
        if let occlusion = ballData.occlusion {
            ballTexture?.ambientOcclusion.contents = UIImage(named: occlusion)
        } else { ballTexture?.ambientOcclusion.contents = nil }
        if let displacement = ballData.displacement {
            ballTexture?.displacement.contents = UIImage(named: displacement)
        } else { ballTexture?.displacement.contents = nil }
        if let emissive = ballData.emissive {
            ballTexture?.emission.contents = UIImage(named: emissive)
        } else { ballTexture?.emission.contents = nil }
        if let mask = ballData.mask {
            ballTexture?.multiply.contents = UIImage(named: mask)
        } else { ballTexture?.multiply.contents = nil }
        if let alpha = ballData.alpha {
            ballTexture?.transparent.contents = UIImage(named: alpha)
        } else { ballTexture?.transparent.contents = nil }

        if let diffuse = wallData.diffuse {
            wallTexture?.diffuse.contents = UIImage(named: diffuse)
        } else { wallTexture?.diffuse.contents = nil }
        if let metallic = wallData.metallic {
            wallTexture?.metalness.contents = UIImage(named: metallic)
        } else { wallTexture?.metalness.contents = nil }
        if let normal = wallData.normal {
            wallTexture?.normal.contents = UIImage(named: normal)
        } else { wallTexture?.normal.contents = nil }
        if let roughness = wallData.roughness {
            wallTexture?.roughness.contents = UIImage(named: roughness)
        } else { wallTexture?.roughness.contents = nil }
        if let occlusion = wallData.occlusion {
            wallTexture?.ambientOcclusion.contents = UIImage(named: occlusion)
        } else { wallTexture?.ambientOcclusion.contents = nil }
        if let displacement = wallData.displacement {
            wallTexture?.displacement.contents = UIImage(named: displacement)
        } else { wallTexture?.displacement.contents = nil }
        if let emissive = wallData.emissive {
            wallTexture?.emission.contents = UIImage(named: emissive)
        } else { wallTexture?.emission.contents = nil }
        if let mask = wallData.mask {
            wallTexture?.multiply.contents = UIImage(named: mask)
        } else { wallTexture?.multiply.contents = nil }
        if let alpha = wallData.alpha {
            wallTexture?.transparent.contents = UIImage(named: alpha)
        } else { wallTexture?.transparent.contents = nil }
           
        
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
    
    // selecting texture, rotating ball
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            ballRow = row
            print(ballRow)
            ball.removeAllActions()
            nodeSetup(ballDataRow: ballRow, wallDataRow: wallRow)
            action = SCNAction.rotate(by: CGFloat.pi, around: SCNVector3(1, 1, 1), duration: 5)
            ball.runAction(action)
        } else {
            wallRow = row
            print(wallRow)
            nodeSetup(ballDataRow: ballRow, wallDataRow: wallRow)
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
