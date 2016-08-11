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
    UIButton *litButton;
    NSMutableArray *arr;
    NSMutableArray *litBtnArr;
    UIWebView *_webView;
    UIImageView *loading;
    UISegmentedControl *segmentedCtl;
}
@property (nonatomic, strong) BHInfiniteScrollView* infinitePageView;
@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_server.jpg"]];
    
    [self setSegmentedCtl];
}
- (void)setSegmentedCtl {
    segmentedCtl = [[UISegmentedControl alloc] initWithItems:@[@"大表监测",@"小表监测"]];
    segmentedCtl.frame = CGRectMake(0, 0, PanScreenWidth/3, 30);
    [segmentedCtl addTarget:self action:@selector(transMeters:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedCtl;
    segmentedCtl.selectedSegmentIndex = 0;
}

//选择大表还是小表
- (void)transMeters:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {//大表监测平台
        //移除小表
        for (int j = 200; j < 204; j++) {
            
            [((UIButton *)litBtnArr[j-200]) removeFromSuperview];
            
//            CGFloat duration = (j - 199) * 0.2;
//            [UIView animateWithDuration:duration animations:^{
//                
//                ((UIButton *)litBtnArr[j-200]).center = self.view.center;
//                
//            } completion:^(BOOL finished) {
//                
//                [((UIButton *)litBtnArr[j-200]) removeFromSuperview];
//                if (j == 203) {
//                    
//                }
//            }];
        }
        //添加大表及滚动视图
        [self _createButton];
        [self _createPicPlay];
        
        
        for (int i = 100; i < 104; i++) {
            
            ((UIButton *)arr[i-100]).transform = CGAffineTransformMakeScale(.01, .01);
        }
        
        for (int i = 100; i < 104; i++) {
            
            CGFloat duration = (i - 99) * 0.2;
            
            [UIView animateWithDuration:duration animations:^{
                
                ((UIButton *)arr[i-100]).transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
            }];
        }

        
    } else {//小表监测平台
        
        if (_webView) {//webView没关的话退出
            [self backAction];
        }
        
        //移除大表btn以及滚动视图
        for (int i = 100; i < 104; i++) {
            
            [UIView animateWithDuration:.5 animations:^{
                
                switch (i) {
                    case 100:
                        ((UIButton *)arr[i-100]).frame = CGRectMake(0, 0, 10, 10);
                        break;
                    case 101:
                        ((UIButton *)arr[i-100]).frame = CGRectMake(0, PanScreenHeight, 10, 10);
                        break;
                    case 102:
                        ((UIButton *)arr[i-100]).frame = CGRectMake(PanScreenWidth, 0, 10, 10);
                        break;
                    case 103:
                        ((UIButton *)arr[i-100]).frame = CGRectMake(PanScreenWidth, PanScreenHeight, 10, 10);
                        break;
                        
                    default:
                        break;
                }
                
                _infinitePageView.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height/3, PanScreenWidth, [UIScreen mainScreen].bounds.size.height/3);
                
            } completion:^(BOOL finished) {
                
                [(UIButton *)arr[i-100] removeFromSuperview];
                [_infinitePageView removeFromSuperview];
                _infinitePageView = nil;
                
            }];
        }
        
        //创建小表btn并添加animation
        [self createLitBtn];
        for (int j = 200; j < 204; j++) {
            switch (j) {
                case 200:
                    ((UIButton *)litBtnArr[j-200]).transform = CGAffineTransformMakeTranslation(-PanScreenWidth/4, 0);
                    break;
                case 201:
                    ((UIButton *)litBtnArr[j-200]).transform = CGAffineTransformMakeTranslation(-PanScreenWidth/4, 0);
                    break;
                case 202:
                    ((UIButton *)litBtnArr[j-200]).transform = CGAffineTransformMakeTranslation(0, -PanScreenWidth/4);
                    break;
                case 203:
                    ((UIButton *)litBtnArr[j-200]).transform = CGAffineTransformMakeTranslation(0, -PanScreenWidth/4);
                    break;
                    
                default:
                    break;
            }
        }
        
        [UIView animateWithDuration:.5 animations:^{
            
            for (int j = 200; j < 204; j++) {
                
                ((UIButton *)litBtnArr[j-200]).transform = CGAffineTransformIdentity;
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    if (!button) {
    
        [self _createButton];
    }
    [self _createPicPlay];

    for (int i = 100; i < 104; i++) {
        
        ((UIButton *)arr[i-100]).transform = CGAffineTransformMakeScale(.01, .01);
    }
    
    for (int i = 100; i < 104; i++) {
        
        CGFloat duration = (i - 99) * 0.2;
        
        [UIView animateWithDuration:duration animations:^{
            
            ((UIButton *)arr[i-100]).transform = CGAffineTransformIdentity;

        } completion:^(BOOL finished) {

        }];
    }
    
}

//轮播图
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
    if (!_infinitePageView) {
        
        _infinitePageView = [BHInfiniteScrollView infiniteScrollViewWithFrame:CGRectMake(0, 49, PanScreenWidth, viewHeight) Delegate:self ImagesArray:urlsArray PlageHolderImage:[UIImage imageNamed:@"bg_weather3.jpg"] InfiniteLoop:YES];
        
    }
    _infinitePageView.dotSize = 10;
    _infinitePageView.pageControlAlignmentOffset = CGSizeMake(0, 10);
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
//webview返回btn
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

#pragma mark - UIWebViewdelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //刷新控件
    loading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    loading.center = self.view.center;
    
    UIImage *image = [UIImage sd_animatedGIFNamed:@"刷新1"];
    [loading setImage:image];
    [self.view addSubview:loading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SCToastView showInView:_webView text:@"加载失败！请稍后重试" duration:2.0f autoHide:YES];
    [loading removeFromSuperview];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loading removeFromSuperview];
}

//大表监测平台btn
- (void)_createButton
{
    CGFloat width = self.view.frame.size.width/5+15;

    button = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型;
    arr = [[NSMutableArray alloc] init];
    [arr removeAllObjects];
    
    NSArray *titleArr = @[@"实时抄见",@"历史抄见",@"水表数据",@"水表修改"];
    NSArray *imageArr = @[@"now",@"his",@"message",@"edit"];
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

//小表监测平台btn
- (void)createLitBtn
{
    CGFloat width = PanScreenWidth/5;
    
    litButton = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型;
    
    litBtnArr = [[NSMutableArray alloc] init];
    [litBtnArr removeAllObjects];
    
    NSArray *titleArr = @[@"用户浏览",@"日盘点",@"光电直读",@"数据交换"];
    NSArray *imageArr = @[@"userScan",@"日盘点",@"光电直读",@"数据交换"];
    
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height/5;
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            
            litButton = [[UIButton alloc] initWithFrame:CGRectMake(PanScreenWidth/2 * i + PanScreenWidth/8, width * j+ j*50+viewHeight-15, width, width)];
            
            [litButton setBackgroundImage:[UIImage imageNamed:imageArr[i+i+j]] forState:UIControlStateNormal];
            litButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,button.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            [litButton setTitle:titleArr[i+i+j] forState:UIControlStateNormal];//设置button的title
            litButton.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
            litButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
            [litButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
            [litButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
            litButton.titleEdgeInsets = UIEdgeInsetsMake(110, -button.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
            
            litButton.tag = 200 + i+j+i;
            
            [litBtnArr addObject:litButton];
            
            [litButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:litButton];
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
