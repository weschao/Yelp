//
//  FilterViewController.m
//  Yelp
//
//  Created by Wes Chao on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "SettingCell.h"

@interface FilterViewController ()<UITableViewDataSource, UITableViewDelegate, SettingCellDelegate>

@property NSMutableArray *selectedSettings;
@property BOOL settingDistance;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"Filters";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
    
    [self.filterTableView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellReuseIdentifier:@"SettingCell"];
    self.filterTableView.rowHeight = UITableViewAutomaticDimension;

    // this is super clowny but it works
    self.selectedSettings = [NSMutableArray arrayWithObjects:
                             [NSNumber numberWithInt:0], // index of the selected sort
                             [NSNumber numberWithInt:0], // index of the selected distance
                             [NSNumber numberWithInt:0], // whether deals is on or not (so clowny)
                             nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Apply"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(onApplyButton)];

}

- (void) onApplyButton {
    NSDictionary * options = [NSDictionary dictionaryWithObject:self.selectedSettings forKey:@"selectedSettings"];
    
    if ([self.delegate respondsToSelector:@selector(updateFilterWithOptions:)])
        [self.delegate updateFilterWithOptions:options];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section)
    {
        case 0:
            return 3;
            break;
        case 1:
            return self.settingDistance ? 3 : 1;
            break;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row) {
            case 0:
                cell.settingNameLabel.text = @"Best Match";
                break;
            case 1:
                cell.settingNameLabel.text = @"Distance";
                break;
            case 2:
                cell.settingNameLabel.text = @"Highest Rated";
        }
            break;
        case 1:
        {
            long switchVariable = (self.settingDistance) ? indexPath.row : [self.selectedSettings[indexPath.section] intValue];
            switch (switchVariable) {
                case 0:
                    cell.settingNameLabel.text = @"Walking distance (0.3 mi)";
                    break;
                case 1:
                    cell.settingNameLabel.text = @"Short drive (5 mi)";
                    break;
                case 2:
                    cell.settingNameLabel.text = @"Long drive (20 mi)";
            }
            break;
        }
        case 2:
            cell.settingNameLabel.text = @"Show deals only";
    }
    
    cell.delegate = self;

    // only allow one switch to be set for sort and distance
    if (indexPath.section == 0 || (indexPath.section == 1 && self.settingDistance))
    {
        NSNumber * selectedRowForSection = self.selectedSettings[indexPath.section];
        cell.settingSwitch.on = indexPath.row == [selectedRowForSection integerValue];
    }
    else if (indexPath.section == 1)
    {
        cell.settingSwitch.on = YES;
    }
    else
    {
        cell.settingSwitch.on = [self.selectedSettings[indexPath.section] boolValue];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Sort by";
            break;
        case 1:
            sectionName = @"Distance";
            break;
            // ...
        case 2:
            sectionName = @"Deals";
            break;
        default:
            sectionName = @"Categories";
            break;
    }
    return sectionName;
}

- (void)didChangeSwitch:(SettingCell *)settingCell {
    NSIndexPath * indexPath = [self.filterTableView indexPathForCell:settingCell];
    
    // update the selectedSettings array
    if (indexPath.section == 0 || (indexPath.section == 1 && self.settingDistance))
        [self.selectedSettings replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithLong:indexPath.row]];
    else if (indexPath.section == 2)
        [self.selectedSettings replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:settingCell.settingSwitch.on]];
    
    // if we just selected a new distance, collapse the view
    if (indexPath.section == 1 && settingCell.settingSwitch.on)
    {
        self.settingDistance = NO;
    }
    
    NSLog(@"%@", self.selectedSettings);
    [self.filterTableView reloadData];
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && !self.settingDistance)
    {
        self.settingDistance = YES;
        [self.filterTableView reloadData];
    }
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
