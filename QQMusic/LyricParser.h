//
//  LyricParser.h
//  QQMusic
//
//  Created by 侯玉昆 on 16/3/29.
//  Copyright © 2016年 suger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricParser : NSObject
/**
 *  歌词解析
 *
 *  @param fileName 歌词名称
 *
 *  @return 解析完的数组
 */
+ (NSArray *)parserLyricWithFileName:(NSString *)fileName;

@end
