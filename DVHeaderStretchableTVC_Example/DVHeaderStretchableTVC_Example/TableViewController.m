//
//  TableViewController.m
//  DVHeaderStretchableTVC_Example
//
//  Created by Denis Vashkovski on 15/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "TableViewController.h"

#import "UITableViewController+HeaderStretchable.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - DVHeaderStretchableTVCDelegate
- (CGFloat)dv_heightForStretchableView {
    return 100.;
}

- (UIView *)dv_viewForStretchableView {
    UILabel *label = [UILabel new];
    [label setText:@"Elastic header"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor lightGrayColor]];
    return label;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell ID" forIndexPath:indexPath];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"Cell %ld", indexPath.row]];
    
    return cell;
}

@end
