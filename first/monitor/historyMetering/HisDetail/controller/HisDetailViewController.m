//
//  HisDetailViewController.m
//  first
//
//  Created by HS on 16/6/24.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "HisDetailViewController.h"
#import "HisDetailTableViewCell.h"
#import "SCViewController.h"
#import "HisDetailModel.h"
#import "UIImage+GIF.h"

@interface HisDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *hisDetailID;
    NSUserDefaults *defaults;
    UIImageView *loading;
    NSInteger dataCount;
    UILabel *loadingLabel;
}
@end

@implementation HisDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史抄见·户表信息";
    self.dataArr = [NSMutableArray array];
    
    [self _getUserInfo];
    
    [self _getValue];
    
    [self _setTableView];
    
    self.xArr = [NSMutableArray array];
    self.yArr = [NSMutableArray array];
}

- (void)_getUserInfo
{
    defaults = [NSUserDefaults standardUserDefaults];
    self.userNameLabel = [defaults objectForKey:@"userName"];
    self.passWordLabel = [defaults objectForKey:@"passWord"];
    self.ipLabel = [defaults objectForKey:@"ip"];
    self.dbLabel = [defaults objectForKey:@"db"];
}


//请求时间段水表抄收数据
- (void)_requestData:(NSString *)fromTime :(NSString *)toTime
{
    
    //刷新控件
    
    loading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    loading.center = self.view.center;
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(PanScreenWidth/2 - 60, PanScreenHeight/2 + 25, 150, 30)];
    loadingLabel.text = @"正在拼命加载中...";
    
    UIImage *image = [UIImage sd_animatedGIFNamed:@"刷新1"];
    [loading setImage:image];
    [self.view addSubview:loading];
    [self.view addSubview:loadingLabel];
    
    NSString *logInUrl = [NSString stringWithFormat:@"http://%@/waterweb/His5Servlet",self.ipLabel];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    NSDictionary *parameters = @{@"meter_id":self.hisDetailModel.meter_id,
                                 @"date1":fromTime,
                                 @"date2":toTime,
                                 @"username":self.userNameLabel,
                                 @"db":self.dbLabel,
                                 @"password":self.passWordLabel
                                 };
    
    AFHTTPResponseSerializer *serializer = manager.responseSerializer;
    
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            
            NSDictionary *meter1Dic = [responseObject objectForKey:@"meters"];
            dataCount = [[responseObject objectForKey:@"count"] integerValue];
//            NSError *error = nil;
            
            [self.dataArr removeAllObjects];
            
            for (NSDictionary *dic in meter1Dic) {
                
//                HisDetailModel *hisDetailModel = [[HisDetailModel alloc] initWithDictionary:dic error:&error];
//                [self.dataArr addObject:hisDetailModel];
                
                HisDetailModel *hisDetailModel = [[HisDetailModel alloc] init];
                hisDetailModel.collect_num = [dic objectForKey:@"collect_num"];
                hisDetailModel.collect_avg = [dic objectForKey:@"collect_avg"];
                hisDetailModel.collect_dt = [dic objectForKey:@"collect_dt"];
                
                [self.dataArr addObject:hisDetailModel];
                [_yArr addObject:hisDetailModel.collect_num];
            }
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
            [loading removeFromSuperview];
            [loadingLabel removeFromSuperview];
            _xArr = _dataArr;
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [loading removeFromSuperview];
        [loadingLabel removeFromSuperview];
    }];
    
    [task resume];
}
- (void)_getValue
{
    self.meter_id.text = [NSString stringWithFormat:@"用户号: %@",self.hisDetailModel.meter_id];
    self.meter_name.text = [NSString stringWithFormat:@"用户名: %@",self.hisDetailModel.meter_name];
    self.meter_name2.text = [NSString stringWithFormat:@"表类型: %@",self.hisDetailModel.meter_name2];
    self.meter_cali.text = [NSString stringWithFormat:@"表口径: %@",self.hisDetailModel.meter_cali];
}

- (void)_setTableView
{
    hisDetailID = @"HisDetailIdenty";
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.formDate resignFirstResponder];
    [self.toDate resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.formDate resignFirstResponder];
    [self.toDate resignFirstResponder];

}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HisDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hisDetailID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HisDetailTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.serialNum.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.hisDetailModel = _dataArr[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}

//确定搜索区间段内数据
- (IBAction)confirmBtn:(id)sender {
    
    [self.formDate resignFirstResponder];
    [self.toDate resignFirstResponder];
    
    [self _requestData:_formDate.text :_toDate.text];
}

- (IBAction)chartBtn:(id)sender {
    SCViewController *curveVC = [[SCViewController alloc] init];
    curveVC.xArr = _xArr;
    curveVC.yArr = _yArr;
    curveVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController showViewController:curveVC sender:nil];
}
@end
