//
//  CatSprite.swift
//  RainCat
//
//  Created by 覃子轩 on 2017/5/13.
//  Copyright © 2017年 Thirteen23. All rights reserved.
//

import SpriteKit

public class CatSprite:SKSpriteNode {
    
    // 小猫移动速度
    fileprivate let moveSpeed:CGFloat = 100
    // 被打击后遗症出现的累计时间
    fileprivate var timeSinceHit:TimeInterval = 2
    // 被打击后遗症出现的最大时间
    fileprivate let maxFlailTime:TimeInterval = 2
    // 当前被打击的次数
    fileprivate var currentRainHits = 2
    // 最大被打击不出音效的的次数
    fileprivate let maxRainHits = 2
    fileprivate let walkActionKey = "action_walking"
    fileprivate let walkFrames = [
        SKTexture.init(imageNamed: "cat_one"),
        SKTexture.init(imageNamed: "cat_two")
    ]
    fileprivate let meowSFX = [
        "cat_meow_1.mp3",
        "cat_meow_2.mp3",
        "cat_meow_3.mp3",
        "cat_meow_4.mp3",
        "cat_meow_5.wav",
        "cat_meow_6.wav",
    ]
    
    /// 返回小猫咪
    ///
    /// - returns:
    public static func newInstance() -> CatSprite {
        let catSprite = CatSprite.init(imageNamed: "cat_one")
        catSprite.zPosition = CGFloat(CatSpriteZ)
        catSprite.physicsBody = SKPhysicsBody.init(circleOfRadius: catSprite.size.width/2)
        catSprite.physicsBody?.categoryBitMask = CatCategory
        catSprite.physicsBody?.contactTestBitMask = RainDropCategory | WorldCategory
        
        return catSprite
    }
    
}

// MARK: - 移动(self.position是该类的位置)
extension CatSprite {
    
    /// 小猫咪的更新函数
    ///
    /// - parameter deltaTime:
    /// - parameter foodLocation:
    public func upDate(_ deltaTime:TimeInterval,_ foodLocation:CGPoint) {
        
        self.timeSinceHit += deltaTime
        
        // 判断小猫咪是否在被击打后遗症的过程中
        if self.timeSinceHit >= self.maxFlailTime {
            // 小猫咪的行走动画
            if self.action(forKey: walkActionKey) == nil {
                let walkAction = SKAction.repeatForever(
                    SKAction.animate(with: self.walkFrames, timePerFrame: 0.1,
                                     resize: false, restore: true)
                )
                self.run(walkAction, withKey: walkActionKey)
            }

            // 用于修正猫咪被打中后的姿态
            if self.zRotation != 0 && self.action(forKey: "action_rotate") == nil {
                self.run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: "action_rotate")
            }
            
            // 第一个判断用于处理食物在头顶的情况
            if foodLocation.y > self.position.y && abs(foodLocation.x-self.position.y) < 2 {
                self.physicsBody?.velocity.dx = 0
                self.removeAction(forKey: walkActionKey)
                self.texture = walkFrames[1]
            } else if foodLocation.x < self.position.x {
                self.position.x -= CGFloat(deltaTime) * self.moveSpeed
                self.xScale = -1
            } else {
                self.position.x += CGFloat(deltaTime) * self.moveSpeed
                self.xScale = 1
            }
        }
        
    }
    
    /// 被雨击打
    public func hitByRain() {
        // 被击打后遗症
        self.timeSinceHit = 0
        // 清除动作
        self.removeAction(forKey: self.walkActionKey)
        
        if self.currentRainHits < self.maxRainHits {
            self.currentRainHits += 1
            return
        }
        
        // 如果被击打到一定次数，播放一段随机音效
        if self.action(forKey: "action_sound_effect") == nil {
            self.currentRainHits = 0
            let selectedSFX = Int(arc4random_uniform(UInt32(self.meowSFX.count)))
            self.run(SKAction.playSoundFileNamed(self.meowSFX[selectedSFX], waitForCompletion: true), withKey:"action_sound_effect")
        }
    }
}
