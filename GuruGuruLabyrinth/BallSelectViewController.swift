//
//  BallSelectViewController.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/09/01.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit
import SceneKit

class BallSelectViewController: UIViewController, SCNSceneRendererDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var settingSCNView: SCNView!
    
    @IBOutlet weak var ballPicker: UIPickerView! {
        didSet {
            ballPicker.delegate = self
            ballPicker.dataSource = self
            ballPicker.backgroundColor = .black
            ballPicker.setValue(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), forKey: "textColor")
        }
    }
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBAction func enterButtonDidPushed(_ sender: Any) {
        //perform segue
    }
    
    let ballArray: [Ball] = DataSet().ballArray
    //let mapArray: [Map] = DataSet().mapArray
    var pickScene: SCNScene!
    var ball: SCNNode!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneSetup()
    }
    
    // MARK: - Setting Up the Scene
    
    func sceneSetup() {
        pickScene = SCNScene(named: "art.scnassets/Ball.scn")!
        settingSCNView.scene = pickScene
    }
    
    func nodeSetup(dataRow: Int) {
        ball = pickScene.rootNode.childNode(withName: "sphere", recursively: true)
        
        let ballData = ballArray[dataRow]
        
        // ball material setting
        if let diffuse = ballData.diffuse {
            ball.geometry?.firstMaterial?.diffuse.contents = UIImage(named: diffuse)
        }
        if let metallic = ballData.metallic {
            ball.geometry?.firstMaterial?.metalness.contents = UIImage(named: metallic)
        }
        if let normal = ballData.normal {
            ball.geometry?.firstMaterial?.normal.contents = UIImage(named: normal)
        }
        if let roughness = ballData.roughness {
            ball.geometry?.firstMaterial?.roughness.contents = UIImage(named: roughness)
        }
        if let occlusion = ballData.occlusion {
            ball.geometry?.firstMaterial?.ambientOcclusion.contents = UIImage(named: occlusion)
        }
        if let displacement = ballData.displacement {
            ball.geometry?.firstMaterial?.displacement.contents = UIImage(named: displacement)
        }
        if let emissive = ballData.emissive {
            ball.geometry?.firstMaterial?.emission.contents = UIImage(named: emissive)
        }
        if let mask = ballData.mask {
            ball.geometry?.firstMaterial?.multiply.contents = UIImage(named: mask)
        }
        if let alpha = ballData.alpha {
            ball.geometry?.firstMaterial?.transparent.contents = UIImage(named: alpha)
        }
        
        // ball physics setting
        ball.physicsBody = .dynamic()
        ball.physicsBody?.mass = ballData.mass
        ball.physicsBody?.friction = ballData.friction
        ball.physicsBody?.damping = ballData.damping
        ball.physicsBody?.angularDamping = ballData.angularDamping
        
        
    }
    
    // MARK: - Picker Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1//2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 {
            return ballArray.count
//        } else {
//            return
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ballArray[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nodeSetup(dataRow: row)
    }
    
    
    // MARK: - SCNScene Renderer
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }

}
