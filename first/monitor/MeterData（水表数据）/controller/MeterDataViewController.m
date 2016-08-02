//
//  MeterDataViewController.m
//  first
//
//  Created by HS on 16/6/27.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "MeterDataViewController.h"
#import "MeterDataTableViewCell.h"
#import "MeterDataModel.h"
#import "KSDatePicker.h"

@interface MeterDataViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *cellID;
    NSUserDefaults *defaults;
}
@end

@implementation MeterDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"水表数据";
    
    cellID = @"meterDataID";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _getUserInfo];
    
    [self _getSysTime];
    
    [self _setTableView];
    
    [self _createDatePicker];
}

- (void)_createDatePicker
{
    UIButton *buttonFrom = [[UIButton alloc] init];
    buttonFrom.backgroundColor = [UIColor clearColor];
    buttonFrom.tag = 100;
    [buttonFrom addTarget:self action:@selector(pick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonFrom];
    [buttonFrom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(35);
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.right.equalTo(self.view.centerY).with.offset(-150);
        make.height.equalTo(35);
    }];
    
    UIButton *buttonTo = [[UIButton alloc] init];
    buttonTo.backgroundColor = [UIColor clearColor];
    buttonTo.tag = 101;
    [buttonTo addTarget:self action:@selector(pick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTo];
    [buttonTo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.center.y);
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(35);
    }];
}
- (void)pick:(UIButton *)sender
{
    }

- (void)_setTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"MeterDataTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
}

- (void)_getSysTime
{
    //获取系统当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    self.fromDate.text = time;
    self.toDate.text = time;
}

- (void)_getUserInfo
{
    defaults = [NSUserDefaults standardUserDefaults];
    _userName = [defaults objectForKey:@"userName"];
    self.passWord = [defaults objectForKey:@"passWord"];
    self.ip = [defaults objectForKey:@"ip"];
    self.db = [defaults objectForKey:@"db"];
}

- (void)_requestData:(NSString *)fromDate :(NSString *)toDate :(NSString *)callerLabel
{
    
    if ([fromDate caseInsensitiveCompare:toDate]<=0) {
        
        [SVProgressHUD showWithStatus:@"加载中"];
        
        NSString *logInUrl = [NSString stringWithFormat:@"http://%@/waterweb/MessageServlet",self.ip];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        
        NSDictionary *parameters = @{@"username":self.userName,
                                     @"password":self.passWord,
                                     @"db":self.db,
                                     @"date1":fromDate,
                                     @"date2":toDate,
                                     @"calling_tele":callerLabel
                                     };
        
        AFHTTPResponseSerializer *serializer = manager.responseSerializer;
        
        serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        __weak typeof(self) weakSelf = self;
        
        NSURLSessionTask *task =[manager POST:logInUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            _dataArr = [NSMutableArray array];
            
            NSError *error = nil;
            
            if (responseObject) {
                
                [SVProgressHUD showInfoWithStatus:@"加载成功"];
                
                NSDictionary *dicResponse = [responseObject objectForKey:@"meters"];
                
                self.dataNum.text = [NSString stringWithFormat:@"数    量: %@",[responseObject objectForKey:@"count"]];
                
                for (NSDictionary *dic in dicResponse) {
                    
                    self.userNameLabel.text = [NSString stringWithFormat:@"用户名: %@",[dic objectForKey:@"user_name"]];
                    self.userNumLabel.text = [NSString stringWithFormat:@"用户号: %@",[dic objectForKey:@"meter_id"]];
                    
                    MeterDataModel *meterDataModel = [[MeterDataModel alloc] initWithDictionary:dic error:&error];
                    [_dataArr addObject:meterDataModel];
                }
                
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"加载失败:%@",error]];
            
        }];
        [task resume];
    } else {
        [SCToastView showInView:self.view text:@"错误的选择区间!" duration:1.5 autoHide:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.userNumLabel removeFromSuperview];
    [self.userNameLabel removeFromSuperview];
    [self.dataNum removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.userNumLabel removeFromSuperview];
    [self.userNameLabel removeFromSuperview];
    [self.dataNum removeFromSuperview];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeterDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeterDataTableViewCell" owner:self options:nil] lastObject];
    }
    cell.serialNum.text = [NSString stringWithFormat:@"%li",(long)indexPath.row];
    cell.serialNum.font = [UIFont systemFontOfSize:10];
    cell.serialNum.textColor = [UIColor redColor];
    cell.meterDataModel = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SCToastView showInView:self.view text:@"加载中" duration:0.5 autoHide:YES];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"水表数据" message:[NSString stringWithFormat:@"%@",((MeterDataModel *)_dataArr[indexPath.row]).message] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_callerLabel resignFirstResponder];
    [_fromDate resignFirstResponder];
    [_toDate resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}

- (IBAction)conformBtn:(id)sender {
    
    [_callerLabel resignFirstResponder];
    [_fromDate resignFirstResponder];
    [_toDate resignFirstResponder];
    [self _requestData:_fromDate.text :_toDate.text :_callerLabel.text];
}
- (IBAction)dateBtn:(UIButton *)sender {
    
    [_fromDate resignFirstResponder];
    [_toDate resignFirstResponder];
    
    KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 300)];
    
    picker.appearance.radius = 5;
    
    //设置回调
    picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
        
        if (buttonType == KSDatePickerButtonCommit) {
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            if (sender.tag == 100) {
                
                _fromDate.text = [formatter stringFromDate:currentDate];
            }else {
                _toDate.text = [formatter stringFromDate:currentDate];
            }
        }
    };
    // 显示
    [picker show];

}
@end
