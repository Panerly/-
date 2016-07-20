//
//  MeterEditViewController.m
//  first
//
//  Created by HS on 16/6/15.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "MeterEditViewController.h"
#import "SCToastView.h"

@interface MeterEditViewController ()<CLLocationManagerDelegate>
{
    SCToastView *toastView;
    NSMutableArray *alarmNsetList;
}
@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation MeterEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _getCode];
    
    [self _configScrollView];
    
    [self _requestData];
    
    _dataArr = [NSMutableArray array];
    
}
- (void)_getCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.userNameLabel = [defaults objectForKey:@"userName"];
    self.passWordLabel = [defaults objectForKey:@"passWord"];
    self.ipLabel = [defaults objectForKey:@"ip"];
    self.dbLabel = [defaults objectForKey:@"db"];
}

- (void)_requestData
{
    
     NSString *logInUrl = [NSString stringWithFormat:@"http://%@/waterweb/EditServlet",self.ipLabel];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSDictionary *parameters = @{@"username":self.userNameLabel,
                                 @"password":self.passWordLabel,
                                 @"db":self.dbLabel,
                                 @"meterid":self.meter_id,
                                 };
    
    AFHTTPResponseSerializer *serializer = manager.responseSerializer;
    
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            alarmNsetList = [NSMutableArray array];
            [alarmNsetList removeAllObjects];
            NSLog(@"%@",responseObject);
            for (NSDictionary *dic in [responseObject objectForKey:@"alarmNsetList"]) {
                [alarmNsetList addObject:[dic objectForKey:@"TorF"]];
                
            }
            _idArray = [NSMutableArray array];
            [_idArray removeAllObjects];
            for (NSDictionary *idDic in [responseObject objectForKey:@"alarmNsetList"]) {
                [_idArray addObject:[idDic objectForKey:@"id"]];
            }
            
            _numArray = [NSMutableArray array];
            for (NSDictionary *numDic in [responseObject objectForKey:@"alarmNsetList"]) {
                [_numArray addObject:[numDic objectForKey:@"num"]];
            }
            
            [_excessiveSwitchBtn setOn:[[alarmNsetList objectAtIndex:0] isEqualToString:@"0"] ? NO : YES];
            [_reversalSwitchBtn setOn:[[alarmNsetList objectAtIndex:2]isEqualToString:@"0"] ? NO : YES];
            [_longTimeNotServerSwitchBtn setOn:[[alarmNsetList objectAtIndex:3]isEqualToString:@"0"] ? NO : YES];
            [_limitOfDayUsageSwitchBtn setOn:[[alarmNsetList objectAtIndex:4]isEqualToString:@"0"] ? NO : YES];
            [_longtimeNotUseSwitchBtn setOn:[[alarmNsetList objectAtIndex:1]isEqualToString:@"0"] ? NO : YES];
            [_limitOfUsageSwitchBtn setOn:[[alarmNsetList objectAtIndex:5]isEqualToString:@"0"] ? NO : YES];
            [_fromToSwitchBtn setOn:[[alarmNsetList objectAtIndex:6]isEqualToString:@"0"] ? NO : YES];
            
            _userID.text = [NSString stringWithFormat:@"用户号: %@",[responseObject objectForKey:@"user_id"]];
            _installAddrTextField.text = [responseObject objectForKey:@"username"];
            _longitudeTextField.text = [responseObject objectForKey:@"x"];
            _latitudeTextField.text = [responseObject objectForKey:@"y"];
            _remarksTextView.text = [responseObject objectForKey:@"user_remark"];
            _user_addr= [responseObject objectForKey:@"user_addr"];
            
            NSDictionary *dic = [responseObject objectForKey:@"meter1"];
            _meterID.text = [NSString stringWithFormat:@"表位号: %@",[dic objectForKey:@"meter_id"]];
            _meter_idTextField.text = [dic objectForKey:@"meter_wid"];
            _connectIDTextField.text = [dic objectForKey:@"comm_id"];
            _collectIDTextField.text = [dic objectForKey:@"collector_id"];
            _installTimeTextField.text = [dic objectForKey:@"install_time"];
            _wheelTypeTextField.text = [dic objectForKey:@"bz10"];
            _regionTextField.text = [dic objectForKey:@"area"];
            _meterTypeTextField.text = [dic objectForKey:@"meter_name"];
            _caliberTextField.text = [dic objectForKey:@"meter_cali"];
            _remoteTypeTextField.text = [dic objectForKey:@"type_name"];
            _remoteWayTextField.text = [dic objectForKey:@"type"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据加载失败^_^!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }];
    [task resume];
    
}

//配置滑动试图
- (void)_configScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.contentSize= CGSizeMake(PanScreenWidth, 2*PanScreenHeight);
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    //滑动时使键盘收回
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(PanScreenWidth, PanScreenHeight));
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self _configContent];
    
    //保存按钮
    _saveBtn = [[UIButton alloc] init];
    [_saveBtn setImage:[UIImage imageNamed:@"save2"] forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-59);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.size.equalTo(CGSizeMake(55, 55));
    }];
}

//控件部署
- (void)_configContent
{
    _userID = [[UILabel alloc] init];
    _userID.text = @"用户号: ";
    _userID.font = [UIFont systemFontOfSize:13];
    _userID.textColor = [UIColor blueColor];
    [_scrollView addSubview:_userID];
    [_userID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).with.offset(15);
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.size.equalTo(CGSizeMake(150, 25));
    }];
    
    _meterID = [[UILabel alloc] init];
    _meterID.text = @"表位号: ";
    _meterID.font = [UIFont systemFontOfSize:13];
    _meterID.textColor = [UIColor blueColor];
    [_scrollView addSubview:_meterID];
    [_meterID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).with.offset(15);
        make.centerX.equalTo(_scrollView.centerX).with.offset(50);
        make.size.equalTo(CGSizeMake(150, 25));
    }];
    
    _installAddrLabel = [[UILabel alloc] init];
    _installAddrLabel.textColor = [UIColor blueColor];
    _installAddrLabel.text = @"安装地址: ";
    _installAddrLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_installAddrLabel];
    [_installAddrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(_meterID.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _installAddrTextField = [[UITextField alloc] init];
    [_scrollView addSubview:_installAddrTextField];
    _installAddrTextField.borderStyle = UITextBorderStyleRoundedRect;
    _installAddrTextField.font = [UIFont systemFontOfSize:11];
    [_installAddrTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_installAddrLabel.mas_right);
        make.top.equalTo(_meterID.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(25);
    }];
    
    _meter_idLabel = [[UILabel alloc] init];
    _meter_idLabel.text = @"表  身  号: ";
    _meter_idLabel.font = [UIFont systemFontOfSize:13];
    _meter_idLabel.textColor = [UIColor blueColor];
    [_scrollView addSubview:_meter_idLabel];
    [_meter_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.left).with.offset(10);
        make.top.equalTo(_installAddrLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _meter_idTextField = [[UITextField alloc] init];
    [_scrollView addSubview:_meter_idTextField];
    _meter_idTextField.borderStyle = UITextBorderStyleRoundedRect;
    _meter_idTextField.font = [UIFont systemFontOfSize:13];
    [_meter_idTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_installAddrLabel.mas_right);
        make.top.equalTo(_installAddrLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(25);
    }];
    
    _connectIDLabel = [[UILabel alloc] init];
    _connectIDLabel.textColor = [UIColor blueColor];
    _connectIDLabel.text = @"通讯联络号: ";
    _connectIDLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_connectIDLabel];
    [_connectIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(_meter_idLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _connectIDTextField = [[UITextField alloc] init];
    [_scrollView addSubview:_connectIDTextField];
    _connectIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    _connectIDTextField.font = [UIFont systemFontOfSize:13];
    [_connectIDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_installAddrLabel.mas_right);
        make.top.equalTo(_meter_idLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(25);
    }];
    
    _collectIDLabel = [[UILabel alloc] init];
    _collectIDLabel.textColor = [UIColor blueColor];
    _collectIDLabel.text = @"采集编号: ";
    _collectIDLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_collectIDLabel];
    [_collectIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(_connectIDLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _collectIDTextField = [[UITextField alloc] init];
    [_scrollView addSubview:_collectIDTextField];
    _collectIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    _collectIDTextField.font = [UIFont systemFontOfSize:13];
    [_collectIDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_installAddrLabel.mas_right);
        make.top.equalTo(_connectIDTextField.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(25);
    }];
    
    
    _installTimeLabel = [[UILabel alloc] init];
    _installTimeLabel.textColor = [UIColor blueColor];
    _installTimeLabel.text = @"安装时间: ";
    _installTimeLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_installTimeLabel];
    [_installTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(_collectIDLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _installTimeTextField = [[UITextField alloc] init];
    [_scrollView addSubview:_installTimeTextField];
    _installTimeTextField.borderStyle = UITextBorderStyleRoundedRect;
    _installTimeTextField.font = [UIFont systemFontOfSize:13];
    [_installTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_installAddrLabel.mas_right);
        make.top.equalTo(_collectIDTextField.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(25);
    }];
    
    
    _wheelTypeLabel = [[UILabel alloc] init];
    _wheelTypeLabel.textColor = [UIColor blueColor];
    _wheelTypeLabel.text = @"字轮类型: ";
    _wheelTypeLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_wheelTypeLabel];
    [_wheelTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(_installTimeLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _wheelTypeTextField = [[UITextField alloc] init];
    [_scrollView addSubview:_wheelTypeTextField];
    _wheelTypeTextField.borderStyle = UITextBorderStyleRoundedRect;
    _wheelTypeTextField.font = [UIFont systemFontOfSize:13];
    [_wheelTypeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_installAddrLabel.mas_right);
        make.top.equalTo(_installTimeTextField.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(25);
    }];
    
    _regionLabel = [[UILabel alloc] init];
    _regionLabel.textColor = [UIColor blueColor];
    _regionLabel.text = @"所属区域: ";
    _regionLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_regionLabel];
    [_regionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(_wheelTypeLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _regionTextField = [[UITextField alloc] init];
    _regionTextField.font = [UIFont systemFontOfSize:13];
    _regionTextField.borderStyle = UITextBorderStyleRoundedRect;
    [_scrollView addSubview:_regionTextField];
    [_regionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_regionLabel.mas_right);
        make.top.equalTo(_wheelTypeLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.right).with.offset(-10);
        make.height.equalTo(25);
    }];
    
    
    _meterTypeLabel = [[UILabel alloc] init];
    _meterTypeLabel.textColor = [UIColor blueColor];
    _meterTypeLabel.text = @"表具类型: ";
    _meterTypeLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_meterTypeLabel];
    [_meterTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(_regionLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _meterTypeTextField = [[UITextField alloc] init];
    _meterTypeTextField.font = [UIFont systemFontOfSize:13];
    _meterTypeTextField.borderStyle = UITextBorderStyleRoundedRect;
    [_scrollView addSubview:_meterTypeTextField];
    [_meterTypeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_meterTypeLabel.mas_right);
        make.top.equalTo(_regionTextField.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.right).with.offset(-10);
        make.height.equalTo(25);
    }];
    
    _caliberLabel = [[UILabel alloc] init];
    _caliberLabel.textColor = [UIColor blueColor];
    _caliberLabel.text = @"口     经: ";
    _caliberLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_caliberLabel];
    [_caliberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(_meterTypeLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _caliberTextField = [[UITextField alloc] init];
    _caliberTextField.font = [UIFont systemFontOfSize:13];
    _caliberTextField.borderStyle = UITextBorderStyleRoundedRect;
    [_scrollView addSubview:_caliberTextField];
    [_caliberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_caliberLabel.mas_right);
        make.top.equalTo(_meterTypeTextField.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.right).with.offset(-10);
        make.height.equalTo(25);
    }];

    
    UILabel *remoteWay = [[UILabel alloc] init];
    remoteWay.textColor = [UIColor blueColor];
    remoteWay.text = @"远传方式: ";
    remoteWay.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:remoteWay];
    [remoteWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(_caliberLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _remoteWayTextField = [[UITextField alloc] init];
    _remoteWayTextField.font = [UIFont systemFontOfSize:13];
    _remoteWayTextField.borderStyle = UITextBorderStyleRoundedRect;
    [_scrollView addSubview:_remoteWayTextField];
    [_remoteWayTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remoteWay.mas_right);
        make.top.equalTo(_caliberTextField.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.right).with.offset(-10);
        make.height.equalTo(25);
    }];
    
    UILabel *remoteType = [[UILabel alloc] init];
    remoteType.textColor = [UIColor blueColor];
    remoteType.text = @"远传类型";
    remoteType.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:remoteType];
    [remoteType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(remoteWay.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    _remoteTypeTextField = [[UITextField alloc] init];
    _remoteTypeTextField.font = [UIFont systemFontOfSize:13];
    _remoteTypeTextField.borderStyle = UITextBorderStyleRoundedRect;
    [_scrollView addSubview:_remoteTypeTextField];
    [_remoteTypeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remoteType.mas_right);
        make.top.equalTo(_remoteWayTextField.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.right).with.offset(-10);
        make.height.equalTo(25);
    }];
    
    _longitudeLabel = [[UILabel alloc] init];
    _longitudeLabel.textColor = [UIColor blueColor];
    _longitudeLabel.text = @"经度: ";
    _longitudeLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_longitudeLabel];
    [_longitudeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(10);
        make.top.equalTo(remoteType.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(50, 25));
    }];
    _longitudeTextField = [[UITextField alloc] init];
    [_scrollView addSubview:_longitudeTextField];
    _longitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    _longitudeTextField.font = [UIFont systemFontOfSize:13];
    [_longitudeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_longitudeLabel.mas_right).with.offset(-15);
        make.top.equalTo(remoteType.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(90, 25));
    }];
    
    _latitudeLabel = [[UILabel alloc] init];
    _latitudeLabel.textColor = [UIColor blueColor];
    _latitudeLabel.text = @"纬度: ";
    _latitudeLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_latitudeLabel];
    [_latitudeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remoteType.mas_bottom).with.offset(10);
        make.centerX.equalTo(_scrollView.centerX).with.offset(5);
        make.size.equalTo(CGSizeMake(50, 25));
    }];
    _latitudeTextField = [[UITextField alloc] init];
    [_scrollView addSubview:_latitudeTextField];
    _latitudeTextField.borderStyle = UITextBorderStyleRoundedRect;
    _latitudeTextField.font = [UIFont systemFontOfSize:13];
    [_latitudeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_latitudeLabel.mas_right).with.offset(-15);
        make.top.equalTo(remoteType.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(90, 25));
    }];
    
    //定位按钮
    _locaBtn = [[UIButton alloc] init];
    [_locaBtn setImage:[UIImage imageNamed:@"定位3"] forState:UIControlStateNormal];
    [_locaBtn addTarget:self action:@selector(locaBtn) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_locaBtn];
    [_locaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remoteType.mas_bottom).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    UILabel *setAlarm = [[UILabel alloc] init];
    setAlarm.textColor = [UIColor blueColor];
    setAlarm.text = @"警报参数设置";
    setAlarm.font = [UIFont systemFontOfSize:18];
    [_scrollView addSubview:setAlarm];
    [setAlarm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_scrollView.mas_centerX);
        make.top.equalTo(_longitudeLabel.mas_bottom).with.offset(30);
        make.size.equalTo(CGSizeMake(120, 35));
    }];
    
    
    //警报介绍
    UILabel *alarmIntroduce = [[UILabel alloc] init];
    alarmIntroduce.text = @"警报介绍";
    alarmIntroduce.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:alarmIntroduce];
    [alarmIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
        make.top.equalTo(setAlarm.mas_bottom);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    
    
    //参数设置
    UILabel *parameterSet = [[UILabel alloc] init];
    parameterSet.text = @"参数设置";
    parameterSet.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:parameterSet];
    [parameterSet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_scrollView.centerX);
        make.top.equalTo(setAlarm.mas_bottom);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    
    
    //是否启用
    UILabel *enableLabel = [[UILabel alloc] init];
    enableLabel.text = @"是否启用";
    enableLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:enableLabel];
    [enableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right);
        make.top.equalTo(setAlarm.mas_bottom);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    
    
    //用水过量报警
    _excessiveAlarmLabel = [[UILabel alloc] init];
    _excessiveAlarmLabel.text = @"用水过量报警";
    _excessiveAlarmLabel.textColor = [UIColor darkGrayColor];
    _excessiveAlarmLabel.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:_excessiveAlarmLabel];
    [_excessiveAlarmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
        make.top.equalTo(alarmIntroduce.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(120, 25));
    }];
    _excessiveAlarmTextField = [[UITextField alloc] init];
    _excessiveAlarmTextField.borderStyle = UITextBorderStyleRoundedRect;
    _excessiveAlarmTextField.font = [UIFont systemFontOfSize:13];
    _excessiveAlarmTextField.text = @"100";
    [_scrollView addSubview:_excessiveAlarmTextField];
    [_excessiveAlarmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmIntroduce.mas_bottom).with.offset(10);
        make.centerX.equalTo(_scrollView.centerX);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    UILabel *excessiveAlarmUnit = [[UILabel alloc] init];
    excessiveAlarmUnit.text = @"吨/时";
    excessiveAlarmUnit.textColor = [UIColor darkGrayColor];
    excessiveAlarmUnit.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:excessiveAlarmUnit];
    [excessiveAlarmUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_excessiveAlarmTextField.mas_right).with.offset(5);
        make.top.equalTo(alarmIntroduce.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(50, 25));
    }];
    _excessiveSwitchBtn = [[UISwitch alloc] init];
    [_scrollView addSubview:_excessiveSwitchBtn];
    [_excessiveSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmIntroduce.mas_bottom).with.offset(5);
        make.centerX.equalTo(enableLabel.centerX);
    }];
    
    //水表倒流
    _reversalAlarmLabel = [[UILabel alloc] init];
    _reversalAlarmLabel.text = @"水表倒流";
    _reversalAlarmLabel.textColor = [UIColor darkGrayColor];
    _reversalAlarmLabel.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:_reversalAlarmLabel];
    [_reversalAlarmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
        make.top.equalTo(_excessiveAlarmLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(120, 25));
    }];
    _reversalAlarmTextField = [[UITextField alloc] init];
    _reversalAlarmTextField.borderStyle = UITextBorderStyleRoundedRect;
    _reversalAlarmTextField.font = [UIFont systemFontOfSize:13];
    _reversalAlarmTextField.text = @"1";
    [_scrollView addSubview:_reversalAlarmTextField];
    [_reversalAlarmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_scrollView.centerX);
        make.top.equalTo(excessiveAlarmUnit.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    UILabel *reversalAlarmUnit = [[UILabel alloc] init];
    reversalAlarmUnit.text = @"吨/天";
    reversalAlarmUnit.textColor = [UIColor darkGrayColor];
    reversalAlarmUnit.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:reversalAlarmUnit];
    [reversalAlarmUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_reversalAlarmTextField.mas_right).with.offset(5);
        make.top.equalTo(_excessiveAlarmTextField.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(50, 25));
    }];
    _reversalSwitchBtn = [[UISwitch alloc] init];
    [_scrollView addSubview:_reversalSwitchBtn];
    [_reversalSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(excessiveAlarmUnit.mas_bottom).with.offset(5);
        make.centerX.equalTo(enableLabel.centerX);
    }];
    
    
    //长时间不在线
    UILabel *longTimeNotServer = [[UILabel alloc] init];
    longTimeNotServer.text = @"长时间不在线";
    longTimeNotServer.textColor = [UIColor darkGrayColor];
    longTimeNotServer.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:longTimeNotServer];
    [longTimeNotServer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
        make.top.equalTo(_reversalAlarmLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(120, 25));
    }];
    _longTimeNotServerTextField = [[UITextField alloc] init];
    _longTimeNotServerTextField.borderStyle = UITextBorderStyleRoundedRect;
    _longTimeNotServerTextField.font = [UIFont systemFontOfSize:13];
    _longTimeNotServerTextField.text = @"50";
    [_scrollView addSubview:_longTimeNotServerTextField];
    [_longTimeNotServerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_scrollView.centerX);
        make.top.equalTo(_reversalAlarmTextField.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    UILabel *longTimeNotServerUnit = [[UILabel alloc] init];
    longTimeNotServerUnit.text = @"小 时";
    longTimeNotServerUnit.textColor = [UIColor darkGrayColor];
    longTimeNotServerUnit.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:longTimeNotServerUnit];
    [longTimeNotServerUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_reversalAlarmTextField.mas_right).with.offset(5);
        make.top.equalTo(_reversalAlarmTextField.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(50, 25));
    }];
    _longTimeNotServerSwitchBtn = [[UISwitch alloc] init];
    [_scrollView addSubview:_longTimeNotServerSwitchBtn];
    [_longTimeNotServerSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reversalAlarmUnit.mas_bottom).with.offset(5);
        make.centerX.equalTo(enableLabel.centerX);
    }];
    
    
    //日用量超量程
    UILabel *dayOverFlow = [[UILabel alloc] init];
    dayOverFlow.text = @"日用量超量程";
    dayOverFlow.textColor = [UIColor darkGrayColor];
    dayOverFlow.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:dayOverFlow];
    [dayOverFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
        make.top.equalTo(longTimeNotServer.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(120, 25));
    }];
    _limitOfUsageAlarmTextField = [[UITextField alloc] init];
    _limitOfUsageAlarmTextField.borderStyle = UITextBorderStyleRoundedRect;
    _limitOfUsageAlarmTextField.font = [UIFont systemFontOfSize:13];
    _limitOfUsageAlarmTextField.text = @"1000";
    [_scrollView addSubview:_limitOfUsageAlarmTextField];
    [_limitOfUsageAlarmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_longTimeNotServerTextField.mas_bottom).with.offset(10);
        make.centerX.equalTo(_scrollView.centerX);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    UILabel *dayOverFlowUnit = [[UILabel alloc] init];
    dayOverFlowUnit.text = @"吨/天";
    dayOverFlowUnit.textColor = [UIColor darkGrayColor];
    dayOverFlowUnit.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:dayOverFlowUnit];
    [dayOverFlowUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_limitOfUsageAlarmTextField.mas_right).with.offset(5);
        make.top.equalTo(_longTimeNotServerTextField.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(50, 25));
    }];
    _limitOfDayUsageSwitchBtn = [[UISwitch alloc] init];
    [_scrollView addSubview:_limitOfDayUsageSwitchBtn];
    [_limitOfDayUsageSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(longTimeNotServer.mas_bottom).with.offset(5);
        make.centerX.equalTo(enableLabel.centerX);
    }];
    
    
    //长时间没有用水
    UILabel *longtimeNotUse = [[UILabel alloc] init];
    longtimeNotUse.text = @"长时间没有用水";
    longtimeNotUse.textColor = [UIColor darkGrayColor];
    longtimeNotUse.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:longtimeNotUse];
    [longtimeNotUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
        make.top.equalTo(dayOverFlow.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(120, 25));
    }];
    _longtimeNotUseSwitchBtn = [[UISwitch alloc] init];
    [_scrollView addSubview:_longtimeNotUseSwitchBtn];
    [_longtimeNotUseSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dayOverFlowUnit.mas_bottom).with.offset(5);
        make.centerX.equalTo(enableLabel.centerX);
    }];
    
    //月用水上限
    _limitOfUsageLabel = [[UILabel alloc] init];
    _limitOfUsageLabel.text = @"月用水上限";
    _limitOfUsageLabel.textColor = [UIColor darkGrayColor];
    _limitOfUsageLabel.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:_limitOfUsageLabel];
    [_limitOfUsageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
        make.top.equalTo(longtimeNotUse.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(120, 25));
    }];
    _limitOfUsageAlarmTextField = [[UITextField alloc] init];
    _limitOfUsageAlarmTextField.borderStyle = UITextBorderStyleRoundedRect;
    _limitOfUsageAlarmTextField.font = [UIFont systemFontOfSize:13];
    _limitOfUsageAlarmTextField.text = @"0";
    [_scrollView addSubview:_limitOfUsageAlarmTextField];
    [_limitOfUsageAlarmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(longtimeNotUse.mas_bottom).with.offset(10);
        make.centerX.equalTo(_scrollView.centerX);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    UILabel *limitOfUsageAlarmUnit = [[UILabel alloc] init];
    limitOfUsageAlarmUnit.text = @"吨/天";
    limitOfUsageAlarmUnit.textColor = [UIColor darkGrayColor];
    limitOfUsageAlarmUnit.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:limitOfUsageAlarmUnit];
    [limitOfUsageAlarmUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_limitOfUsageAlarmTextField.mas_right).with.offset(5);
        make.top.equalTo(longtimeNotUse.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(50, 25));
    }];
    _limitOfUsageSwitchBtn = [[UISwitch alloc] init];
    [_scrollView addSubview:_limitOfUsageSwitchBtn];
    [_limitOfUsageSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(longtimeNotUse.mas_bottom).with.offset(5);
        make.centerX.equalTo(enableLabel.centerX);
    }];
    
    
    //时段用水上限
    UILabel *intervalLabel = [[UILabel alloc] init];
    intervalLabel.text = @"时段用水上限";
    intervalLabel.textColor = [UIColor darkGrayColor];
    intervalLabel.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:intervalLabel];
    [intervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
        make.top.equalTo(_limitOfUsageLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(80, 25));
    }];
    _fromLabel = [[UILabel alloc] init];
    _fromLabel.text = @"从";
    _fromLabel.font = [UIFont systemFontOfSize:10.0f];
    [_scrollView addSubview:_fromLabel];
    [_fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(intervalLabel.mas_right);
        make.top.equalTo(_limitOfUsageAlarmTextField.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(15, 25));
    }];
    _fromTextField = [[UITextField alloc] init];
    _fromTextField.borderStyle = UITextBorderStyleRoundedRect;
    _fromTextField.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_fromTextField];
    [_fromTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fromLabel.mas_right).with.offset(5);
        make.top.equalTo(_limitOfUsageAlarmTextField.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    _toLabel = [[UILabel alloc] init];
    _toLabel.text = @"到";
    _toLabel.font = [UIFont systemFontOfSize:10.f];
    [_scrollView addSubview:_toLabel];
    [_toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fromTextField.mas_right).with.offset(5);
        make.top.equalTo(_limitOfUsageAlarmTextField.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(15, 25));
    }];
    _toTextField = [[UITextField alloc] init];
    _toTextField.borderStyle = UITextBorderStyleRoundedRect;
    _toTextField.font = [UIFont systemFontOfSize:13.0f];
    [_scrollView addSubview:_toTextField];
    [_toTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_toLabel.mas_right).with.offset(5);
        make.top.equalTo(_limitOfUsageAlarmTextField.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    _fromToSwitchBtn = [[UISwitch alloc] init];
    [_scrollView addSubview:_fromToSwitchBtn];
    [_fromToSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_limitOfUsageAlarmTextField.mas_bottom).with.offset(5);
        make.centerX.equalTo(enableLabel.centerX);
    }];
    
    
    //备注信息
    _remarksLabel = [[UILabel alloc] init];
    _remarksLabel.text = @"备注信息";
    _remarksLabel.textColor = [UIColor blueColor];
    _remarksLabel.font = [UIFont systemFontOfSize:10];
    [_scrollView addSubview:_remarksLabel];
    [_remarksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
        make.top.equalTo(intervalLabel.mas_bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(50, 25));
    }];
    _remarksTextView = [[UITextView alloc] init];
    _remarksTextView.font = [UIFont systemFontOfSize:13];
    _remarksTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    _remarksTextView.layer.borderWidth = 1;
    _remarksTextView.layer.cornerRadius = 6;
    _remarksTextView.layer.masksToBounds = YES;
    [_scrollView addSubview:_remarksTextView];
    [_remarksTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_remarksLabel.mas_right);
        make.top.equalTo(intervalLabel.mas_bottom).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(100);
    }];
    
    
}


- (UIButton *)locaBtn
{
    [SCToastView showInView:[UIApplication sharedApplication].keyWindow text:@"正在定位..." duration:1 autoHide:YES];
    //检测定位功能是否开启
    if([CLLocationManager locationServicesEnabled]){
        if(!_locationManager){
            self.locationManager = [[CLLocationManager alloc] init];
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
            //设置代理
            self.locationManager.delegate = self;
            //设置定位精度
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //设置距离筛选
            [self.locationManager setDistanceFilter:5.0];
            //开始定位
            [self.locationManager startUpdatingLocation];
            //设置开始识别方向
            [self.locationManager startUpdatingHeading];
        }
    }else{
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"定位信息" message:@"您没有开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:^{

        }];
    }

    return nil;
}

//保存数据
- (UIButton *)saveBtn
{
    
    NSMutableArray *alarmArr = [NSMutableArray array];
    [alarmArr removeAllObjects];
//    NSArray *switchBtnArr = @[_excessiveSwitchBtn,_longtimeNotUseSwitchBtn,_longTimeNotServerSwitchBtn,_limitOfDayUsageSwitchBtn,_reversalSwitchBtn,_limitOfUsageSwitchBtn,_fromToSwitchBtn];
//    for (int i = 0; i < alarmNsetList.count; i++) {
//        alarmArr addObject:[NSString stringWithFormat:@"%d",((UISwitch *)switchBtnArr[i]).isOn];
//    }
    [alarmArr addObject:[NSString stringWithFormat:@"%d",_excessiveSwitchBtn.isOn]];
    [alarmArr addObject:[NSString stringWithFormat:@"%d",_longtimeNotUseSwitchBtn.isOn]];
    [alarmArr addObject:[NSString stringWithFormat:@"%d",_longTimeNotServerSwitchBtn.isOn]];
    [alarmArr addObject:[NSString stringWithFormat:@"%d",_limitOfDayUsageSwitchBtn.isOn]];
    [alarmArr addObject:[NSString stringWithFormat:@"%d",_reversalSwitchBtn.isOn]];
    [alarmArr addObject:[NSString stringWithFormat:@"%d",_limitOfUsageSwitchBtn.isOn]];
    [alarmArr addObject:[NSString stringWithFormat:@"%d",_fromToSwitchBtn.isOn]];
    
    NSDictionary *alarmIsNull = [NSDictionary dictionary];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < alarmArr.count-1; i++) {
        alarmIsNull = @{
                        @"TorF":alarmArr[i],
                        @"num":_numArray[i],
                        };
        [arr addObject:alarmIsNull];
    }
    
    NSDictionary *sevenT = @{
                             @"TorF":alarmArr[6],
                             @"num":_idArray[6],
                             @"time_first":_fromTextField.text,
                             @"time_last":_toTextField.text
                             };
    
    NSMutableArray *alarmIsNullArray = [NSMutableArray arrayWithObjects:arr,sevenT, nil];
    NSLog(@"最终---%@",alarmIsNullArray);
    
    [SCToastView showInView:[UIApplication sharedApplication].keyWindow text:@"正在保存..." duration:2 autoHide:YES];
    NSString *logInUrl = [NSString stringWithFormat:@"http://%@/waterweb/EditServlet1",self.ipLabel];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSDictionary *parameters = @{@"username":self.userNameLabel,
                                 @"password":self.passWordLabel,
                                 @"db":self.dbLabel,
                                 @"meter_id":self.meter_id,
                                 @"user_name":_installAddrTextField.text,
                                 @"user_addr":_user_addr,
                                 @"comm_id":_connectIDTextField.text,
                                 @"collector_id":_collectIDTextField.text,
                                 @"install_time":_installTimeTextField.text,
                                 @"meter_wid":_meter_idTextField.text,
                                 @"bz10":_wheelTypeTextField.text,
                                 @"collector_area":_regionTextField.text,
                                 @"meter_name":_meterTypeTextField.text,
                                 @"meter_cali":_caliberTextField.text,
                                 @"type":_remoteWayTextField.text,
                                 @"type_name":_remoteTypeTextField.text,
                                 @"x":_longitudeTextField.text,
                                 @"y":_latitudeTextField.text,
                                 @"time_first":_fromTextField.text,
                                 @"time_last":_toTextField.text,
                                 @"user_remark":_remarksTextView.text,
                                 @"alarmIsNull":alarmIsNullArray,
                                 @"save4edit":@"save4edit",
                                 };
    
    AFHTTPResponseSerializer *serializer = manager.responseSerializer;
    
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功---%@",responseObject);
        [SCToastView showInView:[UIApplication sharedApplication].keyWindow text:@"保存成功" duration:2 autoHide:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败---%@",error);
        [SCToastView showInView:[UIApplication sharedApplication].keyWindow text:@"保存失败" duration:2 autoHide:YES];
    }];

    [task resume];
    return nil;
}


// 代理方法实现
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    [SCToastView showInView:[UIApplication sharedApplication].keyWindow text:@"定位成功" duration:2 autoHide:YES];
    _longitudeTextField.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    _latitudeTextField.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    [_locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}

@end
