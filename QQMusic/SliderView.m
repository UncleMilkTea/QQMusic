//
//  SliderView.m
//  QQMusic
//
//  Created by iMac on 16/4/14.
//  Copyright © 2016年 suger. All rights reserved.
//

// 省略前缀
#define MAS_SHORTHAND
// 可以使用基本数据类型
#define MAS_SHORTHAND_GLOBALS
#import "SliderView.h"
#import "Masonry.h"
#import "PlayManager.h"
#import "TimeTool.h"

@interface SliderView ()

/// 背景图片
@property (nonatomic, weak) UIImageView *bgImageView;
/// 时间
@property (nonatomic, weak) UILabel *timeLabel;
/// 提示
@property (nonatomic, weak) UILabel *tipLabel;
/// 播放按钮
@property (nonatomic, weak) UIButton *playBtn;

@end

@implementation SliderView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    // 1.初始化控件
    UIImageView *bgImageView = [[UIImageView alloc ] init];
    self.bgImageView = bgImageView;
    [self addSubview:bgImageView];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:timeLabel];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    self.tipLabel = tipLabel;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:tipLabel];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn = playBtn;
    [self addSubview:playBtn];
    
    // 背景图片
    bgImageView.image = [UIImage imageNamed:@"lyric_tipview_backimg"];
    // 时间
    timeLabel.text = @"00:00";
    // 提示文字
    tipLabel.text = @"请点击右边按钮从这行开始播放";
    // 按钮的图片
    [playBtn setImage:[UIImage imageNamed:@"slide_icon_play"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"slide_icon_play_pressed"] forState:UIControlStateHighlighted];
    [playBtn addTarget:self action:@selector(playBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加约束
    [bgImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(8);
    }];
    
    [tipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-8);
    }];
}
/// 点击滚动条上的播放按钮,从这行歌词开始播放
- (void)playBtnClicked
{
    PlayManager *playManager = [PlayManager sharedPlayManager];
    
    playManager.play.currentTime = self.time;
}
#pragma mark setter和getter方法
- (void)setTime:(NSTimeInterval)time
{
    _time = time;
    // 滚动条显示的这行歌词的开始时间
    self.timeLabel.text = [TimeTool stringWithTime:time];
}
@end
