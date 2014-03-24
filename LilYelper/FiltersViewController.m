//
//  FiltersViewController.m
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/22/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "FiltersViewController.h"
#import "Filter.h"
#import "SelectCell.h"
#import "SwitchFilterCell.h"

@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *filterGroupTitles;
@property (nonatomic, strong) NSArray *nibsForSections;
@property (nonatomic, strong) NSArray *filtersForSections;
@property (nonatomic) BOOL isCategoriesExpanded;

@property (nonatomic, strong) NSString *sortByValue;
@property (nonatomic, strong) NSSet *mostPopularFilters;
@end

// TODO
//      - Do sortby more explicitly
//      - Do Most Popular

static int const SORTBY_SECTION = 0;
static int const MOSTPOPULAR_SECTION = 1;
//static int const RADIUS_SECTION = 1;
//static int const MOSTPOPULAR_SECTION = 2;
//static int const CATEGORIES_SECTION = 3;
#define SECTIONS @[@"Sort by", @"Most Popular"]
#define SORTBY_OPTIONS @[@"Best Match", @"Distance", @"Highest Rated"]
#define MOSTPOPULAR_OPTIONS @[@"Deals"]

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (NSArray *)filterGroupTitles
//{
//    return @[@"Sort by", @"Distance", @"Most Popular", @"Categories"];
//}
//
//- (NSArray *)nibsForSections
//{
//    return @[@"SelectCell", @"SelectCell",
//            @"SwitchFilterCell", @"SwitchFilterCell"];
//}

//- (BOOL)isSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.nibsForSections[indexPath.section] isEqualToString:@"SelectCell"];
//}

//- (BOOL)isSeeAllCellAtIndexPath:(NSIndexPath *)indexPath
//{
//    // This eventually has to consider whether the
//    return !self.isCategoriesExpanded && indexPath.section == CATEGORIES_SECTION && indexPath.row == 5;
//}

//- (BOOL)isCategorySectionAtIndexPath:(NSIndexPath *)indexPath
//{
//    // This eventually has to consider whether the
//    return indexPath.section == CATEGORIES_SECTION;
//}

- (NSString *)sortByValue
{
    if (!_sortByValue) {
        _sortByValue = SORTBY_OPTIONS[0];
    }
    return _sortByValue;
}

- (NSArray *)filtersForSections
{
    // Each section has an array of filters, so this is an array of array of filters
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    
    // Sort by
    Filter *sortbyFilter = [[Filter alloc] init];
    sortbyFilter.options = @[@"Best Match", @"Distance", @"Highest Rated"];
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
    [self.delegate hideFilters];
}

- (void)searchBarButtonPress
{
    // Want to update the filters on the delegate
    self.delegate.isFiltersChanged = YES;
    [self.delegate hideFilters];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray *filters = self.filtersForSections[section];
//    NSInteger numRows = filters.count;
//    if (section == 3 && !self.isCategoriesExpanded) {
//        numRows = numRows > 5 ? 6 : numRows;
//    }
//    return numRows;
    
    NSInteger numRows = 0;
    switch (section) {
        case SORTBY_SECTION:
            // Check to see if it is collapsed, then return options
            numRows = 1;
            break;
        case MOSTPOPULAR_SECTION:
            numRows = MOSTPOPULAR_OPTIONS.count;
            break;
        default:
            NSLog(@"Bad section!!!");
            break;
    }
    return numRows;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTIONS.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return SECTIONS[section];
}

- (UITableViewCell *)cellForSortBySectionWithIndexPath:(NSIndexPath *)indexPath
{
    SelectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SelectCell" forIndexPath:indexPath];
    // Do different things depending on whether this row is an expansion row or not
    cell.text = self.sortByValue;
    return cell;
}

- (UITableViewCell *)cellForMostPopularSectionWithIndexPath:(NSIndexPath *)indexPath
{
    SwitchFilterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchFilterCell" forIndexPath:indexPath];
    // Need to see if the filter is in the set to know if it is on
    cell.on = NO;
    cell.text = MOSTPOPULAR_OPTIONS[indexPath.row];
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = nil;
//    if ([self isSeeAllCellAtIndexPath:indexPath]) {
//        cell = [self.tableView dequeueReusableCellWithIdentifier:@"SeeAllCell" forIndexPath:indexPath];
//    } else {
//        NSString *nibForSection = self.nibsForSections[indexPath.section];
//        FilterCell *filterCell = [self.tableView dequeueReusableCellWithIdentifier:nibForSection forIndexPath:indexPath];
//        filterCell.filter = (self.filtersForSections[indexPath.section])[indexPath.row];
//        cell = filterCell;
//    }
//    return cell;
    
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case SORTBY_SECTION:
            cell = [self cellForSortBySectionWithIndexPath:indexPath];
            break;
        case MOSTPOPULAR_SECTION:
            cell = [self cellForMostPopularSectionWithIndexPath:indexPath];
            break;
            
        default:
            NSLog(@"Don't recognize section, can't return cell!!");
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self isSelectRowAtIndexPath:indexPath]) {
//        // animate the additional rows for select choice
//    } else {
//        // deselect
//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//        if ([self isSeeAllCellAtIndexPath:indexPath]) {
//            // Expand categories section
//            self.isCategoriesExpanded = YES;
//
//            NSArray *categories = self.filtersForSections[3];
//            NSMutableArray *newRowIndexPaths = [[NSMutableArray alloc] init];
//            for (int i=6; i<categories.count; i++) {
//                [newRowIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:3]];
//            }
//            [self.tableView insertRowsAtIndexPaths:newRowIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//    }
}

@end
