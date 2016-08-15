//
//  LitMeterDetailViewController.m
//  first
//
//  Created by HS on 16/8/15.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "LitMeterDetailViewController.h"

@interface LitMeterDetailViewController ()

@end

@implementation LitMeterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"小表户表信息";
    self.view.backgroundColor = [UIColor colorWithRed:44/255.0f green:147/255.0f blue:209/255.0f alpha:1];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, PanScreenHeight - 49 - 20, 100, 35)];
    saveBtn.backgroundColor = [UIColor colorWithRed:121/255.0f green:180/255.0f blue:76/255.0f alpha:1];
    saveBtn.layer.cornerRadius = 10;
    saveBtn.layer.shadowOffset = CGSizeMake(1, 1);
    saveBtn.layer.shadowColor = [[UIColor blackColor]CGColor];
    saveBtn.layer.shadowOpacity = .80f;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:saveBtn];
}

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
