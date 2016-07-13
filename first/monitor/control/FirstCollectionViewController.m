//
//  ImageBrowserCollectionViewController.m
//  first
//
//  Created by HS on 16/7/12.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "FirstCollectionViewController.h"
#import "CollectionViewCell.h"
#import "SecondViewController.h"
#import "MagicMoveTransition.h"

@interface FirstCollectionViewController ()<UINavigationControllerDelegate>

@end

@implementation FirstCollectionViewController

static NSString * const reuseIdentifier = @"CollectionCell";


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"ImageBrowser" bundle:nil] instantiateViewControllerWithIdentifier:@"firstCollectionID"];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.delegate = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    
    if ([toVC isKindOfClass:[SecondViewController class]]) {
        MagicMoveTransition *transition = [[MagicMoveTransition alloc]init];
        return transition;
    }else{
        return nil;
    }
}

#pragma mark <UICollectionViewDataSource>
//section的数目
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section Item的数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

//创建cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    collectionView.backgroundColor = [UIColor whiteColor];
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

@end
