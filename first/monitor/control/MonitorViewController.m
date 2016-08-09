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
#import "IntroductionViewController.h"
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

@interface MonitorViewController ()<BHInfiniteScrollViewDelegate, UIWebViewDelegate>
{
    UIButton *button;
    NSMutableArray *arr;
    UIWebView *_webView;
    UIImageView *loading;
}
@property (nonatomic, strong) BHInfiniteScrollView* infinitePageView;
@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:231.0f/255 green:231.0f/255 blue:231.0f/255 alpha:1];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_server.jpg"]];

//    [self _createScrollView];
//    [self _createButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!button) {
        
        [self _createButton];
    }
    
    [self _createPicPlay];

    for (int i = 100; i < 104; i++) {
        
        ((UIButton *)arr[i-100]).transform = CGAffineTransformMakeScale(.1, .1);
    }
    
    for (int i = 100; i < 104; i++) {
        
        CGFloat duration = (i - 99) * 0.2;
        
        [UIView animateWithDuration:duration animations:^{
            
            ((UIButton *)arr[i-100]).transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (void)_createPicPlay
{
    NSArray* urlsArray = @[
                           @"http://60.191.39.206:8000/waterweb/IMAGE/homeimage1.png",
                           @"http://60.191.39.206:8000/waterweb/IMAGE/homeimage2.png",
                           @"http://60.191.39.206:8000/waterweb/IMAGE/homeimage3.png",
                           @"http://60.191.39.206:8000/waterweb/IMAGE/homeimage4.png",
                           ];
//    NSArray *titleArray = @[@"第一张",@"第二张",@"第三张",@"第四章",@"第五章"];
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height/3;
    
    _infinitePageView = [BHInfiniteScrollView infiniteScrollViewWithFrame:CGRectMake(0, 49, PanScreenWidth, viewHeight) Delegate:self ImagesArray:urlsArray PlageHolderImage:[UIImage imageNamed:@"bg_weather3.jpg"] InfiniteLoop:YES];
    _infinitePageView.dotSize = 10;
    _infinitePageView.pageControlAlignmentOffset = CGSizeMake(0, 10);
//    _infinitePageView.dotColor = [UIColor colorWithRed:91.0f green:154.0f blue:227.0f alpha:.9];
    _infinitePageView.selectedDotColor = [UIColor colorWithRed:91.0f/255 green:154.0f/255 blue:227.0f/255 alpha:.9];
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
    UIButton *backBtn;
    if (index == 0) {
        if (!_webView) {
            
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, PanScreenWidth, PanScreenHeight-64)];
            _webView.delegate = self;
            backBtn = [[UIButton alloc] init];
        }
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:introduction]]];
        backBtn.tintColor = [UIColor redColor];
        [backBtn setImage:[UIImage imageNamed:@"close@2x"] forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_webView addSubview:backBtn];
        _webView.transform = CGAffineTransformMakeScale(.01, .01);
        [UIView animateWithDuration:.3 animations:^{
            _webView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];

        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_webView.mas_left);
            make.top.equalTo(_webView.mas_top);
            make.size.equalTo(CGSizeMake(50, 50));
        }];
        
        UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
        [_webView addGestureRecognizer:gesture];
        
        [self.view addSubview:_webView];
    } else {
    IntroductionViewController *intrVC = [[IntroductionViewController alloc] init];
    [self.navigationController showViewController:intrVC sender:nil];
    }
}

- (void)backAction
{
    [UIView animateWithDuration:.3 animations:^{
        _webView.transform = CGAffineTransformMakeScale(.01, .01);
        loading.transform = CGAffineTransformMakeScale(.01, .01);
    } completion:^(BOOL finished) {
        [_webView removeFromSuperview];
        [loading removeFromSuperview];
    }];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //刷新控件
    
    loading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    loading.center = self.view.center;
    
    UIImage *image = [UIImage sd_animatedGIFNamed:@"刷新1"];
    [loading setImage:image];
    [self.view addSubview:loading];
}
#pragma mark - UIWebViewdelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SCToastView showInView:_webView text:@"加载失败！请稍后重试" duration:2.0f autoHide:YES];
    [loading removeFromSuperview];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loading removeFromSuperview];
}


- (void)_createButton
{
    CGFloat width = self.view.frame.size.width/5+15;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型;
    
    arr = [[NSMutableArray alloc] init];
    
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
            
            [arr addObject:button];
            
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
