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

//- (void)awakeFromNib{
//    
//    
//    
//    [self setupUI];
//
//}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
        
        if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
            
            // 设置被选择的样式
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // 进行控件的初始化
            [self setupUI];
            
        }
        
        return self;
    }
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setupUI];
    
}
- (void)setupUI{
    
    self.backgroundColor = [UIColor clearColor];
    
    
}
- (void)setModel:(Music *)model{
    
    _model = model;
    
    _iconImage.image = [UIImage imageNamed:model.image];
    
    _iconImage.layer.cornerRadius = _iconImage.image.size.width *.5;
    
    _musicName.text = model.name;
    
    _singerName.text = [NSString stringWithFormat:@"%@❥%@",model.singer,model.album];
    
}
@end
