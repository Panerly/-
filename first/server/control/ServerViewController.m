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
    
    [self _createBtn];
}
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self = [[UIStoryboard storyboardWithName:@"Server" bundle:nil] instantiateViewControllerWithIdentifier:@"server"];
//    }
//    return self;
//}

- (void)_createBtn
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = self.view.frame.size.width/6+15;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型;
    
    NSArray *titleArr = @[@"水费缴纳",@"意见建议",@"帮助说明",@"保修求助",@"服务热线"];
    NSArray *imageArr = @[@"waterCharg",@"suggestions",@"explain",@"help",@"call_icon"];
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < titleArr.count-i-j; j++) {
            
            button = [[UIButton alloc] initWithFrame:CGRectMake(PanScreenWidth/2 * i + PanScreenWidth/8, width *(j+1) + (j*40), width, width)];

            [button setBackgroundImage:[UIImage imageNamed:imageArr[i+j+j]] forState:UIControlStateNormal];
            
            //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
            //    [button setImage:[UIImage imageNamed:@"his"] forState:UIControlStateNormal];//给button添加image
            button.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,button.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            [button setTitle:titleArr[i+j+j] forState:UIControlStateNormal];//设置button的title
            button.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
            button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
            button.titleEdgeInsets = UIEdgeInsetsMake(110, -button.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
            
            button.tag = 200+i+j+j;
            
            [button addTarget:self action:@selector(waterCharge:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:button];
        }
        
    }
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
