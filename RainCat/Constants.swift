//
//  Constants.swift
//  RainCat
//
//  Created by 覃子轩 on 2017/5/13.
//  Copyright © 2017年 Thirteen23. All rights reserved.
//

import Foundation

// 世界的类别
let WorldCategory       : UInt32 = 0x1 // 1
// 雨滴的类别
let RainDropCategory    : UInt32 = 0x1 << 1 // 2
// 地板的类别
let FloorCategory       : UInt32 = 0x1 << 2 // 4
// 猫的类别
let CatCategory         : UInt32 = 0x1 << 3 // 8
// 食物类别
let FoodCategory        : UInt32 = 0x1 << 4 //16

let CatSpriteZ          : Int = 5
let FoodSpriteZ         : Int = 5
let UmbrellaZ           : Int = 4
let RainDropZ           : Int = 2
let GroundNodeZ         : Int = 1
let SkyNodeZ            : Int = 0
