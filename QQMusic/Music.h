//
//  Music.h
//  QQMusic
//
//  Created by 侯玉昆 on 16/3/28.
//  Copyright © 2016年 suger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MusicTypeLocal,
    MusicTypeRemote
}musicType;

@interface Music : NSObject
/// 歌曲图片
@property (nonatomic, copy) NSString *image;
/// 歌词文件名
@property (nonatomic, copy) NSString *lrc;
/// 歌曲文件名
@property (nonatomic, copy) NSString *mp3;
/// 类型
@property (nonatomic, assign)musicType type;
/// 歌曲名
@property (nonatomic, copy) NSString *name;
/// 歌手
@property (nonatomic, copy) NSString *singer;
/// 专辑
@property (nonatomic, copy) NSString *album;

@end
