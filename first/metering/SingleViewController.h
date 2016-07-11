//
//  SingleViewController.h
//  first
//
//  Created by HS on 16/6/22.
//  Copyright © 2016年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (IBAction)takePhoto:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)savePhoto:(id)sender;
- (IBAction)uploadPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *previousReading;
@property (weak, nonatomic) IBOutlet UITextField *previousSettle;
@property (weak, nonatomic) IBOutlet UITextField *thisPeriodValue;
@property (weak, nonatomic) IBOutlet UITextField *meteringSituation;
@property (weak, nonatomic) IBOutlet UITextField *meteringExplain;

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;

@property (nonatomic, strong) UIView *scanView;

@property (nonatomic, strong) NSString *ipLabel;

@property (nonatomic, strong) NSString *dbLabel;

@property (nonatomic, strong) NSString *userNameLabel;

@property (nonatomic, strong) NSString *passWordLabel;
@end
