//
//  CPMemo.m
//  02-录音
//
//  Created by Chengguangfa on 2017/12/29.
//  Copyright © 2017年 com.univsport.icehockey. All rights reserved.
//

#import "CPMemo.h"
@interface CPMemo()
@property (copy, nonatomic) NSString  *name;
@property (strong, nonatomic) NSURL  *url;
@end
@implementation CPMemo

+(instancetype)memoWithTitle:(NSString *)title url:(NSURL *)url
{
    return [[self alloc] initWithTitle:title url:url];
}
-(instancetype)initWithTitle:(NSString *)title url:(NSURL *)url
{
    if (self = [super init]) {
        self.name = title;
        self.url = url;
    }
    return self;
}

@end
