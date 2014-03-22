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
@end

@implementation ResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    if (indexPath.row % 2) {
        cell.resultText = @"A moderately long string that should suffice to detect multiline usage.";
    } else {
        cell.resultText = @"Short String";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [ResultTableViewCell heightWithPrototype:self.prototypeResultCell result:self.results[0]];
    
    NSString *text = nil;
    if (indexPath.row % 2) {
        text = @"A moderately long string that should suffice to detect multiline usage.";
    } else {
        text = @"Short String";
    }
    UIFont *fontText = [UIFont systemFontOfSize:17.0];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontText}
                                     context:nil];
    return rect.size.height;
}

@end
