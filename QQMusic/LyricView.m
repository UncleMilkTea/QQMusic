//
//  LyricView.m
//  QQMusic
//
//  Created by iMac on 16/4/14.
//  Copyright © 2016年 suger. All rights reserved.
//

// 省略前缀
#define MAS_SHORTHAND
// 可以使用基本数据类型
#define MAS_SHORTHAND_GLOBALS
#import "LyricView.h"
#import "Masonry.h"
#import "UIColorLabel.h"
#import "MusicLyric.h"
#import "SliderView.h"


@interface LyricView ()<UIScrollViewDelegate>
//{
//    NSInteger _currentLyricIndex;
//}
// 横向滑动的scrollView
@property (nonatomic, weak) UIScrollView *hScrollView;
/// 竖直滑动的scrollView
@property (nonatomic, weak) UIScrollView *vScrollView;
/// 滚动条
@property (nonatomic, weak) SliderView *sliderView;

@end

@implementation LyricView

// 给currentLyricIndexset和get方法
@synthesize currentLyricIndex = _currentLyricIndex;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    // 1.创建控件
    UIScrollView *hScrollView = [[UIScrollView alloc] init];
    self.hScrollView = hScrollView;
    self.hScrollView.delegate = self;
    // 取消滑动条
    hScrollView.showsHorizontalScrollIndicator = NO;
    // 添加分页效果
    hScrollView.pagingEnabled = YES;
    //    hScrollView.backgroundColor = [UIColor blueColor];
    [self addSubview:hScrollView];
    
    UIScrollView *vScrollView = [[UIScrollView alloc] init];
    self.vScrollView = vScrollView;
    vScrollView.delegate = self;
    //    vScrollView.backgroundColor = [UIColor redColor];
    [self.hScrollView addSubview:vScrollView];
    
    
    // 初始化滚动条
    SliderView *sliderView = [[SliderView alloc] init];
    self.sliderView = sliderView;
    // 隐藏滚动条
    sliderView.hidden = YES;
    [self addSubview:sliderView];
    // 滚动条的约束
    [sliderView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(30);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 2.添加约束
    // 横屏滑动的约束
    [self.hScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.hScrollView.contentSize = CGSizeMake(self.bounds.size.width * 2, 0);
    //竖直滑动的约束
    [self.vScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.equalTo(self.bounds.size.width);
        make.left.equalTo(self.bounds.size.width);
    }];
    
    //给歌词顶部一定的距离 -->当前view的一半
    CGFloat top = (self.bounds.size.height - self.rowHeight) * 0.5;
    CGFloat bottom = top;
    self.vScrollView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.vScrollView.contentOffset = CGPointMake(0, -top);
}

#pragma mark 代理方法
// 滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.hScrollView) {
        [self hScrollViewDidScroll];
    }else{
        [self vScrollViewDidScroll];
    }
}
// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.vScrollView) {
        self.sliderView.hidden = NO;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == self.vScrollView) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 屏蔽拖拽时隐藏的情况
            if (scrollView.isDragging == NO) {
                self.sliderView.hidden = YES;
            }
            
        });
        
    }
}
/// 竖直滚动
- (void)vScrollViewDidScroll
{
    //    NSLog(@"%f",self.vScrollView.contentOffset.y / self.rowHeight);
    // 获取滚动位置的歌词索引
    NSInteger lyricIndex = (self.vScrollView.contentOffset.y + self.vScrollView.contentInset.top) / self.rowHeight;
    NSLog(@"%zd",lyricIndex);
    // 屏蔽向下拉和向上拖动时的越界
    if (lyricIndex < 0) {
        lyricIndex = 0;
    }else if (lyricIndex > self.lyrics.count - 1){
        lyricIndex = self.lyrics.count - 1;
    }
    MusicLyric *lyric = self.lyrics[lyricIndex];
    // 给slideView显示用户拖动到的那行歌词的开始时间
    self.sliderView.time = lyric.time;
}
/// 横屏滚动
- (void)hScrollViewDidScroll
{
    // contentOffset.x:0 到 屏幕宽度
    CGFloat progress = self.hScrollView.contentOffset.x / self.bounds.size.width;
    NSLog(@"%f",progress);
    // 代理方法传递值
    if ([self.delegate respondsToSelector:@selector(lyricView:withProgress:)]) {
        [self.delegate lyricView:self withProgress:progress];
    }
}


#pragma mark setter 和 getter方法
- (void)setLyrics:(NSArray *)lyrics
{
    _lyrics = lyrics;
    // 避免切歌时重复加载label
    [self.vScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加歌词label
    for (int i=0; i<lyrics.count; i++) {
        MusicLyric *lyric = lyrics[i];
        UIColorLabel *colorLabel = [[UIColorLabel alloc] init];
        colorLabel.text = lyric.content;
        colorLabel.font = [UIFont systemFontOfSize:11];
        colorLabel.textColor = [UIColor whiteColor];
        [self.vScrollView addSubview:colorLabel];
        // 添加约束
        [colorLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(i * self.rowHeight);
            make.height.equalTo(self.rowHeight);
            make.centerX.equalTo(self.vScrollView);
        }];
    }
    //竖直滑动的距离
    self.vScrollView.contentSize = CGSizeMake(0, self.rowHeight * self.lyrics.count);
}

- (void)setCurrentLyricIndex:(NSInteger)currentLyricIndex
{
    // _currentLyricIndex上一行歌词的索引
    // preLabel 上一个歌词的label
    UIColorLabel *preLabel = self.vScrollView.subviews[self.currentLyricIndex];
    // 修改播放过的歌词label字体为白色
    preLabel.progress = 0;
    preLabel.font = [UIFont systemFontOfSize:11];
    
    _currentLyricIndex = currentLyricIndex;
    // currentLyricIndex当前播放的歌词索引
    // 修改歌词label字体的大小
    // 当前播放歌词对应的label -->colorLabel
    UIColorLabel *colorLabel = self.vScrollView.subviews[currentLyricIndex];
    colorLabel.font = [UIFont systemFontOfSize:16];
    
    // 屏蔽拖拽歌词时自动滚动
    if (self.sliderView.hidden == NO) {
        return;
    }
    // 让歌词滚动
    CGFloat offsetY = currentLyricIndex * self.rowHeight - self.vScrollView.contentInset.top;
    self.vScrollView.contentOffset = CGPointMake(0, offsetY);
}

- (NSInteger)currentLyricIndex
{
    // 屏蔽切歌时数组越界
    if (_currentLyricIndex < 0 ){
        _currentLyricIndex = 0;
    }else if(_currentLyricIndex > self.lyrics.count - 1){
        _currentLyricIndex = self.lyrics.count - 1;
    }
    return _currentLyricIndex;
}

- (NSInteger)rowHeight
{
    if (!_rowHeight) {
        
        _rowHeight = 44;
    }
    return _rowHeight;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    // 修改歌词颜色
    UIColorLabel *colorLabel = self.vScrollView.subviews[self.currentLyricIndex];
    colorLabel.progress = progress;
}
@end
