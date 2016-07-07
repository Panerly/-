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
    self.dosageLabel.text = [NSString stringWithFormat:@"%@ 吨",self.queryModel.collect_num];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
