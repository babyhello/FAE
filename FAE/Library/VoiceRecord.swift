//
//  VoiceRecord.swift
//  IMS
//
//  Created by 俞兆 on 2017/6/16.
//  Copyright © 2017年 Mark. All rights reserved.
//

import Foundation
import AVFoundation

class VoiceRecord {
    
    
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var file_path = ""
    
    //开始录音
    func beginRecord() {
        
        let VoiceUniqueName = Get_Unique_FileName() + ".wav"
        
        let VoicePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/"+VoiceUniqueName)
        
        self.file_path = VoicePath!
        
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: file_path)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }
    
    
    //结束录音
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束它，文件保存到了：\(file_path)")
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
    
    
    //播放
    func play() {
        do {
            
            print("VoiceREcordPath:" + file_path)
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file_path))
            print("歌曲长度：\(player!.duration)")
            player!.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    func Get_Unique_FileName() -> String
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let second = calendar.component(.second, from: date as Date)
        let nanosecond = calendar.component(.nanosecond, from: date as Date)
        
        return String(hour) + String(minutes) + String(second) + String(nanosecond)
    }
    
}

