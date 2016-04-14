//
//  NSDateFormatter + Extension.m
//  QQMusic
//
//  Created by 侯玉昆 on 16/4/7.
//  Copyright © 2016年 suger. All rights reserved.
//

#import "NSDateFormatter + Extension.h"

@implementation NSDateFormatter(shared)

+ (instancetype)sharedDateFormater{
    
    static NSDateFormatter *_dateForemater;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _dateForemater = [[self alloc]init];
        
    });
    
    return _dateForemater;
}

@end
