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

    let mazeSize = 4
    
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
        //let floorNode = addFloor()
        let wallNodes = addWalls(wallData: wallData)
        
        //scene.rootNode.addChildNode(floorNode)
        scene.rootNode.addChildNode(ballNode)
        wallNodes.forEach { scene.rootNode.addChildNode($0) }
        
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
    }
    
    func addFloor() -> SCNNode {
        
        let planeGeometry = SCNFloor()
        let floorTexture = planeGeometry.firstMaterial!.diffuse
        floorTexture.contents = UIImage(named: "art.scnassets/FloorTexture.jpg")
        floorTexture.wrapS = .repeat
        floorTexture.wrapT = .repeat
        floorTexture.contentsTransform = SCNMatrix4MakeScale(7, 7, 0)
        planeGeometry.reflectivity = 0
        let floorNode = SCNNode(geometry: planeGeometry)
        
        return floorNode
    }
    
    func addBall() -> SCNNode {
        
        let ballGeometry = SCNSphere(radius: 0.35)
        ballGeometry.firstMaterial!.diffuse.contents = UIImage(named: "art.scnassets/TennisBallColorMap.jpg")
        ballGeometry.firstMaterial!.roughness.contents = UIImage(named: "art.scnassets/TennisBallBump.jpg")
        let ballNode = SCNNode(geometry: ballGeometry)
        ballNode.position = SCNVector3(0, 1, 0)
        
        return ballNode
    }
    
    func addWalls(wallData: [Cell]) -> [SCNNode] {
        
        let wallHeight: Float = 1.0
        let wallGeometry = SCNBox(width: 0.01, height: CGFloat(wallHeight), length: 1.0, chamferRadius: 0.005)
        wallGeometry.firstMaterial!.diffuse.contents = UIColor.gray
        let floorGeometry = SCNPlane(width: 1, height: 1)
        floorGeometry.firstMaterial!.diffuse.contents = UIColor.black
        
        var wallArray = [SCNNode]()
        
        for cell in wallData {
            for coordinate in cell.availableCell {
                
                let floor = SCNNode(geometry: floorGeometry)
                floor.position = SCNVector3(Float(coordinate.x), 0.1, Float(coordinate.y))
                floor.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(CGFloat.pi / 2))
                wallArray.append(floor)
                
                var isWallHorizontal = false // default: 가로 방향 벽
                let wallCenter = SCNVector3(x: Float(cell.position.x + coordinate.x) / 2, y: (wallHeight / 2), z: Float(cell.position.y + coordinate.y) / 2)
                if cell.position.x == coordinate.x { // 위치가 세로로 인접한 셀일 경우
                    isWallHorizontal = true
                }
                
                let wallNode = SCNNode(geometry: wallGeometry)
                wallNode.position = wallCenter
                
                if isWallHorizontal {
                    wallNode.rotation = SCNVector4(0, 1, 0, CGFloat.pi / 2)
                }
                
                wallArray.append(wallNode)
                print("wall is created in \(wallCenter)")

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
