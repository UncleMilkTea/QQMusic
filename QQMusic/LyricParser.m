//
//  LyricParser.m
//  QQMusic
//
//  Created by 侯玉昆 on 16/3/29.
//  Copyright © 2016年 suger. All rights reserved.
//

#import "LyricParser.h"
#import "Music.h"
#import "MusicLyric.h"
#import "NSDateFormatter + Extension.h"

@implementation LyricParser
+ (NSArray *)parserLyricWithFileName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSString *lyricStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSArray *lineStrs = [lyricStr componentsSeparatedByString:@"\n"];
    // 正则表达式 -- 范围
    NSString *pattern = @"\\[[0-9]{2}:[0-9]{2}.[0-9]{2}\\]";
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    // 2.2 获取每一行
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *lineStr in lineStrs) {
     
        // 获取所有匹配的结果
        NSArray *results = [regular matchesInString:lineStr options:0 range:NSMakeRange(0, lineStr.length)];
        // 获取最后一个匹配结果
        NSTextCheckingResult *lastRes = [results lastObject];
        // 获取歌词内容
        NSString *content = [lineStr substringFromIndex:lastRes.range.location + lastRes.range.length];
        // 获取时间
        for (NSTextCheckingResult *result in results) {
          
            NSString *timeStr = [lineStr substringWithRange:result.range];
         
            NSDateFormatter *dateFormatter = [NSDateFormatter sharedDateFormater];
            dateFormatter.dateFormat = @"[mm:ss.SS]";
            // 151秒
            NSDate *date = [dateFormatter dateFromString:timeStr];
            // 0秒
            NSDate *initDate = [dateFormatter dateFromString:@"[00:00.00]"];
            // 获取时间
            NSTimeInterval time = [date timeIntervalSinceDate:initDate];
            // 给模型赋值
            MusicLyric *lyric = [[MusicLyric alloc]init];
            
            lyric.content = content;
            
            lyric.time = time;
            
            [array addObject:lyric];
           
        }
        /**
         *  数组排序
         */
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
        
        [array sortUsingDescriptors:@[descriptor]];
    }
     // 返回数组
    return array;
}

@end
