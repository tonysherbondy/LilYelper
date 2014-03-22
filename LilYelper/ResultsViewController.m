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

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ResultTableViewCell *prototypeResultCell;
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation ResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Creating some fake data
        self.results = [[NSMutableArray alloc] init];
        for (int i=0; i<20; i++) {
            [self.results addObject:[[Result alloc] init]];
        }
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
}

//-(ResultTableViewCell *)prototypeResultCell
//{
//    // lazily instantiate and hold onto the prototype
//    if (!_prototypeResultCell) {
//        _prototypeResultCell = [self.tableView dequeueReusableCellWithIdentifier:@"ResultTableViewCell"];
//    }
//    return _prototypeResultCell;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ResultTableViewCell" forIndexPath:indexPath];
//    cell.textLabel.text = @"duhmb";
    cell.result = self.results[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [ResultTableViewCell heightWithPrototype:self.prototypeResultCell result:self.results[0]];
    return 100;
}

@end
