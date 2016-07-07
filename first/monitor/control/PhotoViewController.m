//
//  PhotoViewController.m
//  Created by mac on 15/11/6.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionView.h"
#import "PhotoCollectionViewCell.h"
@interface PhotoViewController ()
{
    BOOL _isHide;
}
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PanRandomColor;
    
    self.title = @"照片浏览";
    
    PhotoCollectionView *collectionView = [[PhotoCollectionView alloc]initWithFrame:CGRectMake(0, 0, PanScreenWidth, PanScreenHeight)];
    
    collectionView.pagingEnabled = YES;
    
    collectionView.imageURL = _imageURL;
    
    [collectionView scrollToItemAtIndexPath:_indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self.view addSubview:collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickAction) name:@"notificationCenter" object:nil];
    
    _isHide = NO;
}

-(void)clickAction
{
    _isHide = !_isHide;
    [self.navigationController setNavigationBarHidden:_isHide animated:YES];
}

//-(void)buttonAction
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

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
