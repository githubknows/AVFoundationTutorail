//
//  CPMeterTable.m
//  02-录音
//
//  Created by Chengguangfa on 2017/12/29.
//  Copyright © 2017年 com.univsport.icehockey. All rights reserved.
//

#import "CPMeterTable.h"
#define MIN_DB -60.0f
#define TABLE_SIZE 300
@implementation CPMeterTable
{
    float _scaleFactor;
    NSMutableArray *_meterTable;
}

-(instancetype)init
{
    if (self = [super init]) {
        //保证其范围保持在 0(-60DB) 到 1 之间; 解析分辨率 为 -0.2DB;
        float dbResolution = MIN_DB/(TABLE_SIZE - 1);
        _scaleFactor = 1.0 / dbResolution;
        float minAmp = dbToAmp(MIN_DB);
        
        float ampRange = 1.0 - minAmp;
        
        float invAmpRange = 1.0 / ampRange;
        
        for (int i = 0; i<TABLE_SIZE; ++i) {
            
            float decibels = i * dbResolution;
            float amp = dbToAmp(decibels);
            float adjAmp = (amp - minAmp) * invAmpRange;
            _meterTable[i] = @(adjAmp);
            
//            NSLog(@"%f",adjAmp);
        }
        
    }
    return self;
}

static float dbToAmp(float db)
{
    return powf(10.0f, 0.05 * db); //最小分贝的波形幅度值 公式: db 分贝 A 波形幅度值   dB=20∗log(A)→A=pow(10,(db/20.0))
}

-(float)valueForPower:(float)power
{
    if (power < MIN_DB) {
        return 0.0f;
    }
    else if(power >= 0.0f)
    {
        return 1.0f;
    }
    else
    {
        int index = (int)(power * _scaleFactor);
        
        return [_meterTable[index] floatValue];
    }
}

@end
