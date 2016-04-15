//
//  MusicTableView.m
//  QQMusic
//
//  Created by 侯玉昆 on 16/4/14.
//  Copyright © 2016年 suger. All rights reserved.
//

#import "MusicTableView.h"
#import "Music.h"
#import "MJExtension.h"
#import "PlayManager.h"
#import "MusicTableViewCell.h"

@interface MusicTableView ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) NSArray *musicArray;

@property(strong,nonatomic) Music *model;

@end

@implementation MusicTableView 

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
   
    self.delegate = self;
    
    self.dataSource = self;
    
    self.rowHeight = 60;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.musicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"cell";
    
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        
        cell = [MusicTableViewCell initWithCell] ;
    }
    
    Music *model = self.musicArray[indexPath.row];
    
    cell.height = self.rowHeight;
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMusic" object:indexPath];
}

#pragma mark - 懒加载
- (NSArray *)musicArray{
    
    if (!_musicArray) {
        _musicArray = [Music objectArrayWithFilename:@"mlist.plist"];
    }
    return _musicArray;
}


@end
