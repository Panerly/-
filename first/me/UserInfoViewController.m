//
//  UserInfoViewController.m
//  first
//
//  Created by HS on 16/6/20.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserNameViewController.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *cellID;
    NSData *imageData;
    NSUserDefaults *defaults;
}
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userIcon.clipsToBounds = YES;
    self.userIcon.layer.cornerRadius = 30;
    defaults = [NSUserDefaults standardUserDefaults];
    
    
    [self _setTableView];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"userInfor" bundle:nil] instantiateViewControllerWithIdentifier:@"userInforID"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{  
    imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
    if (imageData != nil) {
        [_userIcon setImage:[NSKeyedUnarchiver unarchiveObjectWithData:imageData] forState:UIControlStateNormal];
    }
    _userIcon.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.5 animations:^{
        _userIcon.transform = CGAffineTransformIdentity;
    }];
    
    if ([defaults objectForKey:@"userNameValue"] != nil) {
        _userNameLabel.text = [defaults objectForKey:@"userNameValue"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _userIcon.transform = CGAffineTransformMakeScale(0.1, 0.1);

    }];
}

- (void)_setTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    cellID = @"attrIdenty";
}

//点击更换头像
- (IBAction)userImage:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *change = [UIAlertAction actionWithTitle:@"修改头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:change];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"修改昵称";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"生日";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"性别";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        UserNameViewController *userNameVC = [[UserNameViewController alloc] init];
        [self showViewController:userNameVC sender:nil];
    }else if (indexPath.row == 1){
        
        
    }else if (indexPath.row == 2){
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    [_userIcon setImage:image forState:UIControlStateNormal];

    imageData = [NSKeyedArchiver archivedDataWithRootObject:image];
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"];
    
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.view.window == nil && [self isViewLoaded]) {
        self.view = nil;
    }
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
