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
#import "BHInfiniteScrollView.h"
//typedef enum : NSUInteger {
//    Fade = 1,                   //淡入淡出
//    Push,                       //推挤
//    Reveal,                     //揭开
//    MoveIn,                     //覆盖
//    Cube,                       //立方体
//    SuckEffect,                 //吮吸
//    OglFlip,                    //翻转
//    RippleEffect,               //波纹
//    PageCurl,                   //翻页
//    PageUnCurl,                 //反翻页
//    CameraIrisHollowOpen,       //开镜头
//    CameraIrisHollowClose,      //关镜头
//    CurlDown,                   //下翻页
//    CurlUp,                     //上翻页
//    FlipFromLeft,               //左翻转
//    FlipFromRight,              //右翻转
//    
//} AnimationType;

@interface MonitorViewController ()<BHInfiniteScrollViewDelegate>
{
    
}
@property (nonatomic, strong) BHInfiniteScrollView* infinitePageView;
@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:231.0f/255 green:231.0f/255 blue:231.0f/255 alpha:1];

//    [self _createScrollView];
    
    
    [self _createButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self _createPicPlay];
}

- (void)_createPicPlay
{
    NSArray* urlsArray = @[
                           @"http://192.168.3.170:8080/waterweb/IMAGE/homeimage1.png",
                           @"http://192.168.3.170:8080/waterweb/IMAGE/homeimage2.png",
                           @"http://192.168.3.170:8080/waterweb/IMAGE/homeimage3.png",
                           @"http://192.168.3.170:8080/waterweb/IMAGE/homeimage4.png",
                           ];
//    NSArray *titleArray = @[@"第一张",@"第二张",@"第三张",@"第四章",@"第五章"];
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height/3;
    
    _infinitePageView = [BHInfiniteScrollView infiniteScrollViewWithFrame:CGRectMake(0, 49, PanScreenWidth, viewHeight) Delegate:self ImagesArray:urlsArray PlageHolderImage:[UIImage imageNamed:@"bg_weather3.jpg"] InfiniteLoop:YES];
    _infinitePageView.dotSize = 10;
    _infinitePageView.pageControlAlignmentOffset = CGSizeMake(0, 10);
//    _infinitePageView.dotColor = [UIColor colorWithRed:91.0f green:154.0f blue:227.0f alpha:.9];
    _infinitePageView.selectedDotColor = [UIColor blueColor];
//    infinitePageView.titleView.textColor = [UIColor whiteColor];
//    infinitePageView.titleView.margin = 30;
//    infinitePageView.titleView.hidden = YES;
//    infinitePageView.titlesArray = titleArray;
    _infinitePageView.scrollTimeInterval = 2;
    _infinitePageView.autoScrollToNextPage = YES;
    _infinitePageView.delegate = self;
    [self.view addSubview:_infinitePageView];
    [self performSelector:@selector(stop) withObject:nil afterDelay:5];
    [self performSelector:@selector(start) withObject:nil afterDelay:10];
}

- (void)stop {
    [_infinitePageView stopAutoScrollPage];
}

- (void)start {
    [_infinitePageView startAutoScrollPage];
}
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger)index {
}
//点击图片做出的响应
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}


- (void)_createButton
{
    CGFloat width = self.view.frame.size.width/5+15;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型;

    NSArray *titleArr = @[@"实时抄见",@"历史抄见",@"水表数据",@"水表修改",@"用水核算",@"用量查询",@"使用帮助"];
    NSArray *imageArr = @[@"now",@"his",@"message",@"edit",@"meter",@"dos",@"userhelp"];
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height/3;
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            if (j == 0) {
                button = [[UIButton alloc] initWithFrame:CGRectMake(PanScreenWidth/2 * i + PanScreenWidth/8, 59 + viewHeight, width, width)];
            } else
            button = [[UIButton alloc] initWithFrame:CGRectMake(PanScreenWidth/2 * i + PanScreenWidth/8, width * (j+1) + j*35+viewHeight-15, width, width)];
            
            [button setBackgroundImage:[UIImage imageNamed:imageArr[i+i+j]] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,button.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            [button setTitle:titleArr[i+i+j] forState:UIControlStateNormal];//设置button的title
            button.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
            button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
            button.titleEdgeInsets = UIEdgeInsetsMake(110, -button.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
            
            button.tag = 100 + i+j+i;
            
            [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:button];
        }
        
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}
@end
