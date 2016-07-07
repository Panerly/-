//
//  MeteringViewController.h
//  first
//
//  Created by HS on 16/5/20.
//  Copyright © 2016年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeteringViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)meterTypecOntrol:(UISegmentedControl *)sender;

@end
