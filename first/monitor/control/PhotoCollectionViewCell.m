//
//  PhotoCollectionViewCell.m
//  HWMtime
//
//  Created by mac on 15/11/6.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatScoller];
    }
    return self;
}

-(void)awakeFromNib
{
    [self creatScoller];
}

-(void)creatScoller
{
    _scroll = [[PhotoScrollView alloc]initWithFrame:self.bounds];
    [self addSubview:_scroll];
}

-(void)setImgurl:(NSString *)imgurl
{
    if (_imgurl != imgurl) {
        _imgurl = imgurl;
        _scroll.url = [NSURL URLWithString:_imgurl];
    }
}
@end
