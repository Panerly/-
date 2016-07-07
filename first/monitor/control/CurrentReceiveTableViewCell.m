//
//  CurrentReceiveTableViewCell.m
//  first
//
//  Created by HS on 16/6/14.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "CurrentReceiveTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GuideViewController.h"
#import "PhotoViewController.h"
#import "CurrentReceiveViewController.h"

@implementation CurrentReceiveTableViewCell

- (void)awakeFromNib {
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _userName.text = self.CRModel.meter_name;
//    x = self.CRModel
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)naviButton:(id)sender {

    GuideViewController *guideVC = [[GuideViewController alloc] init];
    
    [[self findVC].navigationController showViewController:guideVC sender:nil];
}

- (UIViewController *)findVC
{
    UIResponder *next = self.nextResponder;
    
    while (1) {
        
        if ([next isKindOfClass:[UIViewController class]]) {
           return  (UIViewController *)next;
        }
          next =  next.nextResponder;
    }
    return nil;
}
- (IBAction)scenePhotos:(id)sender {
    PhotoViewController *showImageVC = [[PhotoViewController alloc] init];
    [[self findVC].navigationController showViewController:showImageVC sender:nil];
}
@end
