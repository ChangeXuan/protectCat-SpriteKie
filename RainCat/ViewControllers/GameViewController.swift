//
//  GameViewController.swift
//  RainCat
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置屏幕显示的大小
        let sceneNode = GameScene(size: view.frame.size)

        if let view = self.view as! SKView? {
            view.presentScene(sceneNode)
            // 设置为true时，同一个Z深度的子节点的顺序不会被保证
            view.ignoresSiblingOrder = true
            // 显示物理实体,多用于测试
            view.showsPhysics = false
            // 显示帧率
            view.showsFPS = true
            // 显示节点(精灵)的数量
            view.showsNodeCount = true
        }
        
        SoundManager.sharedInstance.startPlaying()
    }
    
    /// 是否允许自动旋转
    override var shouldAutorotate: Bool {
        return true
    }

    /// 设置屏幕朝向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape//横屏
    }

    /// 是否隐藏状态条
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
