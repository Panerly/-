//
//  GuideViewController.m
//  first
//
//  Created by HS on 16/6/15.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"导航";
    self.view.backgroundColor = PanRandomColor;
    
    [self locationCurrentCity];
    
//    CLLocationCoordinate2D coor;
//
//    //传入 城市 、 起点 和 终点，城市的起点至终点导航！
//    [MapNavigationManager showSheetWithCity:@"杭州" start:@"120.35" end:@"30.29"];
//    //经纬度模式
//    //传入经纬度 —— 当前位置 至 经纬度所在位置
//    [MapNavigationManager showSheetWithCoordinate2D:coor];
}


- (void)locationCurrentCity
{
    //检测定位功能是否开启
    if([CLLocationManager locationServicesEnabled]){
        if(!_locationManager){
            self.locationManager = [[CLLocationManager alloc] init];
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
            //设置代理
            self.locationManager.delegate = self;
            //设置定位精度
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //设置距离筛选
            [self.locationManager setDistanceFilter:5.0];
            //开始定位
            [self.locationManager startUpdatingLocation];
            //设置开始识别方向
            [self.locationManager startUpdatingHeading];
        }
    }else{
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"定位信息" message:@"您没有开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }
}

#pragma mark - CLLocationManangerDelegate
//定位成功以后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation* location = locations.lastObject;
    [self reverseGeocoder:location];
}

#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);

        }else{
            CLPlacemark* placemark = placemarks.firstObject;
            NSLog(@"经度:%@   纬度%@",[[placemark addressDictionary] objectForKey:@"lat"],[[placemark addressDictionary] objectForKey:@"lng"]);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"你的位置" message:[[placemark addressDictionary] objectForKey:@"City"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:^{
                
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
