//
//  ViewController.m
//  QQMusic
//
//  Created by 侯玉昆 on 16/4/10.
//  Copyright © 2016年 suger. All rights reserved.
//

#define MAS_SHORTHAND         // 省略前缀
#define MAS_SHORTHAND_GLOBALS // 可以使用基本数据类型
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"
#import "Masonry.h"
#import "PlayManager.h"
#import "Music.h"
#import "MJExtension.h"
#import "LyricParser.h"
#import "MusicLyric.h"
#import "TimeTool.h"
#import "LyricView.h"

@interface ViewController () <LyricViewDelegate>

//进度条
@property (weak, nonatomic) IBOutlet UISlider *slider;
//歌曲名
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//垂直图片
@property (weak, nonatomic) IBOutlet UIImageView *hBackGroundImage;
//水平图片
@property (weak, nonatomic) IBOutlet UIImageView *vBackGroundImage;
//歌手图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//歌词
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lyricLabels;
//总共时长
@property (weak, nonatomic) IBOutlet UILabel *sumTimer;
//专辑
@property (weak, nonatomic) IBOutlet UILabel *album;
//当前时间
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
//播放按钮
@property (weak, nonatomic) IBOutlet UIButton *play;
//歌词View
@property (strong, nonatomic) IBOutlet LyricView *lyricView;
//水平中心View
@property (weak, nonatomic) IBOutlet UIView *vCenterView;

#pragma mark - 私有属性
//歌曲数组
@property(strong,nonatomic) NSArray *musicArray;
//当前歌曲
@property(assign,nonatomic) NSInteger currentMusic;
//定时器
@property(strong,nonatomic) NSTimer *timer;
//歌词数组
@property(strong,nonatomic) NSArray *lyrics;
//当前歌词索引
@property(assign,nonatomic) NSInteger currentLyricIndex;
//歌词管理
@property(strong,nonatomic) PlayManager *playManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //高斯模糊
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    toolbar.barStyle = UIBarStyleBlack;
    
    [_hBackGroundImage addSubview:toolbar];
    
    [toolbar makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
    //切图圆角
    _imageView.layer.cornerRadius = _imageView.bounds.size.width *.5;
    
    _imageView.clipsToBounds = YES;
    
    _lyricView.delegate = self;
    
    [self changeMusic];
    
    //监听歌词打断处理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMusic:) name:@"changeMusic" object:nil];

}

- (void)changeMusic:(NSNotification *)noty{
    
    NSIndexPath *indexPath = (NSIndexPath *)noty.object;

    _currentMusic = indexPath.row;
    
    [self changeMusic];
}
#pragma mark - 歌词打断处理
- (void)audioSessionInterruptionNotification:(NSNotification *)noti{
    
    // 获取打断的状态
    NSDictionary *userInfo = noti.userInfo;
    // 开始打断
    if ([userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntValue] == AVAudioSessionInterruptionTypeBegan) {
        
        // 暂停歌曲
        _play.selected  = YES; [self play];
        
    }else if([userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntValue] == AVAudioSessionInterruptionTypeEnded){
        
        // 继续播放歌曲
        _play.selected = NO;
        [self playButton];
        _play.selected = YES;
        [self playButton];
        _play.selected = NO;
        [self playButton];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 下一曲
- (IBAction)next{
    
    if (_currentMusic == self.musicArray.count - 1) {
        
        _currentMusic = 0;
        
    }else{
        
        _currentMusic ++;
    }
    [self changeMusic];
}
#pragma mark - 上一曲
- (IBAction)last{
    
    if (_currentMusic == 0) {
        
        _currentMusic = self.musicArray.count - 1;
        
    }else{
        
        _currentMusic --;
    }
    [self changeMusic];
}

#pragma mark - 播放按钮
- (IBAction)playButton{
    
    Music *music = self.musicArray[_currentMusic];
    
    if (_play.selected == NO) {
        
        _play.selected = YES;
        
        [self startTimer];
        //自动播放下一首
        [_playManager playMusicWithFileName:music.mp3 didComplete:^{
            
            [self next];
        }];
    }else{
        
        _play.selected = NO;
        
        [_playManager.play pause];
        
        [self stopTimer];
    }
}
#pragma mark - 进度条
- (IBAction)slider:(UISlider *)sender {
    
    _playManager.play.currentTime = _slider.value * _playManager.play.duration;
    
}

#pragma mark - 切歌
- (void)changeMusic{
    
    _playManager =  [PlayManager sharedPlayManager];
    
    Music *music = self.musicArray[_currentMusic];
    
    _titleLabel.text = music.singer;
    
    _hBackGroundImage.image = [UIImage imageNamed:music.image];
    
    _imageView.image = _hBackGroundImage.image;
    
    _vBackGroundImage.image = _hBackGroundImage.image;
    
    _album.text =[NSString stringWithFormat:@"专辑:%@",music.album];
    
    _play.selected = NO;
    
    //切歌是要清空之前的定时器
    [self stopTimer];
    
    [self playButton];
    
   
    // 设置歌曲总时长
    _sumTimer.text = [TimeTool stringWithTime:_playManager.play.duration];
    //获取歌词数组
    _lyrics = [LyricParser parserLyricWithFileName:music.lrc];
    //防止歌词数组越界
    _currentLyricIndex = 0;
    //传递歌词
    _lyricView.lyrics = _lyrics;
    
}

#pragma mark - 开启定时器
- (void)startTimer{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(turnPicture) userInfo:nil repeats:YES];
}
#pragma mark - 停止定时器
- (void)stopTimer{
    
    [_timer invalidate];
    
    _timer = nil;
}

#pragma mark - 图片旋转
- (void)turnPicture{
    
    _imageView.transform = CGAffineTransformRotate(_imageView.transform,M_PI_4 * .01);
    
    _currentTime.text = [TimeTool stringWithTime:_playManager.currentTime];
    
    _slider.value = _playManager.currentTime/_playManager.play.duration;
    
    //显示歌词
        [self updateLyric];
    //更新锁屏
        [self updateLockScreen];
    
}

#pragma mark - 显示歌词
- (void)updateLyric{
    
    // 歌词模型
    MusicLyric *lyric = _lyrics[_currentLyricIndex];
    
    MusicLyric *nextLyric = nil;
    
    if (_currentLyricIndex == _lyrics.count - 1) {
        
        nextLyric = [[MusicLyric alloc]init];
        
        nextLyric.time = _playManager.play.duration;
        
    }else{
        
        nextLyric = _lyrics[_currentLyricIndex + 1];
    }
    
    // 1.歌词太快
    if (_playManager.currentTime < lyric.time && _currentLyricIndex != 0) {
        
        _currentLyricIndex --; [self updateLyric];
    }
    // 1.歌词太慢
    if (_playManager.currentTime > nextLyric.time && _currentLyricIndex != _lyrics.count - 1) {
        
        _currentLyricIndex ++; [self updateLyric];
    }
   CGFloat progress = (_playManager.currentTime - lyric.time)/(nextLyric.time - lyric.time);
    
    //给歌词渲染
    [_lyricLabels setValue:@(progress) forKey:@"progress"];
    //歌词赋值
    [_lyricLabels setValue:lyric.content forKey:@"text"];
    
    //给歌词View传递歌词
    _lyricView.currentLyricIndex = _currentLyricIndex;
    //改变歌词Viewyanse
    _lyricView.progress = progress;

}

#pragma mark - 更新锁屏界面
- (void)updateLockScreen
{
    // 获取歌曲的模型
    Music *music = self.musicArray[_currentMusic];
    // 获取歌曲时长
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 锁屏界面所有的元素
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名
    info[MPMediaItemPropertyAlbumTitle] = music.album;
    // 歌手
    info[MPMediaItemPropertyArtist] = music.singer;
    // 专辑图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[self updateLockLyricImage]];
    // 歌曲时长
    info[MPMediaItemPropertyPlaybackDuration] = @(_playManager.play.duration);
    // 歌名
    info[MPMediaItemPropertyTitle] = music.name;
    // 歌曲当前播放时间
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(_playManager.play.currentTime);
    
    infoCenter.nowPlayingInfo = info;
}
#pragma mark - 更新锁屏界面的歌词
- (UIImage *)updateLockLyricImage
{
    // 获取当前播放歌曲的模型
    Music *music = self.musicArray[_currentMusic];
    // 获取当前播放歌曲的专辑图片
    UIImage *albumImage = [UIImage imageNamed:music.image];
    // 当前播放歌词的模型
    MusicLyric *lyric = _lyrics[_currentLyricIndex];
    // 歌词的背景图片
    UIImage *lyricBgImage = [UIImage imageNamed:@"lock_lyric_mask"];
    // 1.开启图形上下文
    UIGraphicsBeginImageContext(albumImage.size);
    // 2.画专辑图片
    [albumImage drawInRect:CGRectMake(0, 0, albumImage.size.width, albumImage.size.height)];
    // 3.画歌词背景图片
    CGFloat bgImageH = 40;
    CGFloat bgImageW = albumImage.size.width;
    CGFloat bgImageX = 0;
    CGFloat bgImageY = albumImage.size.height - bgImageH;
    [lyricBgImage drawInRect:CGRectMake(bgImageX, bgImageY, bgImageW, bgImageH)];
    // 设置字体颜色
    [[UIColor whiteColor] set];
    // 4.画歌词
//    [lyric.content drawInRect:CGRectMake(0, bgImageY + 10, albumImage.size.width, 30) withFont:[UIFont systemFontOfSize:16] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    NSMutableParagraphStyle *paragraph=[[NSMutableParagraphStyle alloc]init];
    paragraph.alignment=NSTextAlignmentCenter;//居中
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;//换行方式
    
    NSDictionary *attr = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:16],//字体大小
                          NSParagraphStyleAttributeName:paragraph,//段落格式
                          };
    
    [lyric.content drawInRect:CGRectMake(0, bgImageY + 10, albumImage.size.width, 30) withAttributes:attr];
    
    // 5.取出图片
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    // 7. 返回图片
    return finalImage;
}


#pragma mark - 懒加载
- (NSArray *)musicArray{
    
    if (!_musicArray) {
        _musicArray = [Music objectArrayWithFilename:@"mlist.plist"];
    }
    return _musicArray;
}

- (void)lyricView:(LyricView *)lyricView withProgress:(CGFloat)progress{
    
    _vCenterView.alpha = progress > 1 ?  2 - progress : progress;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - 接收远程控制事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playButton];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self last];
            break;
        default:
            break;
    }
}

@end
