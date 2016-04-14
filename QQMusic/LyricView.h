//
//  LyricView.h
//  QQMusic
//
//  Created by iMac on 16/4/14.
//  Copyright © 2016年 suger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyricView;

@protocol LyricViewDelegate <NSObject>

@optional

- (void)lyricView:(LyricView *)lyricView withProgress:(CGFloat)progress;

@end

@interface LyricView : UIView

@property (nonatomic, weak) id <LyricViewDelegate>delegate;
/// 歌词数组
@property (nonatomic, strong) NSArray *lyrics;
/// 每行歌词的高度
@property (nonatomic, assign) NSInteger rowHeight;
/// 当前显示的歌词索引
@property (nonatomic, assign) NSInteger currentLyricIndex;

@property (nonatomic, assign) CGFloat progress;

@end
