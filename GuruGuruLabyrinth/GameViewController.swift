//
//  GameViewController.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/13.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    
    var gameData: Level? {
        didSet {
            if let gamedataz = gameData {
                self.mazeSize = gamedataz.mazeSize
                self.skyType = gamedataz.skyType
                self.fogDistance = gamedataz.fogDistance
                self.ballData = DataSet().ballArray[gamedataz.ballType]
                self.wallTexData = DataSet().wallArray[gamedataz.wallType]
            }
        }
    }
    
    private var mazeSize = 0
    private var skyType = ""
    private var fogDistance: CGFloat = 0.0
    
    private lazy var mazeForGame = Maze(size: mazeSize)
    
    internal var sceneView: SCNView!
    private var scene: SCNScene!
    
    private var ballData: Ball?
    private var wallTexData: WallTexture?
    
    private var ballNode: SCNNode!
    private var selfieStickNode: SCNNode!
    private var portalNode: SCNNode!
    private var floorNodes: [SCNNode] = []
    private var wallNodes: [SCNNode] = []
    
    private var motion = MotionHelper()
    private var motionForce = SCNVector3(0, 0, 0)
    
    private var cameraDirection = 0
    private var spriteScene = OverlayScene()
    
    var timePassed: Float = 0.0
    
    var isCleared = false {
        didSet {
            showClear()
        }
    }
    var isDead = false {
        didSet {
            showGameOver()
        }
    }
    
    private var loadingView = LoadingView()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadingFinished(_:)), name: .loadingEnded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameStatus(_:)), name: .gameButton, object: nil)
        NotificationCenter.default.post(name: .loadingEnded, object: self, userInfo: ["percentage" : "0.2", "status" : "Initializing..."])
        showLoadingBar()
        sceneSetup()
        overlaySetup(size: view.frame.size)
        nodeSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .loadingEnded, object: self, userInfo: ["percentage" : "1.0", "status" : "Generating Maze..."])
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.remove()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        overlaySetup(size: size)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.removeFromParent()
    }
    
    // MARK: - Device Control

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }
    // MARK: - Setting Up the Scene
    private func sceneSetup() {
        
        sceneView = (self.view as! SCNView)
        sceneView.delegate = self
        NotificationCenter.default.post(name: .loadingEnded, object: self, userInfo: ["percentage" : "0.6", "status" : "Calculating..."])
        mazeForGame.generateMaze()
        
        scene = SCNScene(named: "art.scnassets/MainScene.scn")!
        scene.fogEndDistance = fogDistance
        scene.fogStartDistance = 0.0
        scene.background.contents = UIImage(named: skyType)
        scene.lightingEnvironment.contents = UIImage(named: skyType)
        
        sceneView.scene = scene
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer()
        let swipeRightRecognizer = UISwipeGestureRecognizer()
        let tapTwiceRecognizer = UITapGestureRecognizer()
        let swipeUpRecognizer = UISwipeGestureRecognizer()
        let gameEndTapGestureRecognizer = UITapGestureRecognizer()
        
        tapTwiceRecognizer.numberOfTapsRequired = 2
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right
        swipeUpRecognizer.direction = .up
        
        tapTwiceRecognizer.addTarget(self, action: #selector(sceneViewTappedTwice(recognizer:)))
        swipeLeftRecognizer.addTarget(self, action: #selector(sceneViewSwiped(recognizer:)))
        swipeRightRecognizer.addTarget(self, action: #selector(sceneViewSwiped(recognizer:)))
        swipeUpRecognizer.addTarget(self, action: #selector(sceneViewSwipedUp(recognizer: )))
        gameEndTapGestureRecognizer.addTarget(self, action: #selector(clearTapped(recognizer:)))
        
        sceneView.addGestureRecognizer(tapTwiceRecognizer)
        sceneView.addGestureRecognizer(swipeLeftRecognizer)
        sceneView.addGestureRecognizer(swipeRightRecognizer)
        sceneView.addGestureRecognizer(swipeUpRecognizer)
        sceneView.addGestureRecognizer(gameEndTapGestureRecognizer)
    }
    
    private func overlaySetup(size: CGSize) {
        
        spriteScene.size = size
        spriteScene.anchorPoint = CGPoint(x: 0, y: 0)
        spriteScene.setSizes(
            buttonFrame: CGRect(x: buttonPosition.x, y: buttonPosition.y, width: buttonLength, height: buttonLength),
            buttonBoundsT: buttonStrokeThickness,
            buttonCR: buttonRadius,
            popUpFrame: CGRect(x: popUpPosition.x, y: popUpPosition.y, width: popUpWidth, height: popUpHeight),
            popUpCR: popUpRadius)

        spriteScene.makeButton()
        sceneView.overlaySKScene = spriteScene
        
    }
    
    // MARK: - Gesture and Timer Control
    
    // swipe left, right for moving the point of view
    @objc private func sceneViewSwiped(recognizer: UISwipeGestureRecognizer) {
        let direction = recognizer.direction
        
        if direction == .left {
            cameraDirection -= 1
        } else {
            cameraDirection += 1
        }
    }
    
    // tap twice for watching back
    @objc private func sceneViewTappedTwice(recognizer: UITapGestureRecognizer) {
        cameraDirection += 4
    }
    
    // swipe up for jump
    @objc private func sceneViewSwipedUp(recognizer: UISwipeGestureRecognizer) {
        motionForce = SCNVector3(0, 1.4, 0)
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
        //let floorGeometry = SCNPlane(width: CGFloat(mazeSize + 1), height: CGFloat(mazeSize + 1))
        let floorGeometry = scene.rootNode.childNode(withName: "floor", recursively: true)!.geometry!
        
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
        let ballTexture = ballGeometry.firstMaterial!
        if let diffuse = ballData?.diffuse {
            ballTexture.diffuse.contents = UIImage(named: diffuse)
        } else { ballTexture.diffuse.contents = nil }
        if let metallic = ballData?.metallic {
            ballTexture.metalness.contents = UIImage(named: metallic)
        } else { ballTexture.metalness.contents = nil}
        if let normal = ballData?.normal {
            ballTexture.normal.contents = UIImage(named: normal)
        } else { ballTexture.normal.contents = nil }
        if let roughness = ballData?.roughness {
            ballTexture.roughness.contents = UIImage(named: roughness)
        } else { ballTexture.roughness.contents = nil }
        if let occlusion = ballData?.occlusion {
            ballTexture.ambientOcclusion.contents = UIImage(named: occlusion)
        } else { ballTexture.ambientOcclusion.contents = nil }
        if let displacement = ballData?.displacement {
            ballTexture.displacement.contents = UIImage(named: displacement)
        } else { ballTexture.displacement.contents = nil }
        if let emissive = ballData?.emissive {
            ballTexture.emission.contents = UIImage(named: emissive)
        } else { ballTexture.emission.contents = nil }
        if let mask = ballData?.mask {
            ballTexture.multiply.contents = UIImage(named: mask)
        } else { ballTexture.multiply.contents = nil }
        if let alpha = ballData?.alpha {
            ballTexture.transparent.contents = UIImage(named: alpha)
        } else { ballTexture.transparent.contents = nil }
        
        ballTexture.displacement.intensity = 0.01
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
        let wallTexture = wallGeometry.firstMaterial!
        if let diffuse = wallTexData?.diffuse {
            wallTexture.diffuse.contents = UIImage(named: diffuse)
        } else { wallTexture.diffuse.contents = nil }
        if let metallic = wallTexData?.metallic {
            wallTexture.metalness.contents = UIImage(named: metallic)
        } else { wallTexture.metalness.contents = nil }
        if let normal = wallTexData?.normal {
            wallTexture.normal.contents = UIImage(named: normal)
        } else { wallTexture.normal.contents = nil }
        if let roughness = wallTexData?.roughness {
            wallTexture.roughness.contents = UIImage(named: roughness)
        } else { wallTexture.roughness.contents = nil }
        if let occlusion = wallTexData?.occlusion {
            wallTexture.ambientOcclusion.contents = UIImage(named: occlusion)
        } else { wallTexture.ambientOcclusion.contents = nil }
        if let displacement = wallTexData?.displacement {
            wallTexture.displacement.contents = UIImage(named: displacement)
        } else { wallTexture.displacement.contents = nil }
        if let emissive = wallTexData?.emissive {
            wallTexture.emission.contents = UIImage(named: emissive)
        } else { wallTexture.emission.contents = nil }
        if let mask = wallTexData?.mask {
            wallTexture.multiply.contents = UIImage(named: mask)
        } else { wallTexture.multiply.contents = nil }
        if let alpha = wallTexData?.alpha {
            wallTexture.transparent.contents = UIImage(named: alpha)
        } else { wallTexture.transparent.contents = nil }
        wallTexture.diffuse.wrapS = .repeat
        wallTexture.diffuse.wrapT = .repeat
        wallTexture.displacement.intensity = 0.01
        
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
        spriteScene.stopTimer()
        DispatchQueue.main.async { [unowned self] in
            let clearLabel = ClearView(frame: self.sceneView.frame)
            clearLabel.time = self.spriteScene.getTime()
            clearLabel.customFrame = CGRect(x: self.popUpPosition.x, y: self.popUpPosition.y, width: self.popUpWidth, height: self.popUpHeight)
            clearLabel.customRadius = self.popUpRadius
            clearLabel.addSubview(self.view)
            self.view.addSubview(clearLabel)
            print("game clear")
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) { [weak self] in
            self?.sceneView.scene?.isPaused = true
        }
    }
    
    func showGameOver() {
        spriteScene.stopTimer()
        DispatchQueue.main.async { [weak self] in
            self?.sceneView.scene?.isPaused = true
        }
    }
    
    // MARK: - Move Portal to End of the Maze
    private func movePortal(node: SCNNode) -> SCNNode {
        
        //let randomXPosition = CGFloat(mazeSize.arc4random)
        //let randomZPosition = CGFloat(mazeSize.arc4random)
        
        //node.position = SCNVector3(randomXPosition, 15.0, randomZPosition)
        node.position = SCNVector3(Float(mazeSize - 1), 15.0, Float(mazeSize - 1))
        //node.position = SCNVector3(0, 15.0, 0)
        return node
    }
    
    // MARK: - Go to main when touched
    @objc private func clearTapped(recognizer: UITapGestureRecognizer) {
        if isCleared {
            goToMain()
        }
    }
    
    func goToMain() {
        spriteScene.removePopUp()
        sceneView = nil
        performSegue(withIdentifier: "UnwindGame", sender: self)
        print("dismissed")
    }
    
    
    // MARK: - Loading Bar Appearance
    @objc func loadingFinished (_ notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            loadingView.setLoadingStatus(description: data["status"]!, percent: data["percentage"]!)
        }
    }
    
    func showLoadingBar() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.addSubview((self?.view)!)
        }
    }
    
    
    // MARK: - Pop Up Screen
    
    @objc func gameStatus(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            if data["status"] == "paused" {
                sceneView.scene?.isPaused = true
            } else if data["status"] == "resumed" {
                sceneView.scene?.isPaused = false
            } else if data["status"] == "goMain" {
                goToMain()
            }
        }
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
            selfieStickNode.position = ballPosition - SCNVector3(CGFloat((mazeSize - 1) / 2), -1, CGFloat((mazeSize - 1) / 2))
            
        } else {
            
            /// Memory Cycle  발생한 부분 (weak self 선언하여 해결)
            motion.getAccelerometerData { [weak self] (x, y, z) in
                if let yComponent = self?.motionForce.y {
                    self?.motionForce = SCNVector3(x: x * -0.03, y:yComponent, z: (y + 0.7) * 0.03)
                }
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
            
            // Game Clear 조건
            if Int(round(ballPosition.x)) == Int(portalNode.position.x) && Int(round(ballPosition.z)) == Int(portalNode.position.z) && !isCleared{
                isCleared.toggle()
            }
            if ballPosition.z < -5 {
                isDead.toggle()
            }
        }
    }
}

extension Notification.Name {
    static let loadingEnded = Notification.Name("loadingEnded")
    static let gameButton = Notification.Name("gameButton")
}
