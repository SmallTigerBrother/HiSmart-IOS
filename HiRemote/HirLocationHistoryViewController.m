//
//  ALLocationHistoryViewController.m
//  antiLost
//
//  Created by minfengliu on 15/6/27.
//  Copyright (c) 2015年 spark. All rights reserved.
//

#import "HirLocationHistoryViewController.h"
#import "HirLocationHistoryTableCell.h"
#import "MultiFunctionTableView.h"

@interface HirLocationHistoryViewController ()
<UISearchDisplayDelegate,
UITableViewDataSource,
UITableViewDelegate,
MultiFunctionTableViewDelegate>
@property (nonatomic, strong)NSArray *data;
@property (nonatomic, strong)NSArray *filterData;
@property (nonatomic, strong)UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong)MultiFunctionTableView *tableView;

@end

@implementation HirLocationHistoryViewController
@synthesize searchDisplayController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Location history", nil);
    
    self.tableView = [[MultiFunctionTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.multiTableDelegate = self;
    [self.view addSubview:self.tableView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    
    // 添加 searchbar 到 headerview
//    self.tableView.tableHeaderView = searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate = self;
    
    NSMutableArray *list = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSInteger i = 1; i<10; i++) {
        NSInteger re = i * 1111;
        NSString *s = [NSString stringWithFormat:@"%ld",(long)re];
        [list addObject:s];
    }
    self.data = list;
    
    self.tableView.tableHeaderView = searchBar;
}

/*
 * 如果原 TableView 和 SearchDisplayController 中的 TableView 的 delete 指向同一个对象
 * 需要在回调中区分出当前是哪个 TableView
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.data.count;
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",self.searchDisplayController.searchBar.text];
        self.filterData =  [[NSArray alloc] initWithArray:[self.data filteredArrayUsingPredicate:predicate]];
        return self.filterData.count;
    }
}

#pragma mark - MultiFunctionTableViewDelegate
- (void)returnCellMenuIndex:(NSIndexPath *)indexPath menuIndexNum:(NSInteger)menuIndexNum isLeftMenu:(BOOL)isLeftMenu {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"HirLocationHistoryTableCell";
    
    HirLocationHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HirLocationHistoryTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                               reuseIdentifier:cellId
                                                                           containingTableView:tableView
                                                                            leftUtilityButtons:nil
                                                                           rightUtilityButtons:@[@"right1",@"right2",@"right3"]];
        cell.cellActionDelegate = self.tableView;
    }

    if (tableView == self.tableView) {
        cell.titleLabel.text = self.data[indexPath.row];
    }else{
        cell.titleLabel.text = self.filterData[indexPath.row];
    }
    cell.contentLabel.text = @"xxxxx";
    cell.timeLabel.text = @"15/10/15:10:50";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HirLocationHistoryTableCell heightOfCellWithData:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
