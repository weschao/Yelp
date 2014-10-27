//
//  SettingCell.m
//  FacebookDemo
//
//  Created by Raylene Yung on 10/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate didChangeSwitch: self];
}
@end
