//
//  BackgroundNode.swift
//  RainCat
//
//  Created by 覃子轩 on 2017/5/13.
//  Copyright © 2017年 Thirteen23. All rights reserved.
//

import SpriteKit

public class BackgroundNode:SKNode {
    
    public func setUp(size:CGSize) {
        // 注意，左下角是(0,0)
        let yPos:CGFloat = size.height*0.1
        let startPoint:CGPoint = CGPoint.init(x: 0, y: yPos)
        let endPoint:CGPoint = CGPoint.init(x: size.width, y: yPos)
        // 设置全局物理实体
        physicsBody = SKPhysicsBody.init(edgeFrom: startPoint, to: endPoint)
        // 设置物理实体的弹性
        physicsBody?.restitution = 0.3
        // 定义该物体为什么类别(UInt32 有32种)
        physicsBody?.categoryBitMask = FloorCategory
        // 碰撞回调测试物体的类别
        physicsBody?.contactTestBitMask = RainDropCategory
        
        self.initSkyAndGround(size)
    }
    
    /// 初始化天空和地面
    ///
    /// - parameter size:
    ///
    /// - returns: 
    private func initSkyAndGround(_ size:CGSize) {
        
        let skyNode = SKShapeNode.init(rect: CGRect.init(origin: CGPoint(), size: size))
        skyNode.fillColor = SKColor.init(red: 0.38, green: 0.60, blue: 0.65, alpha: 1.0)
        skyNode.strokeColor = SKColor.clear
        skyNode.zPosition = CGFloat(SkyNodeZ)
        
        let groudSize = CGSize.init(width: size.width, height: size.height*0.5)
        let groundNode = SKShapeNode.init(rect: CGRect.init(origin: CGPoint(), size: groudSize))
        groundNode.fillColor = SKColor.init(red: 0.99, green: 0.92, blue: 0.55, alpha: 1.0)
        groundNode.strokeColor = SKColor.clear
        groundNode.zPosition = CGFloat(GroundNodeZ)
        
        self.addChild(skyNode)
        self.addChild(groundNode)
        
    }
    
}
