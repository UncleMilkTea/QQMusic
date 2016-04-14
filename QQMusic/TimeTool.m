//
//  TimeTool.m
//  QQMusic
//
//  Created by iMac on 16/4/14.
//  Copyright © 2016年 suger. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool

+ (NSString *)stringWithTime:(NSTimeInterval)time
{
    // 分钟
    int minute = time / 60;
    // 秒
    int second = (int)time % 60;
    // 02:59
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}

@end
