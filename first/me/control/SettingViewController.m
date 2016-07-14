//
//  SettingViewController.m
//  first
//
//  Created by HS on 16/5/20.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "UIImageView+WebCache.h"


@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *identy;
    NSString *userIdenty;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _createTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}

- (void)_createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PanScreenWidth, PanScreenHeight) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    userIdenty = @"userIdenty";
    identy = @"logoutIdenty";
    
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}


#pragma UITableView DataSource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"账户设置";
    }
    else if (section == 1) {
        return @"";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:userIdenty];

    userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        if (!userCell) {
            
            userCell = [[[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil] lastObject];
            
        }
        
        return userCell;
    }

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1 && indexPath.row == 0) {
//        NSUInteger fileSize = [[SDImageCache sharedImageCache] getSize];
//        cell.textLabel.text = [NSString stringWithFormat:@"点击清理      %.1fM",fileSize / 1024.0 / 1024.0];
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
        
        [self.navigationController showViewController:userInfoVC sender:nil];
    }
//    if (indexPath.row == 1 && indexPath.row == 0) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清理缓存" message:@"是否清理缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.delegate = self;
//        [alert show];
//        [tableView cellForRowAtIndexPath:indexPath].selected = NO;
//        
//    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.flag = 1;
        [self presentViewController:loginVC animated:YES completion:nil];
        loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        [[SDImageCache sharedImageCache]clearDisk];
////        [self countCatchSize];
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}
@end
