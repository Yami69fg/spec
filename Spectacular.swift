import UIKit
import AVFAudio
import SpriteKit
import GameplayKit

class Spectacular: SKScene, SKPhysicsContactDelegate {
    
    weak var mainViewGameInfoController: MainViewGameInfoController?
    
    var playerAudio: AVAudioPlayer?

    let screenHeightSizeValue = UIScreen.main.bounds.height
    let screenWidthSizeValue = UIScreen.main.bounds.width

    var dificultLevel = 0
    var activeBallSpriteNode = SKSpriteNode()
    
    var remainingBallCountValue: Int = 5
    var activeTargetIndexValue = 0
    var currentLevelIndexValue = 1
    var currentGameScoreValue = 0
    var targetLevelScore = 0
    var isBallCurrentlyInPlayFlag = false
    
    var targetSpriteNodeReference = SKSpriteNode()

    let gunSpriteNodeReference = SKSpriteNode(imageNamed: "BallsGun")
    let targetImageNameSpriteNode = SKSpriteNode(imageNamed: "BuscketForGame")
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupBackgroundImageNode()
        setupGunSpriteNode()
        setupTargetSpriteNode()
        setupLevelBlocksFunction()
    }
    
    func pauseGameSceneFunction() {
        isPaused = true
        activeBallSpriteNode.isPaused = true
        gunSpriteNodeReference.isPaused = true
    }

    func resumeGameSceneFunction() {
        isPaused = false
        activeBallSpriteNode.isPaused = false
        gunSpriteNodeReference.isPaused = false
    }
    
    private func setupLevelBlocksFunction() {
        if dificultLevel == 1 {
            loadInitialLevelBlocksFunctionFirst()
        } else if dificultLevel == 2 {
            loadInitialLevelBlocksFunctionSecond()
        } else if dificultLevel == 3 {
            loadInitialLevelBlocksFunctionThird()
        }
    }
    
    private func removeExistingLevelBlocksFunction() {
        for child in children {
            if let blockSpriteNode = child as? SKSpriteNode, blockSpriteNode.physicsBody?.categoryBitMask == Category.BlockStructur {
                blockSpriteNode.removeFromParent()
            }
        }
    }
    
    private func loadInitialLevelBlocksFunctionFirst() {
        createBlockAtPosition(position: CGPoint(x: frame.midX + screenWidthSizeValue * 0.3, y: frame.midY + screenHeightSizeValue * 0.02), rotation: 0.725, imageName: "SecondBlocks")
        createBlockAtPosition(position: CGPoint(x: frame.midX - screenWidthSizeValue * 0.3, y: frame.midY + screenHeightSizeValue * 0.02), rotation: 2.425, imageName: "SecondBlocks")
        createBlockAtPosition(position: CGPoint(x: frame.midX , y: frame.midY + screenHeightSizeValue * 0.02), rotation: 1.55, imageName: "FirstBlocks")
    }
    
    private func loadInitialLevelBlocksFunctionSecond() {
        createBlockAtPosition(position: CGPoint(x: frame.midX + screenWidthSizeValue * 0.15, y: frame.midY + screenHeightSizeValue * 0.02), rotation: 2, imageName: "FirstBlocks")
        createBlockAtPosition(position: CGPoint(x: frame.midX - screenWidthSizeValue * 0.15, y: frame.midY + screenHeightSizeValue * 0.02), rotation: 1.15, imageName: "FirstBlocks")
    }
    
    private func loadInitialLevelBlocksFunctionThird() {
        createAndMoveBlockHorizontally(at: CGPoint(x: frame.minX, y: frame.midY + screenHeightSizeValue * 0.1), withRotation: 0, imageName: "FirstBlocks")
        createBlockAtPosition(position: CGPoint(x: frame.midX + screenWidthSizeValue * 0.25, y: frame.midY - screenHeightSizeValue * 0.1), rotation: 0.725, imageName: "SecondBlocks")
        createBlockAtPosition(position: CGPoint(x: frame.midX - screenWidthSizeValue * 0.25, y: frame.midY - screenHeightSizeValue * 0.1), rotation: -0.725, imageName: "SecondBlocks")

    }
    
    private func createRotatingBlockAtPosition(position: CGPoint, rotation: CGFloat, imageName: String) {
        let blockTextureReference = SKTexture(imageNamed: imageName)
        let blockSpriteNodeReference = SKSpriteNode(texture: blockTextureReference, size: CGSize(width: 150, height: 15))
        blockSpriteNodeReference.position = position
        blockSpriteNodeReference.zRotation = rotation
        
        blockSpriteNodeReference.physicsBody = SKPhysicsBody(texture: blockTextureReference, size: blockSpriteNodeReference.size)
        blockSpriteNodeReference.physicsBody?.isDynamic = false
        blockSpriteNodeReference.physicsBody?.restitution = 0.3
        blockSpriteNodeReference.physicsBody?.friction = 0.2
        blockSpriteNodeReference.physicsBody?.affectedByGravity = false
        
        blockSpriteNodeReference.physicsBody?.categoryBitMask = Category.BlockStructur
        blockSpriteNodeReference.physicsBody?.contactTestBitMask = Category.Ball
        blockSpriteNodeReference.physicsBody?.collisionBitMask = Category.Ball
        
        addChild(blockSpriteNodeReference)
    }
    
    private func createBlockAtPosition(position: CGPoint, rotation: CGFloat, imageName: String) {
        let blockTextureReference = SKTexture(imageNamed: imageName)
        let blockSpriteNodeReference = SKSpriteNode(texture: blockTextureReference, size: CGSize(width: 150, height: 15))
        blockSpriteNodeReference.position = position
        blockSpriteNodeReference.zRotation = rotation
        
        blockSpriteNodeReference.physicsBody = SKPhysicsBody(texture: blockTextureReference, size: blockSpriteNodeReference.size)
        blockSpriteNodeReference.physicsBody?.isDynamic = false
        blockSpriteNodeReference.physicsBody?.restitution = 0.1
        blockSpriteNodeReference.physicsBody?.friction = 0.5
        blockSpriteNodeReference.physicsBody?.affectedByGravity = false
        
        blockSpriteNodeReference.physicsBody?.categoryBitMask = Category.BlockStructur
        blockSpriteNodeReference.physicsBody?.contactTestBitMask = Category.Ball
        blockSpriteNodeReference.physicsBody?.collisionBitMask = Category.Ball
        
        addChild(blockSpriteNodeReference)
    }
    
    private func createAndMoveBlockHorizontally(at position: CGPoint, withRotation rotation: CGFloat, imageName: String) {
        let blockTextureReference = SKTexture(imageNamed: imageName)
        let blockSpriteNodeReference = SKSpriteNode(texture: blockTextureReference, size: CGSize(width: 125, height: 20))
        blockSpriteNodeReference.position = position
        blockSpriteNodeReference.zRotation = rotation

        blockSpriteNodeReference.physicsBody = SKPhysicsBody(texture: blockTextureReference, size: blockSpriteNodeReference.size)
        blockSpriteNodeReference.physicsBody?.isDynamic = false
        blockSpriteNodeReference.physicsBody?.restitution = 0.1
        blockSpriteNodeReference.physicsBody?.friction = 0.5
        blockSpriteNodeReference.physicsBody?.affectedByGravity = false

        blockSpriteNodeReference.physicsBody?.categoryBitMask = Category.BlockStructur
        blockSpriteNodeReference.physicsBody?.contactTestBitMask = Category.Ball
        blockSpriteNodeReference.physicsBody?.collisionBitMask = Category.Ball

        addChild(blockSpriteNodeReference)

        let moveToRightEdge = SKAction.moveTo(x: size.width - blockSpriteNodeReference.size.width / 2, duration: 1.5)
        let moveToLeftEdge = SKAction.moveTo(x: blockSpriteNodeReference.size.width / 2, duration: 1.5)
        
        let moveSequence = SKAction.sequence([moveToRightEdge, moveToLeftEdge])
        let repeatMovement = SKAction.repeatForever(moveSequence)

        blockSpriteNodeReference.run(repeatMovement)
    }

    private func setupBackgroundImageNode() {
        let currentBackgroundName = UserDefaults.standard.string(forKey: "CurrentBackground") ?? "BackGroundForAllControllers"
        let backgroundImageSpriteNodeReference = SKSpriteNode(imageNamed: currentBackgroundName)
        backgroundImageSpriteNodeReference.position = CGPoint(x: size.width / 2, y: size.height / 2)
        if currentBackgroundName == "BackGroundForAllControllers"{
            backgroundImageSpriteNodeReference.size = size
        }
        backgroundImageSpriteNodeReference.zPosition = -2
        addChild(backgroundImageSpriteNodeReference)
    }
    
    private func setupGunSpriteNode() {
        gunSpriteNodeReference.anchorPoint = CGPoint(x: 0.5, y: 1)
        gunSpriteNodeReference.position = CGPoint(x: size.width / 2, y: size.height * 0.935)
        gunSpriteNodeReference.zPosition = 1
        gunSpriteNodeReference.size = CGSize(width: screenHeightSizeValue * 0.25, height: screenHeightSizeValue * 0.225)
        addChild(gunSpriteNodeReference)
        animateGunMovementFunction()
    }
    
    func animateGunMovementFunction() {
        if gunSpriteNodeReference.action(forKey: "gunAnimation") == nil {
            let rotateRightAction = SKAction.rotate(toAngle: CGFloat.pi / 4, duration: 2, shortestUnitArc: true)
            let rotateLeftAction = SKAction.rotate(toAngle: -CGFloat.pi / 4, duration: 2, shortestUnitArc: true)
            let continuousRotationAction = SKAction.repeatForever(SKAction.sequence([rotateRightAction, rotateLeftAction]))
            gunSpriteNodeReference.run(continuousRotationAction, withKey: "gunAnimation")
        }
    }
    
    private func setupTargetSpriteNode() {
        targetSpriteNodeReference = SKSpriteNode(imageNamed: "BuscketForGame")
        targetSpriteNodeReference.position = CGPoint(x: size.width / 2, y: size.height / 5)
        
        targetSpriteNodeReference.size.width = targetSpriteNodeReference.size.width / CGFloat(1 + activeTargetIndexValue)
        targetSpriteNodeReference.size.height = targetSpriteNodeReference.size.height / CGFloat(1 + activeTargetIndexValue)
        targetSpriteNodeReference.physicsBody = SKPhysicsBody(rectangleOf: targetSpriteNodeReference.size)
        targetSpriteNodeReference.physicsBody?.isDynamic = false
        targetSpriteNodeReference.physicsBody?.categoryBitMask = Category.Bucket
        targetSpriteNodeReference.physicsBody?.contactTestBitMask = Category.Ball
        targetSpriteNodeReference.physicsBody?.collisionBitMask = Category.Not
        
        addChild(targetSpriteNodeReference)
    }
    
    func restartGameSceneFunction() {
        remainingBallCountValue = 5
        currentGameScoreValue = 0
        activeTargetIndexValue = 0
        isBallCurrentlyInPlayFlag = false

        removeAllChildren()

        mainViewGameInfoController?.updateBallCounterDisplay(newBallCount: remainingBallCountValue)
        mainViewGameInfoController?.updateGlobalScoreDisplay(currentGameScoreValue)

        setupBackgroundImageNode()
        setupGunSpriteNode()
        setupTargetSpriteNode()
        setupLevelBlocksFunction()

        isPaused = false
    }

    
    private func launchBallFromPosition(position: CGPoint, withAngle angle: CGFloat) {
        guard !isBallCurrentlyInPlayFlag else { return }
        
        remainingBallCountValue -= 1

        mainViewGameInfoController?.updateBallCounterDisplay(newBallCount: remainingBallCountValue)
        
        if  UserDefaults.standard.bool(forKey: "isSoundTrue") {
            guard let url = Bundle.main.url(forResource: "gun", withExtension: "wav") else {
                return
            }
            do {
                playerAudio = try AVAudioPlayer(contentsOf: url)
                playerAudio?.play()
            } catch {
            }
        }
        
        gunSpriteNodeReference.isPaused = true
        
        activeBallSpriteNode = SKSpriteNode(imageNamed: "MainMenuBall")
        activeBallSpriteNode.size = CGSize(width: 35, height: 35)
        activeBallSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: 17.5)
        
        activeBallSpriteNode.position = CGPoint(x: position.x + cos(angle - .pi / 2) * 30, y: position.y + sin(angle - .pi / 2) * 30)
        activeBallSpriteNode.physicsBody?.isDynamic = true
        activeBallSpriteNode.physicsBody?.affectedByGravity = true
        activeBallSpriteNode.physicsBody?.categoryBitMask = Category.Ball
        activeBallSpriteNode.physicsBody?.contactTestBitMask = Category.Bucket | Category.BlockStructur
        activeBallSpriteNode.physicsBody?.collisionBitMask = Category.Bucket | Category.BlockStructur
        
        addChild(activeBallSpriteNode)
        
        let impulseDirectionVector = CGVector(dx: cos(angle - .pi / 1.99) * 100, dy: sin(angle - .pi / 1.99) * 100)
        activeBallSpriteNode.physicsBody?.applyImpulse(impulseDirectionVector)
        
        isBallCurrentlyInPlayFlag = true
    }
    

    private func ballInTarget() {
        if  UserDefaults.standard.bool(forKey: "isSoundTrue") {
            guard let url = Bundle.main.url(forResource: "scoreAdd", withExtension: "wav") else {
                return
            }
            do {
                playerAudio = try AVAudioPlayer(contentsOf: url)
                playerAudio?.play()
            } catch {
            }
        }
        activeBallSpriteNode.removeFromParent()
        targetSpriteNodeReference.removeFromParent()
        activeTargetIndexValue += 1
        currentGameScoreValue += 10
        mainViewGameInfoController?.updateGlobalScoreDisplay(currentGameScoreValue)
        mainViewGameInfoController?.saveGlobalScoreToUserDefaults(UserDefaults.standard.integer(forKey: "GlobalScore")+10)
        setupTargetSpriteNode()
        isBallCurrentlyInPlayFlag = false
        gunSpriteNodeReference.isPaused = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeBallSpriteNode.position.y < -self.size.height * 0.1 {
            activeBallSpriteNode.removeFromParent()
            isBallCurrentlyInPlayFlag = false
            gunSpriteNodeReference.isPaused = false
        }
        if remainingBallCountValue == 0 && !isBallCurrentlyInPlayFlag {
            if currentGameScoreValue >= targetLevelScore {
                mainViewGameInfoController?.processGameCompletionAndGameOverScreen(currentGameScoreValue: currentGameScoreValue, endImageViewForOverGame: "YouWinLabelImage")
            } else {
                mainViewGameInfoController?.processGameCompletionAndGameOverScreen(currentGameScoreValue: currentGameScoreValue, endImageViewForOverGame: "TryNowLabelImage")
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == Category.Ball && contact.bodyB.categoryBitMask == Category.Bucket) ||
           (contact.bodyB.categoryBitMask == Category.Ball && contact.bodyA.categoryBitMask == Category.Bucket) {
            ballInTarget()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchReference = touches.first {
            let touchLocationPoint = touchReference.location(in: self)
            _ = nodes(at: touchLocationPoint)
            if remainingBallCountValue < 1 {
                if currentGameScoreValue >= targetLevelScore {
                    mainViewGameInfoController?.processGameCompletionAndGameOverScreen(currentGameScoreValue: currentGameScoreValue, endImageViewForOverGame: "YouWinLabelImage")
                } else {
                    mainViewGameInfoController?.processGameCompletionAndGameOverScreen(currentGameScoreValue: currentGameScoreValue, endImageViewForOverGame: "TryNowLabelImage")
                }
            }  else {
                launchBallFromPosition(position: gunSpriteNodeReference.position, withAngle: gunSpriteNodeReference.zRotation)
            }
        }
    }
    
}

struct Category {
    static let Not: UInt32 = 0
    static let Ball: UInt32 = 0b1
    static let Bucket: UInt32 = 0b01
    static let BlockStructur: UInt32 = 0b11
}
