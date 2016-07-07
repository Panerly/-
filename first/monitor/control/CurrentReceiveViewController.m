//
//  CurrentReceiveViewController.m
//  first
//
//  Created by HS on 16/6/14.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "CurrentReceiveViewController.h"
#import "AFNetworking.h"
#import "CurrentReceiveTableViewCell.h"
#import "DetailViewController.h"
#import "CRModel.h"
#import "DetailModel.h"
#import "UIImage+GIF.h"
#import "HisDetailViewController.h"
#import "MeterEditViewController.h"

@interface CurrentReceiveViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating,UISearchBarDelegate>
{
    NSString *identy;
    UIImageView *loading;
}
//创建搜索栏
@property (nonatomic, strong) UISearchController *searchController;

@property(nonatomic,retain)NSMutableArray *searchResults;//接收数据源结果
@end

@implementation CurrentReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.definesPresentationContext = YES;
    
    if (self.isRealTimeOrHis == 0) {
       self.title = @"实时抄见";
    }else if (self.isRealTimeOrHis == 1){
        self.title = @"历史抄见";
    }else if (self.isRealTimeOrHis == 2){
        self.title = @"水表修改";
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:249.0 green:255.0 blue:249.0 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
     if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
     {
         self.edgesForExtendedLayout = UIRectEdgeNone;
     }
    
    identy = @"currentReceive";
    
    [self _getCode];
    
    [self _requestData];
    
    [self _createTabelView];
    
    self.dataArr = [NSMutableArray array];
    
}

- (void)_getCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.userNameLabel = [defaults objectForKey:@"userName"];
    self.passWordLabel = [defaults objectForKey:@"passWord"];
    self.ipLabel = [defaults objectForKey:@"ip"];
    self.dbLabel = [defaults objectForKey:@"db"];
}

//请求实时抄见数据
- (void)_requestData
{
    //刷新控件

    loading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 133, 100)];
    loading.center = self.view.center;
    UIImage *image = [UIImage sd_animatedGIFNamed:@"刷新5"];
    [loading setImage:image];
    [self.view addSubview:loading];
    
    NSString *logInUrl = [NSString stringWithFormat:@"http://%@/waterweb/servlet/LServlet",self.ipLabel];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    NSDictionary *parameters = @{@"username":self.userNameLabel,
                                 @"password":self.passWordLabel,
                                 @"db":self.dbLabel,
                                 @"type":@5,
                                 };
    
    AFHTTPResponseSerializer *serializer = manager.responseSerializer;
    
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {

            NSDictionary *responseObjectArr = [responseObject objectForKey:@"meters"];
                        
            [self.dataArr removeAllObjects];

            for (NSDictionary *dic in responseObjectArr) {
                
                NSError *error = nil;
                
                CRModel *crModel = [[CRModel alloc] initWithDictionary:dic error:&error];
                
                [self.dataArr addObject:crModel];

            }
            
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
            
            [loading removeFromSuperview];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [loading removeFromSuperview];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器连接失败" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
        
    }];
    
    [task resume];
}

//创建tableview
- (void)_createTabelView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PanScreenWidth, PanScreenHeight-54*2) style:UITableViewStylePlain];
    
    //调用初始化searchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    //搜索栏表头视图
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    identy = @"currentReceive";
    
    [_tableView registerNib:[UINib nibWithNibName:@"CurrentReceive" bundle:nil] forCellReuseIdentifier:identy];
    
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (!self.searchController.active)?self.dataArr.count : self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 100;
        
    }else {
        
    return 80;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CurrentReceiveTableViewCell *crCell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
    
    crCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!crCell) {
        
        crCell = [[[NSBundle mainBundle] loadNibNamed:@"CurrentReceive" owner:self options:nil] lastObject];
    }
    
    crCell.CRModel = (!self.searchController.active)?_dataArr[indexPath.row] : self.searchResults[indexPath.row];

    return crCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRealTimeOrHis == 0) {
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        
        detailVC.titleName = (!self.searchController.active)?((CRModel *)_dataArr[indexPath.row]).meter_name : ((CRModel *)self.searchResults[indexPath.row]).meter_name;
        
        detailVC.crModel = (!self.searchController.active)?_dataArr[indexPath.row] : _searchResults[indexPath.row];
        
        [self.navigationController showViewController:detailVC sender:nil];
    }
    
    if (self.isRealTimeOrHis == 1) {
        
        HisDetailViewController *hisDetailVC = [[HisDetailViewController alloc] init];
        hisDetailVC.hidesBottomBarWhenPushed = YES;
        hisDetailVC.hisDetailModel = (!self.searchController.active)?_dataArr[indexPath.row] : _searchResults[indexPath.row];
        [self.navigationController showViewController:hisDetailVC sender:nil];
    }
    
    if (self.isRealTimeOrHis == 2) {
        
        MeterEditViewController *editDetailVC = [[MeterEditViewController alloc] init];
        editDetailVC.meter_id = (!self.searchController.active)?((CRModel *)_dataArr[indexPath.row]).meter_id : ((CRModel *)self.searchResults[indexPath.row]).meter_id;
        [self.navigationController showViewController:editDetailVC sender:nil];
    }
}

#pragma mark - searchController delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    self.searchResults= [NSMutableArray array];
    [self.searchResults removeAllObjects];
    
    //NSPredicate 谓词
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchController.searchBar.text];
    
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    
    for (CRModel *crModel in self.dataArr) {
        [arr addObject:crModel.meter_name];
    }
    arr2 = [[arr filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    for (CRModel *crModel in self.dataArr) {
        if ([arr2 containsObject:crModel.meter_name]) {
            [self.searchResults addObject:crModel];
        }
    }
    //刷新表格
    [self.tableView reloadData];
}


//移除搜索栏
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
}


@end
