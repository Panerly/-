//
//  CurrentReceiveTableViewCell.m
//  first
//
//  Created by HS on 16/6/14.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "CurrentReceiveTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FirstCollectionViewController.h"
#import "CurrentReceiveViewController.h"

@implementation CurrentReceiveTableViewCell

- (void)awakeFromNib {
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _userName.text = self.CRModel.meter_name;
    _x = self.CRModel.x;
    _y = self.CRModel.y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)naviButton:(id)sender {

    NSLog(@"%@-----%@",_x,_y);
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"导航提示" message:[NSString stringWithFormat:@"导航前往 ‘%@’ ？",_userName.text] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *conf = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //检测定位功能是否开启
        if([CLLocationManager locationServicesEnabled]){
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([_y integerValue], [_x integerValue]);
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            
        }else{
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"定位信息" message:@"您没有开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertVC addAction:action];
            [[self findVC] presentViewController:alertVC animated:YES completion:^{
                
            }];
        }

    }];
    [alertVC addAction:cancel];
    [alertVC addAction:conf];
    [[self findVC] presentViewController:alertVC animated:YES completion:^{
        
    }];
    
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
    FirstCollectionViewController *showImageVC = [[FirstCollectionViewController alloc] init];
    [[self findVC].navigationController showViewController:showImageVC sender:nil];
}





@end
