//
//  FoodSprite.swift
//  RainCat
//
//  Created by 覃子轩 on 2017/5/13.
//  Copyright © 2017年 Thirteen23. All rights reserved.
//

import SpriteKit

public class FoodSprite:SKSpriteNode {
    public static func newInstance() -> FoodSprite {
        let foodDish = FoodSprite.init(imageNamed: "food_dish")
        foodDish.physicsBody = SKPhysicsBody.init(rectangleOf: foodDish.size)
        foodDish.zPosition = CGFloat(FoodSpriteZ)
        foodDish.physicsBody?.categoryBitMask = FoodCategory
        foodDish.physicsBody?.contactTestBitMask = RainDropCategory | WorldCategory | CatCategory
        
        return foodDish
    }
}
