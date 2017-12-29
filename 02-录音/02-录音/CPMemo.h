//
//  CPMemo.h
//  02-录音
//
//  Created by Chengguangfa on 2017/12/29.
//  Copyright © 2017年 com.univsport.icehockey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPMemo : NSObject
@property (readonly, nonatomic) NSString  *name;
@property (readonly, nonatomic) NSURL  *url;
+(instancetype)memoWithTitle:(NSString *)title url:(NSURL *)url;
@end
