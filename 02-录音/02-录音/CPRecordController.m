//
//  CPRecordController.m
//  02-录音
//
//  Created by Chengguangfa on 2017/12/29.
//  Copyright © 2017年 com.univsport.icehockey. All rights reserved.
//

#import "CPRecordController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CPMemo.h"
@interface CPRecordController()<AVAudioRecorderDelegate>
@property (strong, nonatomic) AVAudioPlayer  *player;
@property (strong, nonatomic) AVAudioRecorder  *recorder;
@property (copy, nonatomic) CPRecordingStopCompletionHandler completionHandler;
@end

@implementation CPRecordController
-(instancetype)init
{
    if (self = [super init]) {
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *filePath = [tmpDir stringByAppendingPathComponent:@"memo.caf"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSDictionary *options = @{
                                  //音频格式
                                  AVFormatIDKey:@(kAudioFormatAppleIMA4),
                                  //采样率
                                  AVSampleRateKey:@44100,
                                  //通道
                                  AVNumberOfChannelsKey:@1,
                                  //位宽
                                  AVEncoderBitDepthHintKey:@16,
                                  //音频质量
                                  AVEncoderAudioQualityKey:@(AVAudioQualityMedium)
                                  };
        NSError *error;
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:options error:&error];
        
        if (self.recorder) {
            self.recorder.delegate = self;
            [self.recorder prepareToRecord];
        }
        else
        {
            NSLog(@"fail to initialize recorder: %@",[error localizedDescription]);
        }
        
    }
    return self;
}
-(BOOL)record
{
    return [self.recorder record];
}

-(void)pause{
    
    return [self.recorder pause];
}
-(void)stopWithCompletionHandler:(CPRecordingStopCompletionHandler)handler
{
    self.completionHandler = handler;
    
    [self.recorder stop];
    
}
-(void)saveRecordingWithName:(NSString *)name completionHandler:(CPRecordingSaveCompletionHandler)handler
{
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    
    NSString *fileName = [NSString stringWithFormat:@"%@-%f.caf",name,timestamp];
    
    NSString *docDir = [self documentDirectory];
    
    NSString *desDir = [docDir stringByAppendingPathComponent:fileName];
    
    NSURL *srcUrl = self.recorder.url;
    
    NSURL * destUrl = [NSURL fileURLWithPath:desDir];
    
    NSError *error;
    
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:srcUrl toURL:destUrl error:&error];
    
    if (success) {
        handler(YES,[CPMemo memoWithTitle:name url:destUrl]);
        [self.recorder prepareToRecord];
    }
    else
    {
        handler(NO,error);
    }
    
}
-(NSString *)documentDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    if (self.completionHandler) {
        self.completionHandler(flag);
    }
    
}
#pragma mark --处理中断情况下--
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    
    
}
#pragma mark --处理中断完成--
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
    
}


-(NSString *)currentTime
{
    NSUInteger time = (NSUInteger)self.recorder.currentTime;
    
    NSUInteger hours = time/3600;
    NSUInteger mins = (time%3600)/60;
    NSUInteger sec = time % 60;
    
    return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hours,mins,sec];
    
}



-(BOOL)playBackMemo:(CPMemo *)memo
{
    [self.player stop];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:memo.url error:NULL];
    
    if (self.player) {
        
        [self.player play];
        
        return YES;
        
    }
    else
    {
        return NO;
    }
    
}



@end
