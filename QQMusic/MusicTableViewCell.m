//
//  MusicTableViewCell.m
//  QQMusic
//
//  Created by 侯玉昆 on 16/4/15.
//  Copyright © 2016年 suger. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "Music.h"

@interface MusicTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *musicName;

@property (weak, nonatomic) IBOutlet UILabel *singerName;

@end

@implementation MusicTableViewCell

// 加载xib
+ (instancetype)initWithCell{
    
    return [[NSBundle mainBundle] loadNibNamed:@"MusicTableViewCell" owner:self options:nil].lastObject;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.backgroundColor = [UIColor clearColor];
}
// 赋值
- (void)setModel:(Music *)model{
    
    _model = model;
    
    _iconImage.image = [UIImage imageNamed:model.image];
    
    _iconImage.layer.cornerRadius = (_height - 20) * .5;
    
    _iconImage.layer.masksToBounds = YES;
    
    _musicName.text = model.name;
    
    _singerName.text = [NSString stringWithFormat:@"%@❥%@",model.singer,model.album];
    
}
@end
