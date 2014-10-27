//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "ListingCell.h"
#import "UIImageView+AFNetworking.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"Dm2vp4hvG06WwP6ql2fnlA";
NSString * const kYelpConsumerSecret = @"MJ-u1ClEfVk43xDK7XMvyhx2Bss";
NSString * const kYelpToken = @"OsTRimjntdxm-GiWwJie0_9VVqGieFlT";
NSString * const kYelpTokenSecret = @"e4up2VTCXfiJnLPMiQIWUGsCV2I";

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FilterViewControllerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property NSArray* listings;
@property (nonatomic) ListingCell* prototypeBusinessCell;
@property NSMutableDictionary* searchParameters;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up the table view with the custom cell
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib: [UINib nibWithNibName:@"ListingCell" bundle: nil]
         forCellReuseIdentifier:@"ListingCell"];
    
    // add a search bar to the navigation bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 250.0, 44.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    searchBar.delegate = self;
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
    
    // add filter button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Filter"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(onFilterButton)];

    self.searchParameters = [NSMutableDictionary dictionaryWithDictionary:@{@"term": @"Restaurant", @"ll" : @"37.774866,-122.394556", @"sort": @"0"}];

    [self reloadData];

}


- (void) updateFilterWithOptions:(NSDictionary *)options
{
    NSArray * settings = [options valueForKey:@"selectedSettings"];
    
    // sort
    [self.searchParameters setValue:[settings objectAtIndex:0] forKey:@"sort"];

    switch ([[settings objectAtIndex:1] integerValue])
    {
        case 0: // walking distance, 0.3mi
            [self.searchParameters setValue:[NSNumber numberWithFloat:0.3f*1600] forKey:@"radius_filter"];
            break;
        case 1: // short drive, 5 mi
            [self.searchParameters setValue:[NSNumber numberWithFloat:5*1600] forKey:@"radius_filter"];
            break;
        case 2: // long drive, 20 mi
            [self.searchParameters setValue:[NSNumber numberWithFloat:20*1600] forKey:@"radius_filter"];
    }
    
    // deals
    [self.searchParameters setValue:[settings objectAtIndex:2] forKey:@"deals_filter"];

    // convert category set to a string
    NSArray *categoryArray = [[options valueForKey:@"selectedCategories"] allObjects];
    NSString *categoryString = [categoryArray componentsJoinedByString:@","];
    
    [self.searchParameters setValue:categoryString forKey:@"category_filter"];

    //    NSLog(@"%@", self.searchParameters);
    
    [self reloadData];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)onFilterButton {
    FilterViewController * fvc = [[FilterViewController alloc] init];
    fvc.delegate = self;
    
    [self.navigationController pushViewController:fvc animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // if the user just erased all the text, reload the search query
    if ([searchText isEqual:@""])
        [self reloadData];
    
    // otherwise, filter results based on the search request
    else
    {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", searchText];
        self.listings = [self.listings filteredArrayUsingPredicate:searchPredicate];
        
        [self.tableView reloadData];
    }
}

- (ListingCell *)prototypeBusinessCell {
    if (_prototypeBusinessCell == nil) {
        _prototypeBusinessCell = [self.tableView dequeueReusableCellWithIdentifier:@"ListingCell"];
    }
    
    return _prototypeBusinessCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *listing = self.listings[indexPath.row];
    NSString *photoUrl = [listing valueForKeyPath:@"image_url"];
    [self.prototypeBusinessCell.photoView setImageWithURL:[NSURL URLWithString:photoUrl]];
    
    CGSize size = [self.prototypeBusinessCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (void) reloadData
{
    // make a request for data
    [self.client searchWithOptions:self.searchParameters success:^(AFHTTPRequestOperation *operation, id response) {

//        NSLog(@"response: %@", response);
        
        self.listings = response[@"businesses"];
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        
    }];

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listings.count;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListingCell *cell = [[ListingCell alloc] init];
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"ListingCell"];
    
    NSDictionary *listing = self.listings[indexPath.row];
    
    // restaurant image
    NSString *photoUrl = [listing valueForKeyPath:@"image_url"];
    [cell.photoView setImageWithURL:[NSURL URLWithString:photoUrl]];

    // restaurant name
    cell.nameLabel.text = [listing valueForKeyPath:@"name"];

    // star rating and reviews
    NSString *starRatingUrl = [listing valueForKeyPath:@"rating_img_url"];
    [cell.starImageView setImageWithURL:[NSURL URLWithString:starRatingUrl]];
    
    cell.reviewCountLabel.text = [NSString stringWithFormat:@"%@ reviews", [listing valueForKeyPath:@"review_count"]];
    
    // address: street address plus neighborhood
    // assume address and neighborhood are blank to avoid index out of bounds crashes
    NSString *address = @"";
    NSString *format = @"%@%@";
    if ([[listing valueForKeyPath:@"location.address"] count] > 0)
    {
        address = [[listing valueForKeyPath:@"location.address"] objectAtIndex:0];
        format = @"%@, %@";
    }
    
    NSString *neighborhood = @"";
    if ([[listing valueForKeyPath:@"location.neighborhoods"] count] > 0)
        neighborhood = [[listing valueForKeyPath:@"location.neighborhoods"] objectAtIndex:0];
    cell.addressLabel.text = [NSString stringWithFormat:format, address, neighborhood];
    
    // categories
    cell.categoryLabel.text = [[[listing valueForKeyPath:@"categories"] objectAtIndex:0] objectAtIndex:0];

    cell.photoView.alpha = 0.0;
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:2.0];
    cell.photoView.alpha = 1.0;
    [UIView commitAnimations];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
