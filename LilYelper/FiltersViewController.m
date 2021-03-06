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

@property (nonatomic, strong) NSString *sortByValue;
@property (nonatomic) BOOL isSortByExpanded;

@property (nonatomic, strong) NSArray *mostPopularFilters;

@property (nonatomic) NSInteger distanceValue;
@property (nonatomic) BOOL isDistanceExpanded;

@property (nonatomic, strong) NSArray *categoryFilters;
@property (nonatomic) BOOL isCategoriesExpanded;


@end

static int const SORTBY_SECTION = 0;
static int const MOSTPOPULAR_SECTION = 1;
static int const DISTANCE_SECTION = 2;
static int const CATEGORIES_SECTION = 3;
#define SECTIONS @[@"Sort by", @"Most Popular", @"Distance", @"Categories"]
#define SORTBY_OPTIONS @[@"Best Match", @"Distance", @"Highest Rated"]
#define DISTANCE_OPTIONS @[@1, @5, @10, @20, @50] //kilometers

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSArray *)categoryFilters
{
    if (!_categoryFilters) {
        _categoryFilters = @[ [[Filter alloc] initWithText:@"Afghan" key:@"afghani"],
                              [[Filter alloc] initWithText:@"African" key:@"african"],
                              [[Filter alloc] initWithText:@"Senegalese" key:@"senegalese"],
                              [[Filter alloc] initWithText:@"South African" key:@"southafrican"],
                              [[Filter alloc] initWithText:@"American (New)" key:@"newamerican"],
                              [[Filter alloc] initWithText:@"American (Traditional)" key:@"tradamerican"],
                              [[Filter alloc] initWithText:@"Arabian" key:@"arabian"],
                              [[Filter alloc] initWithText:@"Argentine" key:@"argentine"],
                              [[Filter alloc] initWithText:@"Armenian" key:@"armenian"],
                              [[Filter alloc] initWithText:@"Asian Fusion" key:@"asianfusion"],
                              [[Filter alloc] initWithText:@"Australian" key:@"australian"],
                              [[Filter alloc] initWithText:@"Bangladeshi" key:@"bangladeshi"],
                              [[Filter alloc] initWithText:@"Barbeque" key:@"bbq"],
                              [[Filter alloc] initWithText:@"Brasseries" key:@"brasseries"],
                              [[Filter alloc] initWithText:@"Breakfast & Brunch" key:@"breakfast_brunch"]
                             ];
    }
    return _categoryFilters;
}

- (void)setFilters:(NSDictionary *)filters
{
    // Change all filters based on dictionary values
    self.sortByValue = SORTBY_OPTIONS[[filters[@"sort"] integerValue]];
    
    // Most popular only has deals right now, but may have more
    BOOL dealsOn = [filters[@"deals_filter"] boolValue];
    self.mostPopularFilters = @[[[Filter alloc] initWithText:@"Deals" on:dealsOn]];
    
    NSNumber *distance = [NSNumber numberWithInt:[filters[@"radius_filter"] integerValue]/1000];
    NSUInteger distanceIndex = [DISTANCE_OPTIONS indexOfObject:distance];
    self.distanceValue = [DISTANCE_OPTIONS[distanceIndex] integerValue];
    
    NSString *categoriesString = filters[@"category_filter"];
    NSArray *categories = [categoriesString componentsSeparatedByString:@","];
    for (NSString *category in categories) {
        NSUInteger categoryIndex = [self.categoryFilters indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            Filter *filter = (Filter *)obj;
            *stop = [filter.key isEqualToString:category];
            return *stop;
        }];
        if (categoryIndex != NSNotFound) {
            ((Filter *)self.categoryFilters[categoryIndex]).on = YES;
        }
    }
}

- (void)searchBarButtonPress
{
    self.delegate.isFiltersChanged = YES;
    NSNumber *sortByNumber = [NSNumber numberWithUnsignedInteger:[SORTBY_OPTIONS indexOfObject:self.sortByValue]];
    Filter *dealsFilter = self.mostPopularFilters[0];
    
    // handle categories
    NSArray *categoriesOn = [self.categoryFilters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.on == YES"]];
    NSMutableArray *categoriesOnKeys = [[NSMutableArray alloc] init];
    for (Filter *category in categoriesOn) {
        [categoriesOnKeys addObject:category.key];
    }
    self.delegate.filters = @{@"sort":sortByNumber,
                              @"radius_filter":[NSNumber numberWithInt:(self.distanceValue*1000)],
                              @"deals_filter":@(dealsFilter.on),
                              @"category_filter":[categoriesOnKeys componentsJoinedByString:@","]};
    // Want to update the filters on the delegate
    [self.delegate hideFilters];
}

- (void)cancelBarButtonPress
{
    [self.delegate hideFilters];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    switch (section) {
        case SORTBY_SECTION:
            numRows = self.isSortByExpanded ? SORTBY_OPTIONS.count : 1;
            break;
        case MOSTPOPULAR_SECTION:
            numRows = self.mostPopularFilters.count;
            break;
        case DISTANCE_SECTION:
            numRows = self.isDistanceExpanded ? DISTANCE_OPTIONS.count : 1;
            break;
        case CATEGORIES_SECTION:
            numRows = self.categoryFilters.count;
            if (!self.isCategoriesExpanded && numRows > 5) {
                numRows = 6;
            }
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

#pragma mark - Distance

- (UITableViewCell *)cellForDistanceSectionWithIndexPath:(NSIndexPath *)indexPath
{
    SelectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SelectCell" forIndexPath:indexPath];
    // Do different things depending on whether this row is an expansion row or not
    if (indexPath.row == 0) {
        cell.text = [NSString stringWithFormat:@"%d km", self.distanceValue];
        if (self.isDistanceExpanded) {
            [cell flipDropdownLabel];
        }
    } else {
        NSArray *remainingOptions = [self remainingDistanceOptions];
        cell.text = [NSString stringWithFormat:@"%d km", [remainingOptions[indexPath.row-1] integerValue]];
        [cell hideDropdownLabel];
    }
    return cell;
}

- (NSArray *)remainingDistanceOptions
{
    NSNumber *distance = [NSNumber numberWithInt:self.distanceValue];
    return [DISTANCE_OPTIONS filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self != %@", distance]];
}

- (void)didSelectDistanceRowWithIndexPath:(NSIndexPath *)indexPath
{
    BOOL wasExpanded = self.isDistanceExpanded;
    NSArray *remainingOptions = [self remainingDistanceOptions];
    if (indexPath.row == 0) {
        // Simply toggle the expanded state
        self.isDistanceExpanded = !wasExpanded;
    } else {
        // Select a new value and then close the select
        self.isDistanceExpanded = NO;
        self.distanceValue = [remainingOptions[indexPath.row-1] integerValue];
    }
    
    NSMutableArray *changingIndexPaths = [[NSMutableArray alloc] init];
    for (int i=0; i<remainingOptions.count; i++) {
        [changingIndexPaths addObject:[NSIndexPath indexPathForRow:i+1 inSection:DISTANCE_SECTION]];
    }
    if (!wasExpanded && self.isDistanceExpanded) {
        // insert rows
        // Need to change dropdown arrow to up
        [self.tableView insertRowsAtIndexPaths:changingIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:DISTANCE_SECTION]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (wasExpanded && !self.isDistanceExpanded) {
        // close rows
        // Need to change dropdown arrow to down
        [self.tableView deleteRowsAtIndexPaths:changingIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:DISTANCE_SECTION]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Sort By

- (UITableViewCell *)cellForSortBySectionWithIndexPath:(NSIndexPath *)indexPath
{
    SelectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SelectCell" forIndexPath:indexPath];
    // Do different things depending on whether this row is an expansion row or not
    if (indexPath.row == 0) {
        cell.text = self.sortByValue;
        if (self.isSortByExpanded) {
            [cell flipDropdownLabel];
        }
    } else {
        NSArray *remainingOptions = [self remainingSortByOptions];
        cell.text = remainingOptions[indexPath.row-1];
        [cell hideDropdownLabel];
    }
    return cell;
}

- (NSArray *)remainingSortByOptions
{
    return [SORTBY_OPTIONS filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self != %@", self.sortByValue]];
}

- (void)didSelectSortByRowWithIndexPath:(NSIndexPath *)indexPath
{
    BOOL wasSortByExpanded = self.isSortByExpanded;
    NSArray *remainingOptions = [self remainingSortByOptions];
    if (indexPath.row == 0) {
        // Simply toggle the expanded state
        self.isSortByExpanded = !wasSortByExpanded;
    } else {
        // Select a new value and then close the select
        self.isSortByExpanded = NO;
        self.sortByValue = remainingOptions[indexPath.row-1];
    }
    
    NSMutableArray *changingIndexPaths = [[NSMutableArray alloc] init];
    for (int i=0; i<remainingOptions.count; i++) {
        [changingIndexPaths addObject:[NSIndexPath indexPathForRow:i+1 inSection:SORTBY_SECTION]];
    }
    if (!wasSortByExpanded && self.isSortByExpanded) {
        // insert rows
        // Need to change dropdown arrow to up
        [self.tableView insertRowsAtIndexPaths:changingIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:SORTBY_SECTION]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (wasSortByExpanded && !self.isSortByExpanded) {
        // close rows
        // Need to change dropdown arrow to down
        [self.tableView deleteRowsAtIndexPaths:changingIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:SORTBY_SECTION]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Most Popular
- (UITableViewCell *)cellForMostPopularSectionWithIndexPath:(NSIndexPath *)indexPath
{
    SwitchFilterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchFilterCell" forIndexPath:indexPath];
    cell.filter = self.mostPopularFilters[indexPath.row];
    return cell;
}

#pragma mark - Categories
- (UITableViewCell *)cellForCategorySectionWithIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isCategoriesExpanded && indexPath.row == 5) {
        return [self.tableView dequeueReusableCellWithIdentifier:@"SeeAllCell" forIndexPath:indexPath];
    }
    
    SwitchFilterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchFilterCell" forIndexPath:indexPath];
    // Handle collapsed by eventually displaying show all
    cell.filter = self.categoryFilters[indexPath.row];
    return cell;
}

- (void)didSelectCategoryRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isCategoriesExpanded && indexPath.row == 5) {
        // Show all category filters
        self.isCategoriesExpanded = YES;
        
        NSMutableArray *newRowIndexPaths = [[NSMutableArray alloc] init];
        for (int i=6; i<self.categoryFilters.count; i++) {
            [newRowIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:CATEGORIES_SECTION]];
        }
        [self.tableView insertRowsAtIndexPaths:newRowIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:CATEGORIES_SECTION]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case SORTBY_SECTION:
            cell = [self cellForSortBySectionWithIndexPath:indexPath];
            break;
        case MOSTPOPULAR_SECTION:
            cell = [self cellForMostPopularSectionWithIndexPath:indexPath];
            break;
        case DISTANCE_SECTION:
            cell = [self cellForDistanceSectionWithIndexPath:indexPath];
            break;
        case CATEGORIES_SECTION:
            cell = [self cellForCategorySectionWithIndexPath:indexPath];
            break;
            
        default:
            NSLog(@"Don't recognize section, can't return cell!!");
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // always deselect the row
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case SORTBY_SECTION:
            [self didSelectSortByRowWithIndexPath:indexPath];
            break;
        case MOSTPOPULAR_SECTION:
            // do nothing
            break;
        case DISTANCE_SECTION:
            [self didSelectDistanceRowWithIndexPath:indexPath];
            break;
        case CATEGORIES_SECTION:
            [self didSelectCategoryRowWithIndexPath:indexPath];
            break;
            
        default:
            NSLog(@"don't recognize section you selected!");
            break;
    }
}

@end
