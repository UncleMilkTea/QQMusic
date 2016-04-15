//
//  MusicLyric.h
//  QQMusic
//
//  Created by 侯玉昆 on 16/4/7.
//  Copyright © 2016年 suger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicLyric : NSObject

//! 歌词内容
@property(copy,nonatomic) NSString *content;
//! 歌词开始时间
@property(assign,nonatomic) NSTimeInterval time;

@end
