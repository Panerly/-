//
//  PhotoCollectionView.m
//  HWMtime
//
//  Created by mac on 15/11/6.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "PhotoCollectionViewCell.h"
#define identify @"PhotoCell"

@implementation PhotoCollectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(PanScreenWidth, PanScreenHeight - 64);
//    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:identify];
    }
    return self;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *CollectionCell = (PhotoCollectionViewCell *)cell;
    [CollectionCell.scroll setZoomScale:1.0 animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageURL.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.imgurl = _imageURL[indexPath.item];
//    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main"]];
    return cell;
}

@end
