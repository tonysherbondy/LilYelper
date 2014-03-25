//
//  ResultsViewController.m
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/20/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultTableViewCell.h"
#import "Result.h"
#import "YelpClient.h"
#import <MBProgressHUD.h>
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSString *searchTerm;
@end

@implementation ResultsViewController

@synthesize isFiltersChanged = _isFiltersChanged;
@synthesize filters = _filters;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self search];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *resultCellNib = [UINib nibWithNibName:@"ResultTableViewCell" bundle:nil];
    [self.tableView registerNib:resultCellNib forCellReuseIdentifier:@"ResultTableViewCell"];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.showsCancelButton = NO;
    [searchBar sizeToFit];
    searchBar.delegate = self;
    
    self.navigationItem.titleView = searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(showFilter)];

}

- (NSDictionary *)filters
{
    if (!_filters) {
        // Initialize simple dictionary of filters
        _filters = @{@"sort":@0,
                     @"radius_filter":@100,
                     @"deals_filter":@0,
                     @"category_filter":@""};
    }
    return _filters;
}

- (void)showFilter
{
    // Create the root view controller for the navigation controller
    // The new view controller configures a Cancel and Done button for the
    // navigation bar.
    FiltersViewController *filtersController = [[FiltersViewController alloc] init];
    
    // Configure
//    filtersController.filters = self.filters;
    filtersController.delegate = self;
    
    // Create the navigation controller and present it.
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:filtersController];
    [self presentViewController:navigationController animated:YES completion: nil];
}

-(void)hideFilters
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.isFiltersChanged) {
            [self search];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ResultTableViewCell" forIndexPath:indexPath];
    cell.result = self.results[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ResultTableViewCell heightWithResult:self.results[indexPath.row]];
}

- (NSString *)searchTerm
{
    if (!_searchTerm) {
        _searchTerm = @"";
    }
    return _searchTerm;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchTerm = searchText;
    [self search];
}

- (void) search {
    
    // Yelp API
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    // Yelp Parameters
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:self.filters];
    parameters[@"term"] = self.searchTerm;
    parameters[@"location"] = @"San Francisco";
    NSLog(@"parameters: %@", parameters);
    self.isFiltersChanged = NO;

    [MBProgressHUD hideHUDForView:self.view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Searching...";
    [self.client searchWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        self.results = [Result resultsFromArray:response[@"businesses"]];
        
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [self hideNetworkErrorView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [self showNetworkErrorView];
    }];
}

@end
