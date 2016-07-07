//
//  PhotoScrollView.m
//  HWMtime
//
//  Created by mac on 15/11/6.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PhotoScrollView.h"
#import "UIImageView+WebCache.h"

@implementation PhotoScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        self.delegate = self;
        [self addSubview:_imgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
        tap2.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:tap2];
        [tap requireGestureRecognizerToFail:tap2];

        
    }
    return self;
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationCenter" object:nil];
}
-(void)tap2:(UITapGestureRecognizer *)tap
{
    if (self.zoomScale > 1) {
        [self setZoomScale:1.0 animated:YES];
    }
    else if(self.zoomScale == 1)
    {
        [self setZoomScale:3.0 animated:YES];
    }
}



- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}

-(void)setUrl:(NSURL *)url
{
    if (_url != url) {
        _url = url;
        [_imgView sd_setImageWithURL:_url];
    }
}


@end
