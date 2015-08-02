//
//  HirTableViewController.h
//  HiRemote
//
//  Created by minfengliu on 15/8/2.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirBaseViewController.h"

@interface HirBaseTableViewController : HirBaseViewController
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *tableViewDataArr;
@property (assign) NSInteger pageNum;
@property (nonatomic, assign)BOOL validateSeparatorInset;

//创建TableView
-(void)loadTableView;

//加载TableView的数据
-(void)requestTableViewData;

@end
