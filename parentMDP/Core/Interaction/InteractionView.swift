//
//  InteractionView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/6/5.
//
import UIKit
import SwiftUI
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the view
        if let view = self.view as! SKView? {
            // Create the scene
            let scene = GameScene(size: view.bounds.size)
            
            // Set the scene to fill the bg
            scene.scaleMode = .aspectFill
            
            // Set the bg color
            scene.backgroundColor = UIColor(red: 105/255,
                                            green: 157/255,
                                            blue: 181/255,
                                            alpha: 1.0)
            
            // Present the scene
            view.presentScene(scene)
            
            
            // Set the view options
            view.ignoresSiblingOrder = false
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


class GameScene: SKScene {
    private var duck: SKSpriteNode!

    override func didMove(to view: SKView) {
        // Set up the background
        let background = SKSpriteNode(imageNamed: "background") // Background image
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        addChild(background)
        
        // Set up the duck sprite with a specific size
        let duckTexture = SKTexture(imageNamed: "avatar1")
        duck = SKSpriteNode(texture: duckTexture)
        duck.size = CGSize(width: 100, height: 100) // Adjust the size as needed
        duck.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(duck)
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        let skLocation = convertPoint(fromView: location)
        
        if duck.contains(skLocation) {
            requestAIResponse()
        } else {
            moveDuck(to: skLocation)
        }
    }

    func moveDuck(to position: CGPoint) {
        let moveAction = SKAction.move(to: position, duration: 1.0)
        duck.run(moveAction)
    }

    func requestAIResponse() {
        NetworkManager.shared.fetchAIResponse(prompt: "Hello!") { response in
            guard let response = response else { return }
            DispatchQueue.main.async {
                self.showAIResponse(response)
            }
        }
    }

    func showAIResponse(_ response: String) {
        // Create the background node
        let backgroundNode = SKSpriteNode(color: .white, size: CGSize(width: 250, height: 100))
        backgroundNode.position = CGPoint(x: duck.position.x, y: duck.position.y + 110)
        backgroundNode.zPosition = 1
        backgroundNode.alpha = 0.8  // Slight transparency for better visual

        // Create the label node
        let label = SKLabelNode(text: response)
        label.fontSize = 18
        label.fontColor = .black
        label.fontName = "Helvetica-Bold"
        label.numberOfLines = 0  // Allow multiple lines
        label.preferredMaxLayoutWidth = 230  // Max width of the label to fit within the background
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center

        // Add the label to the background node
        backgroundNode.addChild(label)

        // Add the background node to the scene
        addChild(backgroundNode)
        
        // Center the label within the background node
        label.position = CGPoint(x: 0, y: 0)

        // Adjust the background size based on the text content
        let padding: CGFloat = 20
        let maxWidth = frame.width - padding * 2
        let maxHeight = frame.height - padding * 2
        let textSize = label.frame.size
        let backgroundWidth = min(maxWidth, textSize.width + padding)
        let backgroundHeight = min(maxHeight, textSize.height + padding)
        backgroundNode.size = CGSize(width: backgroundWidth, height: backgroundHeight)

        // Ensure the background node is within the screen bounds
        backgroundNode.position.x = min(max(backgroundNode.size.width / 2 + padding, backgroundNode.position.x), frame.width - backgroundNode.size.width / 2 - padding)
        backgroundNode.position.y = min(max(backgroundNode.size.height / 2 + padding, backgroundNode.position.y), frame.height - backgroundNode.size.height / 2 - padding)

        // Remove label after some time
        let wait = SKAction.wait(forDuration: 3)
        let remove = SKAction.removeFromParent()
        backgroundNode.run(SKAction.sequence([wait, remove]))
    }

}

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(false)
    }
}

