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
    var scene: SCNScene!
    var ballNode: SCNNode!
    var selfieStickNode: SCNNode!
    var portalNode: SCNNode!
    var floorNode: SCNNode!
    var wallNodes: [SCNNode] = []
    
    var motion = MotionHelper()
    var motionForce = SCNVector3(0, 0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneSetup()
        nodeSetup()
    }
    
    func sceneSetup() {
        
        sceneView = (self.view as! SCNView)
        sceneView.delegate = self
        
        mazeForGame.generateMaze()
        
        scene = SCNScene(named: "art.scnassets/MainScene.scn")!
        
        sceneView.scene = scene
    }
    
    func nodeSetup() {
        
        let wallData = mazeForGame.maze
        
        ballNode = addBall()
        floorNode = addFloor()
        wallNodes = addWalls(wallData: wallData)
        selfieStickNode = scene.rootNode.childNode(withName: "selfieStick", recursively: true)!
        portalNode = scene.rootNode.childNode(withName: "portal", recursively: true)!
        
        portalNode = movePortal(node: portalNode)
        
        scene.rootNode.addChildNode(floorNode)
        scene.rootNode.addChildNode(ballNode)
        scene.rootNode.addChildNode(portalNode)
        wallNodes.forEach { scene.rootNode.addChildNode($0) }
        
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
        var floorNode = SCNNode(geometry: floorGeometry)
        
        // floor physics modification
        floorNode = setStaticPhysics(node: floorNode, shape: floorGeometry, categoryBitMask: 2, collisionBitMask: 1)
        
        return floorNode
    }
    
    func addBall() -> SCNNode {
        // Ball texture modification
        let ballGeometry = SCNSphere(radius: 0.25)
        ballGeometry.firstMaterial!.diffuse.contents = UIImage(named: "art.scnassets/TennisBallColorMap.jpg")
        ballGeometry.firstMaterial!.roughness.contents = UIImage(named: "art.scnassets/TennisBallBump.jpg")
        ballGeometry.segmentCount = 36
        var ballNode = SCNNode(geometry: ballGeometry)
        ballNode.position = SCNVector3(0, 1, 0)
        
        ballNode = setDynamicPhysics(node: ballNode, shape: ballGeometry, categoryBitMask: 1, collisionBitMask: 7)
        
        return ballNode
    }
    
    func addWalls(wallData: [Wall]) -> [SCNNode] {
        // wall texture modification
        let wallHeight: Float = 1.0
        let wallGeometry = SCNBox(width: 0.1, height: CGFloat(wallHeight), length: 1.0, chamferRadius: 0.005)
        wallGeometry.firstMaterial!.diffuse.contents = UIImage(named: "art.scnassets/WallTexture.jpg")
        wallGeometry.firstMaterial!.diffuse.wrapS = .repeat
        wallGeometry.firstMaterial!.diffuse.wrapT = .repeat
        wallGeometry.firstMaterial!.diffuse.contentsTransform = SCNMatrix4MakeScale(1, 1, 0)
        
        var wallArray = [SCNNode]()
        // add wall nodes to array
        for wall in wallData {
            
            var wallNode = SCNNode(geometry: wallGeometry)
            wallNode = setStaticPhysics(node: wallNode, shape: wallGeometry, categoryBitMask: 4, collisionBitMask: 1)
            wallNode.position = SCNVector3(x: wall.position.0, y: wallHeight/2 - 0.1, z: wall.position.1)
            
            if wall.direction == .horizontal {
                wallNode.rotation = SCNVector4(0, 1, 0, CGFloat.pi / 2)
            }
            if !wall.isOpened {
                wallArray.append(wallNode)
            }

        }
        return wallArray
    }
    
    func setStaticPhysics(node: SCNNode, shape: SCNGeometry, categoryBitMask: Int, collisionBitMask: Int) -> SCNNode {
        
        node.physicsBody = .static()
        node.physicsBody!.physicsShape = .init(geometry: shape)
        node.physicsBody!.categoryBitMask = categoryBitMask
        node.physicsBody!.collisionBitMask = collisionBitMask
        node.physicsBody!.friction = 1
        node.physicsBody!.restitution = 0
        node.physicsBody!.rollingFriction = 0
        node.physicsBody!.damping = 0.1
        node.physicsBody!.angularDamping = 0
        node.physicsBody!.charge = 0
        node.physicsBody!.isAffectedByGravity = false
        node.physicsBody!.allowsResting = true
        
        return node
    }
    
    func setDynamicPhysics(node: SCNNode, shape: SCNGeometry, categoryBitMask: Int, collisionBitMask: Int) -> SCNNode {
        
        node.physicsBody = .dynamic()
        node.physicsBody!.physicsShape = .init(geometry: shape)
        node.physicsBody!.categoryBitMask = categoryBitMask
        node.physicsBody!.collisionBitMask = collisionBitMask
        node.physicsBody!.mass = 10
        node.physicsBody!.friction = 0.5
        node.physicsBody!.restitution = 0
        node.physicsBody!.rollingFriction = 0
        node.physicsBody!.damping = 0.1
        node.physicsBody!.angularDamping = 0.1
        node.physicsBody!.charge = 0
        node.physicsBody!.isAffectedByGravity = true
        node.physicsBody!.allowsResting = true
        
        return node
    }
    
    func movePortal(node: SCNNode) -> SCNNode {
        
        let randomXPosition = CGFloat(mazeSize.arc4random)
        let randomZPosition = CGFloat(mazeSize.arc4random)
        
        node.position = SCNVector3(randomXPosition, 15.0, randomZPosition)
        return node
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

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let ball = ballNode.presentation
        let ballPosition = ball.position
        
        let targetPosition = SCNVector3(x: ballPosition.x, y: ballPosition.y + 0.4, z:ballPosition.z) // must match with selfieStick initial position
        var cameraPosition = selfieStickNode.position
        
        let camPoseDamping: Float = 0.3
        let camRotDamping: Float = 0.1
        
        let xComponent = cameraPosition.x * (1 - camPoseDamping) + targetPosition.x * camPoseDamping
        let yComponent = cameraPosition.y * (1 - camPoseDamping) + targetPosition.y * camPoseDamping
        let zComponent = cameraPosition.z * (1 - camPoseDamping) + targetPosition.z * camPoseDamping
        
        cameraPosition = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
        selfieStickNode.position = cameraPosition
        
        
        motion.getAccelerometerData { (x, y, z) in
            self.motionForce = SCNVector3(x: x * -0.06 , y:0, z: (y + 0.7) * 0.06)
        }
        
        let quarterPI = Float.pi / 4.0
        
        var targetDirection = SCNVector4(0, 1, 0, atan2(motionForce.x * 0.1, motionForce.z * 0.1))
        
        if targetDirection.w <= quarterPI && targetDirection.w > -quarterPI {
            targetDirection.w = 0
        } else if targetDirection.w <= quarterPI * 3 && targetDirection.w > quarterPI {
            targetDirection.w = quarterPI * 2
        } else if targetDirection.w <= -quarterPI && targetDirection.w > -quarterPI * 3 {
            targetDirection.w = -quarterPI * 2
        } else {
            if targetDirection.w > 0 {
                targetDirection.w = quarterPI * 4
            } else {
                targetDirection.w = -quarterPI * 4
            }
        }
        
        let camDirection = selfieStickNode.rotation
        
        let rotationAngle = camDirection.w * (1-camRotDamping) + targetDirection.w * camRotDamping
        
        selfieStickNode.rotation = SCNVector4(0, 1, 0, rotationAngle)
        
        ballNode.physicsBody?.velocity += motionForce
    }
}
