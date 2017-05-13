//
//  GameScene.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    // 记录时间
    fileprivate var lastUpdateTime : TimeInterval = 0
    // 累计时间
    fileprivate var currentRainDropSpawnTime : TimeInterval = 0
    // 雨滴生成时间
    fileprivate var rainDropSpawnRate : TimeInterval = 0.5
    // 食物的外边距
    fileprivate let foodEdgeMargin:CGFloat = 75.0
    
    // 加载一个雨滴纹理到内存
    fileprivate let raindropTexture = SKTexture.init(imageNamed: "rain_drop")
    fileprivate let umbrellaNode = UmbrellaSprite.newInstance()
    fileprivate var catNode:CatSprite!
    fileprivate var foodNode:FoodSprite!
    
    // 背景节点
    fileprivate let backgroundNode:BackgroundNode = BackgroundNode()

    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        self.physicsWorld.contactDelegate = self
        
        self.initBackground()
        
        self.initWorld()
        
        self.initUmbrella()
        
        self.spawnCat()
        
        self.spawnFood()
    }
    
}

// MARK: - 初始化
extension GameScene {
    
    /// 初始化背景
    ///
    /// - returns:
    fileprivate func initBackground() {
        // 把场景的尺寸传给backgroundNode中的setUp
        self.backgroundNode.setUp(size: self.size)
        // 添加子节点到当前场景中
        self.addChild(self.backgroundNode)
    }
    
    /// 初始化场景边界
    ///
    /// - returns:
    fileprivate func initWorld() {
        // 扩大大小，可以用来给元素销毁一个缓冲区
        var worldFrame = self.frame
        worldFrame.origin.x -= 100
        worldFrame.origin.y -= 100
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        self.physicsBody = SKPhysicsBody.init(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
    }
    
    /// 初始化雨伞
    ///
    /// - returns:
    fileprivate func initUmbrella() {
        //self.umbrellaNode.position = CGPoint.init(x: self.frame.midX, y: self.frame.midY)
        self.umbrellaNode.updatePosition(CGPoint.init(x: frame.midX, y: frame.midY))
        self.umbrellaNode.zPosition = CGFloat(UmbrellaZ)
        self.addChild(self.umbrellaNode)
    }
    
}

// MARK: - 功能函数
extension GameScene {
    
    /// 生成雨滴精灵
    fileprivate func spawnRaindrop() {
        // 使用纹理初始化一个雨滴节点
        let raindrop = SKSpriteNode.init(texture: self.raindropTexture)
        // 设置雨滴节点的物理特性
        raindrop.physicsBody = SKPhysicsBody.init(texture: raindropTexture, size: raindrop.size)
        raindrop.physicsBody?.categoryBitMask = RainDropCategory
        raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory
        
        // 设置随机数，范围是0～size.width
        let xPoint:CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: self.size.width)
        let yPoint:CGFloat = self.size.height + raindrop.size.height
        
        // 设置雨滴出现的位置
        raindrop.position = CGPoint.init(x: xPoint, y: yPoint)
        raindrop.zPosition = CGFloat(RainDropZ)
        // 添加子节点到当前场景中
        self.addChild(raindrop)
    }
    
    /// 生成猫咪
    fileprivate func spawnCat() {
        if let currentCat = self.catNode,children.contains(currentCat) {
            self.catNode.removeFromParent()
            self.catNode.removeAllActions()
            self.catNode.physicsBody = nil
        }
        
        self.catNode = CatSprite.newInstance()
        self.catNode.position = CGPoint.init(x: self.umbrellaNode.position.x,
                                             y: self.umbrellaNode.position.y-30)
        self.addChild(self.catNode)
    }
    
    /// 生成食物
    fileprivate func spawnFood() {
        if let currentFood = self.foodNode,children.contains(currentFood) {
            foodNode.removeFromParent()
            foodNode.removeAllActions()
            foodNode.physicsBody = nil
        }
        
        self.foodNode = FoodSprite.newInstance()
        var randomPosition = CGFloat(arc4random())
        // 确保食物生成的位置在foodEdgeMargin--(width-foodEdgeMargin)之间
        randomPosition = randomPosition.truncatingRemainder(dividingBy:
            self.size.width-foodEdgeMargin*2)
        randomPosition += foodEdgeMargin
        
        self.foodNode.position = CGPoint.init(x: randomPosition, y: self.size.height*0.3)
        self.addChild(self.foodNode)
    }
    
    /// 移动雨伞精灵
    ///
    /// - parameter touches: 
    fileprivate func moveUmbrella(_ touches: Set<UITouch>) {
        // 取得当前的点
        let touchPoint = touches.first?.location(in: self)
        // 点有效则进入
        if let point = touchPoint {
            // 设置雨伞节点的终点
            umbrellaNode.setDestination(point)
        }
    }
    
    /// 猫咪碰撞的处理
    ///
    /// - parameter contact:
    fileprivate func handleCatCollision(_ contact:SKPhysicsContact) {
        var otherBody:UInt32
        if contact.bodyA.categoryBitMask == CatCategory {
            otherBody = contact.bodyB.categoryBitMask
            
        } else {
            otherBody = contact.bodyA.categoryBitMask
        }
        
        switch otherBody {
        case RainDropCategory:
            self.catNode.hitByRain()
        case WorldCategory:
            print("cat is out")
            spawnCat()
        default:
            print("something hit the cat")
        }
    }
    
    /// 食物碰撞的处理
    ///
    /// - parameter contact:
    fileprivate func handleFoodHit(_ contact:SKPhysicsContact) {
        var otherBody:SKPhysicsBody
        var foodBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == FoodCategory {
            otherBody = contact.bodyB
            foodBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            foodBody = contact.bodyB
        }
        
        switch otherBody.categoryBitMask {
        case CatCategory:
            print("fed cat")
            //会直接运行【紧跟的后一个】case或default语句
            fallthrough
        case WorldCategory:
            foodBody.node?.removeFromParent()
            foodBody.node?.physicsBody = nil
            spawnFood()
        default:
            print("something else touched the food")
        }
    }
    
}

// MARK: - 协议
extension GameScene:SKPhysicsContactDelegate {
    
    /// 类别碰撞后的回调
    ///
    /// - parameter contact:
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == CatCategory ||
            contact.bodyB.categoryBitMask == CatCategory {
            self.handleCatCollision(contact)
            //return
        }
        
        if contact.bodyA.categoryBitMask == FoodCategory ||
            contact.bodyB.categoryBitMask == FoodCategory {
            self.handleFoodHit(contact)
            //return
        }
        
        if contact.bodyA.categoryBitMask == RainDropCategory {
            // 避免无限碰撞
            // 关闭碰撞
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
            // 关闭类别
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if contact.bodyB.categoryBitMask == RainDropCategory {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        
        
        if contact.bodyA.categoryBitMask == WorldCategory {
            // 把碰撞体从内存中移除
            // 把碰撞体移出父类
            contact.bodyB.node?.removeFromParent()
            // 把碰撞体置空
            contact.bodyB.node?.physicsBody = nil
            // 取消碰撞体的所有活动
            contact.bodyB.node?.removeAllActions()
        } else if contact.bodyB.categoryBitMask == WorldCategory {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
        }
    }
    
}

// MARK: - Override
extension GameScene {
    
    
    /// 手指按下时
    ///
    /// - parameter touches:
    /// - parameter event:
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.moveUmbrella(touches)
    }
    
    /// 手指移动时
    ///
    /// - parameter touches:
    /// - parameter event:
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.moveUmbrella(touches)
    }
    
    /// 屏幕更新时
    ///
    /// - parameter currentTime:
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update the Spawn Timer
        self.currentRainDropSpawnTime += dt
        
        // 当经历的时间大于雨滴生成时间时
        // 把经历的时间重置，并生成雨滴
        if self.currentRainDropSpawnTime > self.rainDropSpawnRate {
            self.currentRainDropSpawnTime = 0
            self.spawnRaindrop()
        }
        
        self.lastUpdateTime = currentTime
        // 根据帧率来更新雨伞节点的位置
        self.umbrellaNode.upDate(deltaTime: dt)
        // 更新小猫咪
        self.catNode.upDate(dt, self.foodNode.position)
    }
    
}
