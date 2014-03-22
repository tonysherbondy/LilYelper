//
//  FiltersViewController.m
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/22/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "FiltersViewController.h"
#import "Filter.h"
#import "SwitchFilterCell.h"

@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *filterGroupTitles;
@property (nonatomic, strong) NSArray *nibsForSections;
@property (nonatomic, strong) NSArray *filtersForSections;
@end

@implementation FiltersViewController

- (NSArray *)filterGroupTitles
{
    return @[@"Sort by", @"Distance", @"Most Popular", @"Categories"];
}

- (NSArray *)nibsForSections
{
    return @[@"ResultTableViewCell", @"ResultTableViewCell",
            @"SwitchFilterCell", @"SwitchFilterCell"];
}

- (NSArray *)filtersForSections
{
    // Each section has an array of filters, so this is an array of array of filters
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    
    // Sort by
    NSArray *sortbyFilters = @[[[Filter alloc] init]];
    [sections addObject:sortbyFilters];
    
    // Distance
    NSArray *distanceFilters = @[[[Filter alloc] init]];
    [sections addObject:distanceFilters];
    
    // Most Popular
    Filter *dealsFilter = [[Filter alloc] initWithText:@"Deals"];
    NSArray *popularFilters = @[dealsFilter];
    [sections addObject:popularFilters];
    
    // Categories
    Filter *thaiFilter = [[Filter alloc] initWithText:@"Thai"];
    NSArray *categoriesFilters = @[thaiFilter];
    [sections addObject:categoriesFilters];
    
    return sections;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    // Register the custom row nibs
    UINib *resultCellNib = [UINib nibWithNibName:@"ResultTableViewCell" bundle:nil];
    [self.tableView registerNib:resultCellNib forCellReuseIdentifier:@"ResultTableViewCell"];
    
    UINib *switchCellNib = [UINib nibWithNibName:@"SwitchFilterCell" bundle:nil];
    [self.tableView registerNib:switchCellNib forCellReuseIdentifier:@"SwitchFilterCell"];
    
    // Change nav bar
    self.title = @"Filters";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelBarButtonPress)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(searchBarButtonPress)];
}

- (void)cancelBarButtonPress
{
    NSLog(@"cancel");
}

- (void)searchBarButtonPress
{
    NSLog(@"search");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *filters = self.filtersForSections[section];
    return filters.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.filterGroupTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.filterGroupTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *nibForSection = self.nibsForSections[indexPath.section];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:nibForSection forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[SwitchFilterCell class]]) {
        SwitchFilterCell *switchCell = (SwitchFilterCell *)cell;
        switchCell.filter = (self.filtersForSections[indexPath.section])[indexPath.row];
    }
    return cell;
}

@end
