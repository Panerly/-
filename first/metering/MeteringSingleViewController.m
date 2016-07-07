//
//  MeteringSingleViewController.m
//  first
//
//  Created by HS on 16/6/22.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "MeteringSingleViewController.h"
#import "SingleViewController.h"

@interface MeteringSingleViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MeteringSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"任务详情";
    
    [self _createTableView];
}
- (void)_createTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"    杭州水表有限公司";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleViewController *singleVC = [[SingleViewController alloc] init];
//    [self.navigationController showViewController:singleVC sender:nil];
    singleVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:singleVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
