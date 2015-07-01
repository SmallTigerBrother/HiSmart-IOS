//
//  HIRUserInfoTableViewController.m
//  HiRemote
//
//  Created by parker on 6/26/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRUserInfoTableViewController.h"

@interface HIRUserInfoTableViewController ()
@property (nonatomic, assign)BOOL switchOn;
@end

@implementation HIRUserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"myAccount", @"");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"close", @"") style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    headView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1];
    UILabel *hello = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
    hello.text = NSLocalizedString(@"hello", @"");
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 100, 40)];
    name.font = [UIFont boldSystemFontOfSize:17];
    name.text = @"Soya90";
    [headView addSubview:hello];
    [headView addSubview:name];
    self.tableView.tableHeaderView = headView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    [logout setTitleColor:[UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1] forState:UIControlStateNormal];
    logout.frame = CGRectMake(100, 20, self.view.frame.size.width-200, 40);
    [logout setTitle:NSLocalizedString(@"logout", @"") forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:logout];
    self.tableView.tableFooterView = footView;
}

- (void)logoutClick:(id)sender {
    
}

- (void)theSwitchChange:(id)sender {
    _switchOn = ((UISwitch *)sender).on;
}
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifyCell = @"identifyCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifyCell];
    if (cell == nil) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyCell];
    }
    long section = [indexPath section];
    long row = [indexPath row];
    if (section == 0) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
        imgV.image = [UIImage imageNamed:@"facebook"];
        UILabel *facebook = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 40)];
        facebook.text = NSLocalizedString(@"facebook", @"");
        UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 5, 70,30)];
        [theSwitch setOn:_switchOn animated:NO];
        [theSwitch addTarget:self action:@selector(theSwitchChange:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:imgV];
        [cell.contentView addSubview:facebook];
        [cell.contentView addSubview:theSwitch];
    }else if (section == 1) {
        if (row == 0) {
            cell.textLabel.text = NSLocalizedString(@"rateus10", @"");
        }else if (row == 1) {
            cell.textLabel.text = NSLocalizedString(@"rateus11", @"");
        }else if (row == 2) {
            cell.textLabel.text = NSLocalizedString(@"rateus12", @"");
        }
    }else if (section == 2) {
        if (row == 0) {
            cell.textLabel.text = NSLocalizedString(@"rateus20", @"");
        }else if (row == 1) {
            cell.textLabel.text = NSLocalizedString(@"rateus21", @"");
        }else if (row == 2) {
            cell.textLabel.text = NSLocalizedString(@"rateus22", @"");
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 50;
    }
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width, 50)];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 30)];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    if (section == 1) {
        label.text = NSLocalizedString(@"rateus", @"");
        return view;
    }else if(section == 2) {
        label.text = NSLocalizedString(@"about", @"");
        return view;
    }
    return nil;
}


- (void)dealloc {
    NSLog(@"user dealloc");
}

@end
