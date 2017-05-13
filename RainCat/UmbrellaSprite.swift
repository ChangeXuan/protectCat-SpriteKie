//
//  UmbrellaSprite.swift
//  RainCat
//
//  Created by 覃子轩 on 2017/5/13.
//  Copyright © 2017年 Thirteen23. All rights reserved.
//

import SpriteKit

public class UmbrellaSprite:SKSpriteNode {
    
    // 目的地(对象移动的终点)
    fileprivate var destination:CGPoint!
    // 移动的缓冲时间比例
    fileprivate let easing:CGFloat = 0.1
    
    public static func newInstance() -> UmbrellaSprite {
        let umbrella = UmbrellaSprite.init(imageNamed: "umbrella")
        
        let path = UIBezierPath()
        // 雨伞的中间是0,0，y向上为正
        path.move(to: CGPoint())
        path.addLine(to: CGPoint.init(x: -umbrella.size.width/2-30, y: 0))
        path.addLine(to: CGPoint.init(x: 0, y: umbrella.size.height/2))
        path.addLine(to: CGPoint.init(x: umbrella.size.width/2+30, y: 0))
        
        // 设置物理碰撞体(多边形初始化,自动封闭贝塞尔曲线)
        umbrella.physicsBody = SKPhysicsBody.init(polygonFrom: path.cgPath)
        // 该物理体是否有重力
        umbrella.physicsBody?.isDynamic = false
        // 该物理体的弹性
        umbrella.physicsBody?.restitution = 0.9
        
        return umbrella
    }
}

// MARK: - 移动(self.position是该类的位置)
extension UmbrellaSprite {
    
    /// 缓冲雨伞的移动
    ///
    /// - parameter destination: 目的点
    public func setDestination(_ destination:CGPoint) {
        self.destination = destination
    }
    
    /// 设置雨伞的位置
    ///
    /// - parameter point: 
    public func updatePosition(_ point:CGPoint) {
        self.position = point
        self.destination = point
    }
    
    /// 更新雨伞位置
    ///
    /// - parameter deltaTime:
    public func upDate(deltaTime:TimeInterval) {
        let distance = sqrt(pow((self.destination.x-self.position.x),2) +
            pow((self.destination.y-self.position.y),2))
        
        if distance > 1 {
            let directionX = self.destination.x-self.position.x
            let directionY = self.destination.y-self.position.y
            
            self.position.x += directionX * self.easing
            self.position.y += directionY * self.easing
        } else {
            self.position = self.destination
        }
    }
    
    
}
