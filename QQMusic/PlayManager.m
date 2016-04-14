
//  PlayManager.m
//  QQMusic
//
//  Created by 侯玉昆 on 16/3/28.
//  Copyright © 2016年 suger. All rights reserved.
//

#import "PlayManager.h"


@interface PlayManager ()<AVAudioPlayerDelegate>

@property(copy,nonatomic) NSString *fileName;

@property (nonatomic, copy) void(^complete)();

@end

@implementation PlayManager

+ (instancetype)sharedPlayManager{
   
    static PlayManager *_playManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _playManager = [[self alloc]init];
    });
    return _playManager;
}

- (void)playMusicWithFileName:(NSString *)fileName didComplete:(void(^)())complete
{
    if (![_fileName isEqualToString:fileName]) {
        // 1.加载资源文件
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        // 2.创建播放器
        _play = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        // 3.准备播放
        [_play prepareToPlay];
        
        _play.delegate = self;
        // 赋值
        _fileName = fileName;
        
        _complete = complete;
    }
    
    // 4.播放
    [_play play];
}
- (void)setCurrentTime:(NSTimeInterval)currentTime{
    
    _play.currentTime = currentTime;
}

- (NSTimeInterval)currentTime{
    
    return _play.currentTime;
}

- (NSTimeInterval)durationTime{
    
    return _play.duration;
}

#pragma mark 代理方法
/// 当歌曲播放完毕时调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //  在这里回调block
    self.complete();
}
@end
