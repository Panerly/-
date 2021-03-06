//
//  MeterInfoTableViewCell.m
//  first
//
//  Created by HS on 16/8/10.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "MeterInfoTableViewCell.h"

@implementation MeterInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.area.text = _meterInfoModel.install_Addr;
    
    _x = self.meterInfoModel.x;
    _y = self.meterInfoModel.y;
}

- (IBAction)naviBtn:(id)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"导航提示" message:[NSString stringWithFormat:@"导航前往 ‘%@’ ？",_area.text] preferredStyle:UIAlertControllerStyleAlert];
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
@end
