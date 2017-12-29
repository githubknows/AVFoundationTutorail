//
//  ViewController.m
//  02-录音
//
//  Created by Chengguangfa on 2017/12/29.
//  Copyright © 2017年 com.univsport.icehockey. All rights reserved.
//

#import "ViewController.h"
#import "CPRecordController.h"
#import "CPMeterTable.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSTimer  *timer;
@property (strong, nonatomic) CPRecordController  *recorder;
@property (strong, nonatomic) CADisplayLink  *link;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recorder = [[CPRecordController alloc] init];
    
    
}
- (IBAction)play:(id)sender {
    [self.recorder record];
    [self startTimer];
    [self startlink];
}
- (IBAction)pause:(id)sender {
    [self.recorder pause];
}
- (IBAction)stop:(id)sender {
    
    [self.recorder stopWithCompletionHandler:^(BOOL isOK) {
        if (isOK) {
            NSLog(@"录制完成!!!!");
        }
    }];
    
}
- (IBAction)ssave:(id)sender {
    
    [self.recorder saveRecordingWithName:@"CPMuic" completionHandler:^(BOOL isOK, id obj) {
        if (isOK) {
            NSLog(@"保存完成!!!!,保存对象是%@",obj);
        }
    }];
    
}

-(void)startTimer{
    
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateTimeDisplay:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}

-(void)startlink{
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter:)];
    
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}
-(void)updateMeter:(CADisplayLink *)link{
    
    
}

-(void)updateTimeDisplay:(NSTimer *)timer{
    
    self.timeLabel.text = self.recorder.currentTime;
    
}




@end
