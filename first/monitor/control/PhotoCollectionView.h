//
//  PhotoCollectionView.h
//  HWMtime
//
//  Created by mac on 15/11/6.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,copy) NSArray *imageURL;
@end
