//
//  CPRecordController.h
//  02-录音
//
//  Created by Chengguangfa on 2017/12/29.
//  Copyright © 2017年 com.univsport.icehockey. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CPMemo;
typedef void (^CPRecordingStopCompletionHandler)(BOOL);
typedef void (^CPRecordingSaveCompletionHandler)(BOOL, id);

@interface CPRecordController : NSObject
@property (copy, nonatomic) NSString  *currentTime;
@property (assign, nonatomic) CGFloat level;
-(BOOL)record;
-(void)pause;
-(void)stopWithCompletionHandler:(CPRecordingStopCompletionHandler)handler;
-(void)saveRecordingWithName:(NSString *)name completionHandler:(CPRecordingSaveCompletionHandler)handler;
-(BOOL)playBackMemo:(CPMemo *)memo;

@end
