//
//  HirTableViewController.m
//  HiRemote
//
//  Created by minfengliu on 15/8/2.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirBaseTableViewController.h"

@interface HirBaseTableViewController ()

@end

@implementation HirBaseTableViewController


- (void)dealloc
{
    if (_tableView)
    {
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
        _tableView = nil;
    }
    [_tableViewDataArr removeAllObjects];
    _tableViewDataArr = nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _tableViewDataArr = [[NSMutableArray alloc]initWithCapacity:0];
        _pageNum = 1;
    }
    return self;
}

-(void)loadTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView = tableView;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = WHITE_COLOR;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTableView];
}

#pragma mark - requestData
-(void)requestTableViewData
{
    //子类重载
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
    
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //子类重载
    
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end