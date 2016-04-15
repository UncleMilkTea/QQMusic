//
//  PlayManager.h
//  QQMusic
//
//  Created by 侯玉昆 on 16/3/28.
//  Copyright © 2016年 suger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayManager : NSObject

+ (instancetype)sharedPlayManager;

// 播放文件并
- (void)playMusicWithFileName:(NSString *)fileName didComplete:(void(^)())complete;
// 播放
@property (strong, nonatomic)AVAudioPlayer *play;
// 当前时间
@property(assign,nonatomic) NSTimeInterval currentTime;
// 总时间
@property(assign,nonatomic) NSTimeInterval durationTime;

@end
