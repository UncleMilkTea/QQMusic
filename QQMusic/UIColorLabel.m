
//
//  UIColorLabel.m
//  QQMusic
//
//  Created by 侯玉昆 on 16/4/10.
//  Copyright © 2016年 suger. All rights reserved.
//

#import "UIColorLabel.h"

@implementation UIColorLabel

-  (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    //这必须self调用
    [self.currentColor set];
    //颜色进度
    rect.size.width *= _progress;
    
    //画颜色
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}
//设置默认值
- (UIColor *)currentColor{
    
    if (!_currentColor) {
        
        _currentColor = [UIColor greenColor];
    }
    return _currentColor;
}

- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    
    [self setNeedsDisplay];
    
}
@end
