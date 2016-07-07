//
//  ConfigViewController.m
//  first
//
//  Created by HS on 16/5/24.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "ConfigViewController.h"
//#import "LoginViewController.h"
//#import "KeychainItemWrapper.h"

@interface ConfigViewController ()
//{
//    KeychainItemWrapper *wrapper;
//}

@end

@implementation ConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self configKeyChainItemWrapper];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    self.IPConfig.text = [defaults objectForKey:@"ip"];
    self.DBConfig.text = [defaults objectForKey:@"db"];
}

//- (void)configKeyChainItemWrapper
//{
//    wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"IPNumber" accessGroup:@"hzsb.com.hzsbcop.pan"];
//    
//    //取出密码
//    self.IPConfig.text = [wrapper objectForKey:(id)kSecValueData];
//    
//    //取出账号
//    self.DBConfig.text = [wrapper objectForKey:(id)kSecAttrAccount];
//    
//    //清空设置
//    //    [wrapper resetKeychainItem];
//}



//从storyboard加载
- (instancetype)init
{
    self = [super init];
    if (self) {
        self  = [[UIStoryboard storyboardWithName:@"Config" bundle:nil] instantiateViewControllerWithIdentifier:@"Config"];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
////配置完成按钮
//- (IBAction)ConpleteBtn:(id)sender {
//    
////    ((LoginViewController *)self.nextResponder).ipLabel = self.IPConfig.text;
////    ((LoginViewController *)self.nextResponder).dbLabel = self.DBConfig.text;
//    
//
//    
//    
//}
- (IBAction)saveBtn:(id)sender {
    
    //保存账号
//    [wrapper setObject:self.DBConfig.text forKey:(id)kSecAttrAccount];
//    
//    //保存密码
//    [wrapper setObject:self.IPConfig.text forKey:(id)kSecValueData];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.IPConfig.text forKey:@"ip"];
    [defaults setObject:self.DBConfig.text forKey:@"db"];
    
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
@end
