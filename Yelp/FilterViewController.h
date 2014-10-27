//
//  FilterViewController.h
//  Yelp
//
//  Created by Wes Chao on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate <NSObject>

@optional
- (void) updateFilterWithOptions:(NSDictionary*)options;
@end

@interface FilterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (nonatomic, weak) NSObject<FilterViewControllerDelegate>  *delegate;

@end
