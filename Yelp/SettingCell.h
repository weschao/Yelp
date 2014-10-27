//
//  SettingCell.h
//  FacebookDemo
//
//  Created by Raylene Yung on 10/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingCell;

@protocol SettingCellDelegate <NSObject>

- (void)didChangeSwitch:(SettingCell *)settingCell;

@end

@interface SettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *settingNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *settingSwitch;
@property (weak, nonatomic) id<SettingCellDelegate> delegate;
- (IBAction)switchValueChanged:(id)sender;

@end
