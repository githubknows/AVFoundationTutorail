//
//  YPPlayerController.h
//  tutorail-audio_looper
//
//  Created by Chengguangfa on 2017/9/15.
//  Copyright © 2017年 com.dazheng.yaojiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YPPlayerDelegate <NSObject>

-(void)playbackStopped;
-(void)playbackBegin;

@end

@interface YPPlayerController : NSObject

@property (weak, nonatomic) id<YPPlayerDelegate> delegate;

@property (readonly, nonatomic,getter=isPlaying) BOOL  *Playing;
/**
 *  播放
 */
-(void)play;
/**
 *  停止
 */
-(void)stop;
/**
 *  调整播放速度
 */
-(void)adjustRate:(float)rate;
/**
 *  调整声道
 */
-(void)adjustPan:(float)pan forPlayerAtIndex:(NSInteger)index;
/**
 *  调整音量
 */
-(void)adjustVolume:(float)volume forPlayerAtIndex:(NSInteger)index;

@end
