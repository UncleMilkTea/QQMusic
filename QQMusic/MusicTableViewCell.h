//
//  MusicTableViewCell.h
//  QQMusic
//
//  Created by 侯玉昆 on 16/4/15.
//  Copyright © 2016年 suger. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Music;

@interface MusicTableViewCell : UITableViewCell
//! 模型
@property(strong,nonatomic) Music *model;
//! cell高度
@property (assign, nonatomic) CGFloat height;
//! 初始化
+ (instancetype)initWithCell;
@end
