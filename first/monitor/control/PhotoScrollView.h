//
//  PhotoScrollView.h
//  HWMtime
//
//  Created by mac on 15/11/6.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) UIImageView *imgView;
@end
