//
//  GameViewController.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/13.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {

    let mazeSize = 25
    
    lazy var maze = Maze(size: mazeSize)
    
    var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneSetup()
    }
    
    func sceneSetup() {
        
        sceneView = (self.view as! SCNView)
        
        let scene = SCNScene()
        let mazeSizeCGFloat = CGFloat(mazeSize)
        
        let planeGeometry = SCNPlane(width: mazeSizeCGFloat, height: mazeSizeCGFloat)
        let floorNode = SCNNode(geometry: planeGeometry)
        
        scene.rootNode.addChildNode(floorNode)
        
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
}
