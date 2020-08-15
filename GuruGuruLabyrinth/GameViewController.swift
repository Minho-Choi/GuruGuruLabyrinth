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

    let mazeSize = 24
    
    lazy var mazeForGame = Maze(size: mazeSize)
    
    var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneSetup()
    }
    
    func sceneSetup() {
        
        sceneView = (self.view as! SCNView)
        
        mazeForGame.generateMaze()
        
        let wallData = mazeForGame.maze
        
        let scene = SCNScene(named: "art.scnassets/MainScene.scn")!
        let ballNode = addBall()
        let floorNode = addFloor()
        let wallNodes = addWalls(wallData: wallData)
        
        scene.rootNode.addChildNode(floorNode)
        scene.rootNode.addChildNode(ballNode)
        wallNodes.forEach { scene.rootNode.addChildNode($0) }
        
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
    }
    
    func addFloor() -> SCNNode {
        // Floor texture modification
        let floorGeometry = SCNFloor()
        let floorTexture = floorGeometry.firstMaterial!.diffuse
        floorTexture.contents = UIImage(named: "art.scnassets/FloorTexture.jpg")
        floorTexture.wrapS = .repeat
        floorTexture.wrapT = .repeat
        floorTexture.contentsTransform = SCNMatrix4MakeScale(96, 96, 0)
        floorGeometry.reflectivity = 0
        let floorNode = SCNNode(geometry: floorGeometry)
        
        return floorNode
    }
    
    func addBall() -> SCNNode {
        // Ball texture modification
        let ballGeometry = SCNSphere(radius: 0.35)
        ballGeometry.firstMaterial!.diffuse.contents = UIImage(named: "art.scnassets/TennisBallColorMap.jpg")
        ballGeometry.firstMaterial!.roughness.contents = UIImage(named: "art.scnassets/TennisBallBump.jpg")
        let ballNode = SCNNode(geometry: ballGeometry)
        ballNode.position = SCNVector3(0, 1, 0)
        
        return ballNode
    }
    
    func addWalls(wallData: [Wall]) -> [SCNNode] {
        
        let wallHeight: Float = 1.0
        let wallGeometry = SCNBox(width: 0.1, height: CGFloat(wallHeight), length: 1.0, chamferRadius: 0.005)
        wallGeometry.firstMaterial!.diffuse.contents = UIImage(named: "art.scnassets/WallTexture.jpg")
        wallGeometry.firstMaterial!.diffuse.wrapS = .repeat
        wallGeometry.firstMaterial!.diffuse.wrapT = .repeat
        wallGeometry.firstMaterial!.diffuse.contentsTransform = SCNMatrix4MakeScale(1, 1, 0)
        let floorGeometry = SCNPlane(width: 1, height: 1)
        floorGeometry.firstMaterial!.diffuse.contents = UIColor.black
        
        var wallArray = [SCNNode]()
        
        for wall in wallData {
            
            let wallNode = SCNNode(geometry: wallGeometry)
            wallNode.position = SCNVector3(x: wall.position.0, y: wallHeight/2, z: wall.position.1)
            
            if wall.direction == .horizontal {
                wallNode.rotation = SCNVector4(0, 1, 0, CGFloat.pi / 2)
            }
            if !wall.isOpened {
                wallArray.append(wallNode)
            }

        }
        return wallArray
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
