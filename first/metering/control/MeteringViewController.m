//
//  MeteringViewController.m
//  first
//
//  Created by HS on 16/5/20.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "MeteringViewController.h"
#import "MeteringSingleViewController.h"
#import "SingleViewController.h"

@interface MeteringViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    //判断是大表还是小表
    BOOL isBitMeter;
}
@property (nonatomic, assign) NSInteger num;
@end

@implementation MeteringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    
    isBitMeter = YES;
    _num = 5;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _createTableView];
}

- (void)_createTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
}

//初始化加载storyboard
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"Metering" bundle:nil] instantiateViewControllerWithIdentifier:@"Metering"];
    }
    return self;
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isBitMeter) {
        
        MeteringSingleViewController *meteringVC = [[MeteringSingleViewController alloc] init];
        meteringVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController showViewController:meteringVC sender:nil];
    }
    else
    {
        SingleViewController *singleVC = [[SingleViewController alloc] init];
        singleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController showViewController:singleVC sender:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (IBAction)meterTypecOntrol:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _num = 5;
            isBitMeter = YES;
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];

            break;
        case 1:
            _num = 10;
            isBitMeter = NO;
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
        default:
            break;
    }
    
}
@end
