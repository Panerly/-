//
//  QueryTableViewCell.m
//  first
//
//  Created by HS on 16/6/20.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "QueryTableViewCell.h"

@implementation QueryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.dayLabel.text = self.queryModel.collect_dt;
    if (self.queryModel.collect_avg == nil) {
        self.dosageLabel.text = [NSString stringWithFormat:@"日用量: %@ 吨",self.queryModel.collect_num];
    } else {
    self.dosageLabel.text = [NSString stringWithFormat:@"水表读数: %@ 吨",self.queryModel.collect_num];
    self.collect_avg.text = [NSString stringWithFormat:@"水表流量: %@m³/h",self.queryModel.collect_avg];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
