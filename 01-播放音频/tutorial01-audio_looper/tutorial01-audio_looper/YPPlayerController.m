//
//  YPPlayerController.m
//  tutorail-audio_looper
//
//  Created by Chengguangfa on 2017/9/15.
//  Copyright © 2017年 com.dazheng.yaojiang. All rights reserved.
//

#import "YPPlayerController.h"
#import <AVFoundation/AVFoundation.h>

@interface YPPlayerController()
@property (assign, nonatomic) BOOL  playing;
@property (strong, nonatomic) NSArray  *players;
@end

@implementation YPPlayerController


-(instancetype)init
{

    if (self = [super init]) {
        
        AVAudioPlayer *guitar = [self playerForFile:@"guitar"];
        AVAudioPlayer *bass = [self playerForFile:@"bass"];
        AVAudioPlayer *drums = [self playerForFile:@"drums"];
        
        _players = @[guitar,bass,drums];
        
        //处理中断事件
        NSNotificationCenter *nsnc = [NSNotificationCenter defaultCenter];
        
        [nsnc addObserver:self
                 selector:@selector(handleInterruption:)
                     name:AVAudioSessionInterruptionNotification
                   object:[AVAudioSession sharedInstance]];
        
        //处理输入设备事件
        [nsnc addObserver:self
                 selector:@selector(handleRouteChange:)
                     name:AVAudioSessionRouteChangeNotification
                   object:[AVAudioSession sharedInstance]];
    }
    return self;
}

#pragma mark --处理耳机设备更换事件--
-(void)handleRouteChange:(NSNotification *)notification
{
    
    NSDictionary *info = notification.userInfo;
    
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    //旧设备不可用
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        //远程设备的描述
        AVAudioSessionRouteDescription *previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey];
        //设备
        AVAudioSessionPortDescription *port = previousRoute.outputs[0];
        
        if ([port.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            
            [self stop];
            
            !self.delegate?:[self.delegate playbackStopped];
            
        }
        
        
    }
    

}
#pragma mark --处理中断事件--
-(void)handleInterruption:(NSNotification *)notification
{
    
    NSDictionary *info = notification.userInfo;
    
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] integerValue];
    
    switch (type) {
            //中断开始
        case AVAudioSessionInterruptionTypeBegan:
        {
            [self stop];
            //调用代理 停止
            !self.delegate?:[self.delegate playbackStopped];
        }
            break;
            //中断结束
        case AVAudioSessionInterruptionTypeEnded:
        {
            AVAudioSessionInterruptionOptions option = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
            //表明音频会话是否已经重新激活以及是否可以再次播放
            if (option == AVAudioSessionInterruptionOptionShouldResume) {
                [self play];
                
                !self.delegate?:[self.delegate playbackBegin];
            }
            
            
            
        }
            break;
            
        default:
            break;
    }


}

//初始化项目
-(AVAudioPlayer *)playerForFile:(NSString *)fileName
{
 
    //caf 是苹果通用的音乐容器
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"caf"];
    NSError *error;
    
    AVAudioPlayer *avAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    
    if (avAudio) {
        //-1(负数)表示循环播放 ,0表示播放一次,1表示播放两次,依次类推
        avAudio.numberOfLoops = -1;
        //YES-对播放率进行控制  NO-不对播放率进行控制
        avAudio.enableRate = YES;
        //启动播放前的初始化
        [avAudio prepareToPlay];
    }
    else
    {
        NSLog(@"ERROR creating player: %@",[error localizedDescription]);
    }
    
    
    return avAudio;
}

/**
 *  播放
 */
-(void)play{

    if (!self.isPlaying) {
        NSTimeInterval delayTime = [self.players[0] deviceCurrentTime] +0.01;
        
        for (AVAudioPlayer *player in self.players) {
            [player playAtTime:delayTime];
        }
        self.playing = YES;
    }
    
}
/**
 *  停止
 */
-(void)stop{
    
    if (self.isPlaying) {
        
        for (AVAudioPlayer *player in self.players) {
            
            [player stop];
            player.currentTime = 0;
            
        }
        self.playing = NO;
    }

}
/**
 *  调整播放速度
 */
-(void)adjustRate:(float)rate{

    for (AVAudioPlayer *players in self.players) {
        players.rate = rate;
    }
    
}
/**
 *  调整声道
 */
-(void)adjustPan:(float)pan forPlayerAtIndex:(NSInteger)index{

    if ([self isValidIndex:index]) {
        AVAudioPlayer *players = self.players[index];
        players.pan = pan;
    }

    
    
    
}
/**
 *  调整音量
 */
-(void)adjustVolume:(float)volume forPlayerAtIndex:(NSInteger)index{

    if ([self isValidIndex:index]) {
        AVAudioPlayer *players = self.players[index];
        players.volume = volume;
    }


}
/**
 *  判断是否越界
 */
-(BOOL)isValidIndex:(NSInteger)index
{
    
    return (index>=0)&&(index<self.players.count);


}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
