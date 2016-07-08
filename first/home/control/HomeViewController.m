//
//  HomeViewController.m
//  first
//
//  Created by HS on 16/5/20.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "HomeViewController.h"
#import "City.h"
#import "WeatherModel.h"
#import "MeteringViewController.h"
#import "UIImage+GIF.h"
#import "SCToastView.h"

@interface HomeViewController ()<CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource>
{
    UIImageView *loading;
    NSTimer *timer;
}
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) NSDictionary *areaidDic;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weatherDetailEffectView.clipsToBounds = YES;
    self.weatherDetailEffectView.layer.cornerRadius = 10;
    
    self.dataArray = [NSMutableArray array];

    //请求天气信息
    //给个默认城市：杭州
    [self _requestWeatherData:@"杭州"];
    
    [self _createTableView];
}

- (void)_createTableView
{
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    
}

- (void)locationCurrentCity
{
    //检测定位功能是否开启
    if([CLLocationManager locationServicesEnabled]){
        if(!_locationManager){
            self.locationManager = [[CLLocationManager alloc] init];
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
        }
        //设置代理
        self.locationManager.delegate = self;
        //设置定位精度
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //设置距离筛选
        [self.locationManager setDistanceFilter:100];
        //开始定位
        [self.locationManager startUpdatingLocation];
        [self.view addSubview:loading];
        //设置开始识别方向
        [self.locationManager startUpdatingHeading];
    }else{
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"定位信息" message:@"您没有开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }
}

//请求天气信息
- (void)_requestWeatherData:(NSString *)cityName
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        
    NSString *cityNameStr = [cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@",cityNameStr];
    
    NSMutableURLRequest *requestHistory = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",hisWeatherAPI,httpArg]]];
    
    requestHistory.HTTPMethod = @"GET";
    
    requestHistory.timeoutInterval = 10;
    
    [requestHistory addValue:weatherAPIkey forHTTPHeaderField:@"apikey"];
    
    AFHTTPResponseSerializer *serializer = manager.responseSerializer;
    
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];

    NSURLSessionTask *hisTask = [manager dataTaskWithRequest:requestHistory uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (responseObject) {
            
            NSDictionary *responseDic = [responseObject objectForKey:@"retData"];
            
            self.city.text = [NSString stringWithFormat:@"城市:  %@",[responseDic objectForKey:@"city"]];
            self.windDriection.text = [NSString stringWithFormat:@"风向:  %@",[[responseDic objectForKey:@"today"] objectForKey:@"fengxiang"]];
            self.temLabel.text = [NSString stringWithFormat:@"气温:  最高%@   最低%@",[[responseDic objectForKey:@"today"] objectForKey:@"hightemp"],[[responseDic objectForKey:@"today"] objectForKey:@"lowtemp"]];
            self.time.text = [NSString stringWithFormat:@"日期:  %@",[[responseDic objectForKey:@"today"] objectForKey:@"week"]];
            self.windForceScale.text = [NSString stringWithFormat:@"风力:  %@",[[responseDic objectForKey:@"today"] objectForKey:@"fengli"]];
            self.yestodayWeather.text = [NSString stringWithFormat:@"%@",[[[responseDic objectForKey:@"history"] objectAtIndex:6] objectForKey:@"type"]];
            self.tomorrowWeather.text = [NSString stringWithFormat:@"%@",[[[responseDic objectForKey:@"forecast"] objectAtIndex:0] objectForKey:@"type"]];
            self.todayWeatherInfo.text = [NSString stringWithFormat:@"%@",[[responseDic objectForKey:@"today"] objectForKey:@"type"]];
            self.weather.text  = [NSString stringWithFormat:@"天气:  %@",self.todayWeatherInfo.text];
            
            self.yesterdayImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.yestodayWeather.text]];
            self.tomorrowImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.tomorrowWeather.text]];
            self.weatherPicImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.todayWeatherInfo.text]];
            self.todayImage.image = self.weatherPicImage.image;
            
            CATransition *transition = [[CATransition alloc]init];
            transition.type = @"rippleEffect";
            transition.duration = 0.5;
            [_weatherPicImage.layer addAnimation:transition forKey:@"transition"];
            [_yesterdayImage.layer addAnimation:transition forKey:@"transition"];
            [_tomorrowImage.layer addAnimation:transition forKey:@"transition"];

        }
        else{
            self.city.text = [NSString stringWithFormat:@"城市:  加载失败^_^!"];
            self.weather.text = [NSString stringWithFormat:@"天气:  加载失败^_^!"];
            self.temLabel.text = [NSString stringWithFormat:@"温度:  加载失败^_^!"];
            self.windDriection.text = [NSString stringWithFormat:@"风向:  加载失败^_^!"];
            self.windForceScale.text = [NSString stringWithFormat:@"风力:  加载失败^_^!"];
            self.time.text = [NSString stringWithFormat:@"日期:  加载失败^_^!"];
            self.yestodayWeather.text = [NSString stringWithFormat:@"加载失败!"];
            self.todayWeatherInfo.text = [NSString stringWithFormat:@"加载失败!"];
            self.tomorrowWeather.text = [NSString stringWithFormat:@"加载失败!"];
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据加载失败，请重新定位^_^!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:^{
                
            }];
        }
        
    }];
    
    [hisTask resume];
}

//从storyboard中加载
- (instancetype)init
{
    self = [super init];
    if (self) {
        self  = [[UIStoryboard storyboardWithName:@"HomeSB" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeSB"];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}

//定位当前城市
- (IBAction)position:(id)sender {
    
    [SCToastView showInView:[UIApplication sharedApplication].keyWindow text:@"定位中..." duration:2 autoHide:YES];
    
    //设置加载圆点转圈动画
    if (!loading) {
        
        loading = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    }
    loading.center = self.view.center;
    
    UIImage *image = [UIImage sd_animatedGIFNamed:@"定位图"];
    
    [loading setImage:image];

    timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(timesOut) userInfo:nil repeats:NO];
    
    [self locationCurrentCity];
}
- (void)timesOut{
    [loading removeFromSuperview];
    [SCToastView showInView:self.view text:@"定位超时！" duration:3 autoHide:YES];
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManangerDelegate
//定位成功以后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation* location = locations.lastObject;
    [self reverseGeocoder:location];
    
}

#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);
        }else{
            if ([loading isKindOfClass:[self.view class]]) {
                
                [loading removeFromSuperview];
            }
            CLPlacemark* placemark = placemarks.firstObject;
            NSLog(@"placemark:%@",[[placemark addressDictionary] objectForKey:@"City"]);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"你的位置" message:[[placemark addressDictionary] objectForKey:@"City"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:^{
                
            }];
            NSString *cityName = [[placemark addressDictionary] objectForKey:@"City"];
            
            //去除“市” 百度天气不允许带市、自治区等后缀
            if ([cityName rangeOfString:@"市"].location != NSNotFound) {
                 NSInteger index = [cityName rangeOfString:@"市"].location;
                                    cityName = [cityName substringToIndex:index];
                                    }
            if ([cityName rangeOfString:@"自治区"].location != NSNotFound) {
                NSInteger index = [cityName rangeOfString:@"自治区"].location;
                cityName = [cityName substringToIndex:index];
            }
            
            [self _requestWeatherData:cityName];
            
        }
    }];
}

#pragma mark - UITableViewDelegate & DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"待抄收 10 家"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeteringViewController *meteringVC = [[MeteringViewController alloc] init];
    [self.navigationController showViewController:meteringVC sender:nil];
}


@end

