//
//  ServerViewController.m
//  first
//
//  Created by HS on 16/5/20.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "ServerViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HelpViewController.h"

@interface ServerViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"Server" bundle:nil] instantiateViewControllerWithIdentifier:@"server"];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)waterCharge:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"该功能暂未推出，敬请期待^_^!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    HelpViewController *helpView = [[HelpViewController alloc] init];
    switch (sender.tag) {
            
        case 200:
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:^{
            }];
        break;
            
        case 201:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://76843918@qq.com"]];
        break;
            
        case 202:
            
            [self.navigationController showViewController:helpView sender:nil];
        break;
            
        case 203:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://15356167113"]];
        break;
            
        case 204:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001081616"]];
            break;
            
        default:
            break;
    }
}
@end
