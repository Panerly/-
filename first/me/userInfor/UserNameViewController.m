//
//  UserNameViewController.m
//  单读
//
//  Created by Macx on 16/2/13.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "UserNameViewController.h"

@interface UserNameViewController () {
    UITextView *text;
    NSUserDefaults *defaults;
}

@end

@implementation UserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];

    self.navigationItem.rightBarButtonItem = saveBtn;
    
    //让顶部不留空白
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:242/255.0 alpha:1];
    
    text = [[UITextView alloc] initWithFrame:CGRectMake(10, 84, PanScreenWidth - 20, 200)];
    
    text.tag = 100;
    
    [self.view addSubview:text];
    
    self.view.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save {
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:text.text forKey:@"userNameValue"];
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
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
