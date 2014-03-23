//
//  FiltersViewController.m
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/22/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "FiltersViewController.h"
#import "Filter.h"
#import "FilterCell.h"

@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *filterGroupTitles;
@property (nonatomic, strong) NSArray *nibsForSections;
@property (nonatomic, strong) NSArray *filtersForSections;
@property (nonatomic) BOOL isCategoriesExpanded;
@end

@implementation FiltersViewController

- (NSArray *)filterGroupTitles
{
    return @[@"Sort by", @"Distance", @"Most Popular", @"Categories"];
}

- (NSArray *)nibsForSections
{
    return @[@"SelectCell", @"SelectCell",
            @"SwitchFilterCell", @"SwitchFilterCell"];
}

- (BOOL)isSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.nibsForSections[indexPath.section] isEqualToString:@"SelectCell"];
}

- (BOOL)isSeeAllCellAtIndexPath:(NSIndexPath *)indexPath
{
    // This eventually has to consider whether the
    return !self.isCategoriesExpanded && indexPath.section == 3 && indexPath.row == 5;
}

- (BOOL)isCategorySectionAtIndexPath:(NSIndexPath *)indexPath
{
    // This eventually has to consider whether the
    return indexPath.section == 3;
}

- (NSArray *)filtersForSections
{
    // Each section has an array of filters, so this is an array of array of filters
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    
    // Sort by
    Filter *sortbyFilter = [[Filter alloc] init];
    sortbyFilter.options = @[ @"Best Match", @"Distance", @"Highest Rated"];
    [sections addObject:@[sortbyFilter]];
    
    // Distance
    Filter *distanceFilter = [[Filter alloc] init];
    distanceFilter.options = @[@"Auto", @"1km", @"5km", @"10km", @"20km"];
    [sections addObject:@[distanceFilter]];
    
    // Most Popular
    Filter *dealsFilter = [[Filter alloc] initWithText:@"Deals"];
    NSArray *popularFilters = @[dealsFilter];
    [sections addObject:popularFilters];
    
    // Categories
    NSArray *categoriesFilters = @[[[Filter alloc] initWithText:@"Thai"],
                                   [[Filter alloc] initWithText:@"Chinese"],
                                   [[Filter alloc] initWithText:@"American"],
                                   [[Filter alloc] initWithText:@"French"],
                                   [[Filter alloc] initWithText:@"German"],
                                   [[Filter alloc] initWithText:@"Hawaiin"],
                                   [[Filter alloc] initWithText:@"Mexican"],
                                   [[Filter alloc] initWithText:@"Italian"]];
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
    self.tableView.delegate = self;
    
    // Register the custom row nibs
    UINib *selectCellNib = [UINib nibWithNibName:@"SelectCell" bundle:nil];
    [self.tableView registerNib:selectCellNib forCellReuseIdentifier:@"SelectCell"];
    
    UINib *switchCellNib = [UINib nibWithNibName:@"SwitchFilterCell" bundle:nil];
    [self.tableView registerNib:switchCellNib forCellReuseIdentifier:@"SwitchFilterCell"];
    
    UINib *seeAllCellNib = [UINib nibWithNibName:@"SeeAllCell" bundle:nil];
    [self.tableView registerNib:seeAllCellNib forCellReuseIdentifier:@"SeeAllCell"];
    
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
    NSInteger numRows = filters.count;
    if (section == 3 && !self.isCategoriesExpanded) {
        numRows = numRows > 5 ? 6 : numRows;
    }
    return numRows;
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
    UITableViewCell *cell = nil;
    if ([self isSeeAllCellAtIndexPath:indexPath]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"SeeAllCell" forIndexPath:indexPath];
    } else {
        NSString *nibForSection = self.nibsForSections[indexPath.section];
        FilterCell *filterCell = [self.tableView dequeueReusableCellWithIdentifier:nibForSection forIndexPath:indexPath];
        filterCell.filter = (self.filtersForSections[indexPath.section])[indexPath.row];
        cell = filterCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isSelectRowAtIndexPath:indexPath]) {
        // animate the additional rows for select choice
    } else {
        // deselect
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([self isSeeAllCellAtIndexPath:indexPath]) {
            // Expand categories section
            self.isCategoriesExpanded = YES;

            NSArray *categories = self.filtersForSections[3];
            NSMutableArray *newRowIndexPaths = [[NSMutableArray alloc] init];
            for (int i=6; i<categories.count; i++) {
                [newRowIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:3]];
            }
            [self.tableView insertRowsAtIndexPaths:newRowIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end
