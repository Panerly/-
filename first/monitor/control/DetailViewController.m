//
//  DetailViewController.m
//  first
//
//  Created by HS on 16/6/15.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "DetailViewController.h"
#import "QueryViewController.h"
#import "DetailModel.h"

@interface DetailViewController ()
{
    NSString *userNameLabel;
    NSString *passWordLabel;
    NSString *userName2;
    NSString *ipLabel;
    NSString *dbLabel;
}
@end

@implementation DetailViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _requestData];
    
    [self _setValue];
}
- (void)_setValue
{
    self.title = self.titleName;
//    self.netNum.text = [NSString stringWithFormat:@"网络编号:   %@", self.crModel.meter_name2];
    self.userNum.text = [NSString stringWithFormat:@"用户号:   %@", self.crModel.meter_id];
    self.meterNum.text = [NSString stringWithFormat:@"表位号:   %@", self.crModel.meter_id];
    self.userName.text = [NSString stringWithFormat:@"用户名:   %@", self.crModel.meter_name];
    self.userAddr.text = [NSString stringWithFormat:@"用户地址:   %@", self.crModel.meter_user_addr];
    self.caliber.text = [NSString stringWithFormat:@"口径:   %@", self.crModel.meter_cali];
    self.meterPhenoType.text = [NSString stringWithFormat:@"表类型:   %@",self.crModel.meter_name2];
    self.readingTime.text = [NSString stringWithFormat:@"抄表时间:   %@",self.crModel.collect_dt];
    self.degrees.text = [NSString stringWithFormat:@"抄见度数:   %@吨", self.crModel.collect_num];
}

- (void)_requestData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    userNameLabel = [defaults objectForKey:@"userName"];
    passWordLabel = [defaults objectForKey:@"passWord"];
    ipLabel = [defaults objectForKey:@"ip"];
    dbLabel = [defaults objectForKey:@"db"];
    userName2 = self.crModel.meter_id;
    
    NSString *logInUrl = [NSString stringWithFormat:@"http://%@/waterweb/servlet/JsonServlet",ipLabel];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    NSDictionary *parameters = @{
                                 @"username":userName2,
                                 @"password":passWordLabel,
                                 @"db":dbLabel,
                                 @"username2":userNameLabel
                                 };
    
    AFHTTPResponseSerializer *serializer = manager.responseSerializer;
    
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {

            NSDictionary *dic = [responseObject objectForKey:@"meter1"];
            
            self.netNum.text = [NSString stringWithFormat:@"网络编号:   %@", [dic objectForKey:@"comm_id"]];
            self.alarm.text = [NSString stringWithFormat:@"警报:   %@", [dic objectForKey:@"alarm"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [task resume];
}

- (IBAction)showDetailData:(UISwipeGestureRecognizer *)sender {
    
    QueryViewController *queryVC = [[QueryViewController alloc] init];
    queryVC.meter_id = self.crModel.meter_id;
    
    queryVC.manageMeterNumValue = self.crModel.meter_id;
    queryVC.meterTypeValue = self.crModel.meter_name2;
    //此处将通讯方式修改为口径
    queryVC.communicationTypeValue = self.crModel.meter_cali;
    queryVC.installAddrValue = self.crModel.meter_user_addr;

    [self.navigationController showViewController:queryVC sender:nil];
    
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
