//
//  MonitorViewController.m
//  first
//
//  Created by HS on 16/5/20.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "MonitorViewController.h"
#import "CurrentReceiveViewController.h"
#import "MeterDataViewController.h"


@interface MonitorViewController ()

@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _createButton];
}

- (void)_createButton
{
//    CGFloat width = self.view.frame.size.width/6+15;
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型;
//    
//    NSArray *titleArr = @[@"实时抄见",@"历史抄见",@"水表数据",@"水表修改",@"用水核算",@"用量查询",@"使用帮助"];
//    NSArray *imageArr = @[@"now",@"his",@"message",@"edit",@"meter",@"dos",@"userhelp"];
//
//    for (int i = 0; i < 4; i++) {
//        
//        button = [[UIButton alloc] initWithFrame:CGRectMake(PanScreenWidth/4 * i+10, width, width, width)];
//        
//        [button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
//        
//        //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
//        //    [button setImage:[UIImage imageNamed:@"his"] forState:UIControlStateNormal];//给button添加image
//        button.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,button.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
//        
//        [button setTitle:titleArr[i] forState:UIControlStateNormal];//设置button的title
//        button.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
//        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
//        button.titleEdgeInsets = UIEdgeInsetsMake(100, -button.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
//  
//        button.tag = 100 + i;
//        
//        [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
//
//        [self.view addSubview:button];
//        
//    }
    
    
//    NSArray *titleArr = @[@"实时抄见",@"历史抄见",@"水表数据",@"水表修改"];
    NSArray *imageArr = @[@"now",@"his",@"message",@"edit"];
    
//    UIButton *button;
//    UILabel *label;
    
//    for (int i = 0; i < titleArr.count; i++) {
//        button = [[UIButton alloc] init];
//        button.tag = 100 + i;
//        [button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
//        [self.view addSubview:button];
//        [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        label = [[UILabel alloc] init];
//        label.text = titleArr[i];
//        [self.view addSubview:label];
//    }
//    if (button.tag == 100) {
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.view.centerX).with.offset(20);
//            make.top.equalTo(self.view.top).with.offset(20);
//            make.size.equalTo(CGSizeMake(60, 60));
//        }];
//    } else if (button.tag == 101) {
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view.centerX).with.offset(20);
//            make.top.equalTo(self.view.top).with.offset(20);
//            make.size.equalTo(CGSizeMake(60, 60));
//        }];
//    }
//    else if (button.tag == 102) {
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.view.centerX).with.offset(20);
//            make.top.equalTo(self.view.top).with.offset(100);
//            make.size.equalTo(CGSizeMake(60, 60));
//        }];
//    }
    UIButton *currentBtn = [[UIButton alloc] init];
    currentBtn.tag = 100;
    [currentBtn setBackgroundImage:[UIImage imageNamed:imageArr[0]] forState:UIControlStateNormal];
    [self.view addSubview:currentBtn];
    [currentBtn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [currentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.centerX).offset(-40-10);
        make.top.equalTo(self.view.mas_top).with.offset(84);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    UILabel *currLabel = [[UILabel alloc] init];
    currLabel.text = @"实时抄见";
    [self.view addSubview:currLabel];
    currLabel.textAlignment = NSTextAlignmentCenter;
    [currLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.centerX).offset(-40-10);
        make.top.equalTo(currentBtn.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(80, 25));
    }];
    
    UIButton *hisBtn = [[UIButton alloc] init];
    hisBtn.tag = 101;
    [hisBtn setBackgroundImage:[UIImage imageNamed:imageArr[1]] forState:UIControlStateNormal];
    [self.view addSubview:hisBtn];
    [hisBtn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [hisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(40+10);
        make.top.equalTo(self.view.mas_top).with.offset(84);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    UILabel *hisLabel = [[UILabel alloc] init];
    hisLabel.text = @"历史抄见";
    [self.view addSubview:hisLabel];
    hisLabel.textAlignment = NSTextAlignmentCenter;
    [hisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(40+10);
        make.top.equalTo(hisBtn.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(80, 25));
    }];
    
    UIButton *meterData = [[UIButton alloc] init];
    meterData.tag = 102;
    [meterData setBackgroundImage:[UIImage imageNamed:imageArr[2]] forState:UIControlStateNormal];
    [self.view addSubview:meterData];
    [meterData addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [meterData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.centerX).offset(-40-10);
        make.top.equalTo(currentBtn.mas_bottom).with.offset(50);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    UILabel *meterDataLabel = [[UILabel alloc] init];
    meterDataLabel.text = @"水表数据";
    [self.view addSubview:meterDataLabel];
    meterDataLabel.textAlignment = NSTextAlignmentCenter;
    [meterDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.centerX).offset(-40-10);
        make.top.equalTo(meterData.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(80, 25));
    }];
    
    UIButton *editBtn = [[UIButton alloc] init];
    editBtn.tag = 103;
    [editBtn setBackgroundImage:[UIImage imageNamed:imageArr[3]] forState:UIControlStateNormal];
    [self.view addSubview:editBtn];
    [editBtn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(40+10);
        make.top.equalTo(hisBtn.mas_bottom).with.offset(50);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    UILabel *editLabel = [[UILabel alloc] init];
    editLabel.text = @"水表修改";
    [self.view addSubview:editLabel];
    editLabel.textAlignment = NSTextAlignmentCenter;
    [editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(40+10);
        make.top.equalTo(editBtn.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(80, 25));
    }];
}

- (void)clicked:(UIButton *)sender
{
    CurrentReceiveViewController *currentReceiveVC = [[CurrentReceiveViewController alloc] init];
    MeterDataViewController *dataVC = [[MeterDataViewController alloc] init];
    
    switch (sender.tag) {
            
            case 100:
            currentReceiveVC.isRealTimeOrHis = 0;
            [self.navigationController showViewController:currentReceiveVC sender:nil];
            
            break;
            
            case 101:
            currentReceiveVC.isRealTimeOrHis = 1;
//            currentReceiveVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:currentReceiveVC sender:nil];
            
            break;
            case 102:
            
            [self.navigationController showViewController:dataVC sender:nil];
            
            break;
            case 103:
            currentReceiveVC.isRealTimeOrHis = 2;
//            currentReceiveVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:currentReceiveVC sender:nil];
            
            break;
            
        default:
            break;
    }
}

//从storyboard加载
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self  = [[UIStoryboard storyboardWithName:@"Monitor" bundle:nil] instantiateViewControllerWithIdentifier:@"Monitor"];
//    }
//    return self;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}
@end
