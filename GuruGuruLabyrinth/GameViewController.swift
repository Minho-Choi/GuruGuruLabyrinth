//
//  GameViewController.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/13.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit
import SceneKit
import CoreImage

class GameViewController: UIViewController {
    
    private let mazeSize = 4
    
    private lazy var mazeForGame = Maze(size: mazeSize)
    
    private var sceneView: SCNView!
    private var scene: SCNScene!
    private var ballNode: SCNNode!
    private var selfieStickNode: SCNNode!
    private var portalNode: SCNNode!
    private var floorNodes: [SCNNode] = []
    private var wallNodes: [SCNNode] = []
    
    private var motion = MotionHelper()
    private var motionForce = SCNVector3(0, 0, 0)
    
    private var cameraDirection = 0
    
    private var timer: Timer?
    private var timePassed: Float = 0.0
    
    var isCleared = false {
        didSet {
            showClear()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneSetup()
        nodeSetup()
    }
    
    // MARK: - Device Control
    override var shouldAutorotate: Bool {
        return false
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
    // MARK: - Setting Up the Scene
    private func sceneSetup() {
        
        sceneView = (self.view as! SCNView)
        sceneView.delegate = self
        
        mazeForGame.generateMaze()
        
        scene = SCNScene(named: "art.scnassets/MainScene.scn")!
        
        sceneView.scene = scene
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer()
        let swipeRightRecognizer = UISwipeGestureRecognizer()
        let tapTwiceRecognizer = UITapGestureRecognizer()
        let swipeUpRecognizer = UISwipeGestureRecognizer()
        
        tapTwiceRecognizer.numberOfTapsRequired = 2
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right
        swipeUpRecognizer.direction = .up
        
        
        tapTwiceRecognizer.addTarget(self, action: #selector(sceneViewTappedTwice(recognizer:)))
        swipeLeftRecognizer.addTarget(self, action: #selector(sceneViewSwiped(recognizer:)))
        swipeRightRecognizer.addTarget(self, action: #selector(sceneViewSwiped(recognizer:)))
        swipeUpRecognizer.addTarget(self, action: #selector(sceneViewSwipedUp(recognizer: )))
        
        sceneView.addGestureRecognizer(tapTwiceRecognizer)
        sceneView.addGestureRecognizer(swipeLeftRecognizer)
        sceneView.addGestureRecognizer(swipeRightRecognizer)
        sceneView.addGestureRecognizer(swipeUpRecognizer)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        timer?.tolerance = 0.01
        
        //sceneView.allowsCameraControl = true
    }
    
    
    // MARK: - Gesture and Timer Control
    @objc private func sceneViewSwiped(recognizer: UISwipeGestureRecognizer) {
        let direction = recognizer.direction
        
        if direction == .left {
            cameraDirection -= 1
        } else {
            cameraDirection += 1
        }
    }
    
    @objc private func sceneViewTappedTwice(recognizer: UITapGestureRecognizer) {
        cameraDirection += 4
    }
    
    @objc private func sceneViewSwipedUp(recognizer: UISwipeGestureRecognizer) {
        motionForce = SCNVector3(0, 1.4, 0)
    }
    
    @objc private func onTimerFires() {
        timePassed += 0.1
    }
    
    // MARK: - Setting Up the Nodes
    private func nodeSetup() {
        
        let wallData = mazeForGame.maze
        let cellData = mazeForGame.passedCells
        
        ballNode = addBall()
        floorNodes = addFloors(cellData: cellData)
        wallNodes = addWalls(wallData: wallData)
        selfieStickNode = scene.rootNode.childNode(withName: "selfieStick", recursively: true)!
        portalNode = scene.rootNode.childNode(withName: "portal", recursively: true)!
        
        portalNode = movePortal(node: portalNode)
        
        scene.rootNode.addChildNode(ballNode)
        scene.rootNode.addChildNode(portalNode)
        wallNodes.forEach { scene.rootNode.addChildNode($0) }
        floorNodes.forEach { scene.rootNode.addChildNode($0) }
        
    }
    
    private func addFloors(cellData: [Cell]) -> [SCNNode] {
        // Floor texture modification
        let floorGeometry = SCNPlane(width: CGFloat(mazeSize + 1), height: CGFloat(mazeSize + 1))
        let floorTexture = floorGeometry.firstMaterial!.diffuse
        floorTexture.contents = UIImage(named: "art.scnassets/FloorDiffuse.tif")
        //floorTexture.contentsTransform = SCNMatrix4MakeScale(Float(mazeSize), Float(mazeSize), 0)
        floorGeometry.firstMaterial!.normal.contents = UIImage(named: "art.scnassets/FloorNormal.tif")
        //floorGeometry.firstMaterial!.normal.contentsTransform = SCNMatrix4MakeScale(Float(mazeSize), Float(mazeSize), 0)
        floorGeometry.firstMaterial!.ambientOcclusion.contents = UIImage(named: "art.scnassets/FloorOcclusion.tif")
        //floorGeometry.firstMaterial!.ambientOcclusion.contentsTransform = SCNMatrix4MakeScale(Float(mazeSize), Float(mazeSize), 0)
        floorGeometry.firstMaterial!.roughness.contents = UIImage(named: "art.scnassets/FloorRoughness.tif")
        //floorGeometry.firstMaterial!.roughness.contentsTransform = SCNMatrix4MakeScale(Float(mazeSize), Float(mazeSize), 0)
        floorGeometry.firstMaterial!.displacement.contents = UIImage(named: "art.scnassets/FloorHeight.tif")
        //floorGeometry.firstMaterial!.displacement.contentsTransform = SCNMatrix4MakeScale(Float(mazeSize), Float(mazeSize), 0)
        floorGeometry.firstMaterial!.displacement.intensity = 0.1
        
        var floorArray = [SCNNode]()
        
        for cell in cellData {
            var floorNode = SCNNode(geometry: floorGeometry)
            
            // floor physics modification
            floorNode = setStaticPhysics(node: floorNode, shape: floorGeometry, categoryBitMask: 2, collisionBitMask: 1)
            floorNode.rotation = SCNVector4(1, 0, 0, CGFloat.pi/2)
            floorNode.position = SCNVector3(CGFloat(cell.position.x), 0.1, CGFloat(cell.position.y))
            floorArray.append(floorNode)
        }
        return floorArray
    }
    
    private func addBall() -> SCNNode {
        // Ball texture modification
        let ballGeometry = SCNSphere(radius: 0.25)
        ballGeometry.firstMaterial!.diffuse.contents = UIImage(named: "art.scnassets/BallDiffuse.tif")
        ballGeometry.firstMaterial!.metalness.contents = UIImage(named: "art.scnassets/BallMetallic.tif")
        ballGeometry.firstMaterial!.normal.contents = UIImage(named: "art.scnassets/BallNormal.tif")
        ballGeometry.firstMaterial!.roughness.contents = UIImage(named: "art.scnassets/BallRoughness.tif")
        ballGeometry.segmentCount = 36
        var ballNode = SCNNode(geometry: ballGeometry)
        ballNode.position = SCNVector3(0, 1, 0)
        
        ballNode = setDynamicPhysics(node: ballNode, shape: ballGeometry, categoryBitMask: 1, collisionBitMask: 7)
        
        return ballNode
    }
    
    private func addWalls(wallData: [Wall]) -> [SCNNode] {
        // wall texture modification
        let wallHeight: Float = 1.2
        let wallGeometry = SCNBox(width: 0.1, height: CGFloat(wallHeight), length: 1.1, chamferRadius: 0.01)
        wallGeometry.firstMaterial!.diffuse.contents = UIImage(named: "art.scnassets/WallDiffuse.tif")
        wallGeometry.firstMaterial!.diffuse.wrapS = .repeat
        wallGeometry.firstMaterial!.diffuse.wrapT = .repeat
        //wallGeometry.firstMaterial!.diffuse.contentsTransform = SCNMatrix4MakeScale(1, 1, 0)
        wallGeometry.firstMaterial!.normal.contents = UIImage(named: "art.scnassets/WallNormal.tif")
        wallGeometry.firstMaterial!.ambientOcclusion.contents = UIImage(named: "art.scnassets/WallOcclusion.tif")
        wallGeometry.firstMaterial!.roughness.contents = UIImage(named: "art.scnassets/WallRoughness.tif")
        wallGeometry.firstMaterial!.displacement.contents = UIImage(named: "art.scnassets/WallHeight.tif")
        wallGeometry.firstMaterial!.displacement.intensity = 0.01
        
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
    
    // MARK: - Physics
    private func setStaticPhysics(node: SCNNode, shape: SCNGeometry, categoryBitMask: Int, collisionBitMask: Int) -> SCNNode {
        
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
    
    
    private func setDynamicPhysics(node: SCNNode, shape: SCNGeometry, categoryBitMask: Int, collisionBitMask: Int) -> SCNNode {
        
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
    
    
    // MARK: - Game Clear Function
    func showClear() {
        timer?.invalidate()
        timer = nil
        DispatchQueue.main.async {
            let clearLabel = ClearView(frame: self.view.frame)
            clearLabel.time = self.timePassed
            clearLabel.addSubview(self.view)
            self.view.addSubview(clearLabel)
            print("game clear")
        }
    }
    
    // MARK: - Move Portal to End of the Maze
    private func movePortal(node: SCNNode) -> SCNNode {
        
        //let randomXPosition = CGFloat(mazeSize.arc4random)
        //let randomZPosition = CGFloat(mazeSize.arc4random)
        
        //node.position = SCNVector3(randomXPosition, 15.0, randomZPosition)
        node.position = SCNVector3(Float(mazeSize - 1), 15.0, Float(mazeSize - 1))
        return node
    }
    
}

// MARK: - Core Motion and Camera View Control
extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let ball = ballNode.presentation
        let ballPosition = ball.position
        
        let camPoseDamping: Float = 0.3
        let camRotDamping: Float = 0.2
        
        if isCleared {
            
            ballNode.physicsBody?.velocity = SCNVector3(0, 0.2, 0)
            selfieStickNode.rotation = SCNVector4(1, 0, 0, 90)
            selfieStickNode.position = ballPosition
            
        } else {
        
            motion.getAccelerometerData { (x, y, z) in
                self.motionForce = SCNVector3(x: x * -0.03 , y:self.motionForce.y, z: (y + 0.7) * 0.03)
            }
            
            let quarterPI = Float.pi / 4.0
            var targetDirection = SCNVector4(0, 1, 0, 0)
            targetDirection.w = quarterPI * Float(cameraDirection)
            let camDirection = selfieStickNode.rotation
            let rotationAngle = camDirection.w * (1-camRotDamping) + targetDirection.w * camRotDamping
            selfieStickNode.rotation = SCNVector4(0, 1, 0, rotationAngle)
            
            let targetPosition = yRot(vector3: SCNVector3(x: 0, y: 0.5, z: -0.2), vector4: SCNVector4(0, 1, 0, -rotationAngle)) + ballPosition
            // must match with selfieStick initial position in MainScene.scn
            var cameraPosition = selfieStickNode.position
            
            let xComponent = cameraPosition.x * (1 - camPoseDamping) + targetPosition.x * camPoseDamping
            let yComponent = cameraPosition.y * (1 - camPoseDamping) + targetPosition.y * camPoseDamping
            let zComponent = cameraPosition.z * (1 - camPoseDamping) + targetPosition.z * camPoseDamping
            
            cameraPosition = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
            selfieStickNode.position = cameraPosition
            
            ballNode.physicsBody?.velocity += yRot(vector3: motionForce, vector4: SCNVector4(0, 1, 0, -rotationAngle))
            motionForce.y = 0
            
            if Int(round(ballPosition.x)) == mazeSize - 1 && Int(round(ballPosition.z)) == mazeSize - 1 && !isCleared{
                isCleared.toggle()
            }
        }
    }
}
