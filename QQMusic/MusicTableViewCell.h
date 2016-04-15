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

@property(strong,nonatomic) Music *model;

@end
