//
//  SoundManager.swift
//  RainCat
//
//  Created by 覃子轩 on 2017/5/13.
//  Copyright © 2017年 Thirteen23. All rights reserved.
//

import AVFoundation

class SoundManager : NSObject, AVAudioPlayerDelegate {
    // 取得单例
    static let sharedInstance = SoundManager()
    
    var audioPlayer : AVAudioPlayer?
    var trackPosition = 0
    
    static private let tracks = [
        "bensound-clearday",
        "bensound-jazzcomedy",
        "bensound-jazzyfrenchy",
        "bensound-littleidea"
    ]
    
    private override init() {
        //This is private, so you can have only one Sound Manager ever.
        trackPosition = Int(arc4random_uniform(UInt32(SoundManager.tracks.count)))
    }
    
    public func startPlaying() {
        if audioPlayer == nil || audioPlayer?.isPlaying == false {
            let soundURL = Bundle.main.url(forResource: SoundManager.tracks[trackPosition], withExtension: "mp3")
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
                audioPlayer?.delegate = self
            } catch {
                print("audio player failed to load")
                
                startPlaying()
            }
            
            audioPlayer?.prepareToPlay()
            
            audioPlayer?.play()
            
            trackPosition = (trackPosition + 1) % SoundManager.tracks.count
        } else {
            print("Audio player is already playing!")
        }
    }
    
    // 播放完成后响应
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //Just play the next track.
        startPlaying()
    }
}
