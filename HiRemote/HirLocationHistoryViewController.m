//
//  ALLocationHistoryViewController.m
//  antiLost
//
//  Created by minfengliu on 15/6/27.
//  Copyright (c) 2015年 spark. All rights reserved.
//

#import "HirLocationHistoryViewController.h"
#import "HirLocationHistoryTableCell.h"
#import "HIRMapViewController.h"
#import "HirAlertView.h"
#import "HirActionTextField.h"
#import "HirDataManageCenter+Location.h"
#import "AppDelegate.h"
#import "CLLocation+Sino.h"
#import "HIRFindViewController.h"

@interface HirLocationHistoryViewController ()
<UISearchDisplayDelegate,
UITableViewDataSource,
UITableViewDelegate,
SWTableViewCellDelegate,
UITextFieldDelegate>
{
    BOOL _tableViewHadAddLongPressGestureRec;
    BOOL _searchTableViewHadAddLongPressGestureRec;
}

@property (nonatomic, assign)HirLocationDataType locationDataType;

@property (nonatomic, strong)NSMutableArray *data;
@property (nonatomic, strong)NSArray *filterData;
@property (nonatomic, strong)UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HirActionTextField *actionTextField;
@property (nonatomic, strong)UITableView *currentTableView;
@property (nonatomic, assign)NSUInteger copyRow;
@end

@implementation HirLocationHistoryViewController
@synthesize searchDisplayController;
@synthesize findDelegate;


-(instancetype)initWithDataType:(HirLocationDataType)dataType{
    if (self = [super init]) {
        self.locationDataType = dataType;
        _tableViewHadAddLongPressGestureRec = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Location history", nil);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = [HirLocationHistoryTableCell heightOfCellWithData:nil];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = NSLocalizedString(@"search", nil);
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate = self;
    
    [self getDataAndRefreshTable];
    
    self.tableView.tableHeaderView = searchBar;
    
    if (self.locationDataType == HirLocationDataType_history) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(peripheralHistoryLocationNeedRefresh:) name:PERIPHERAL_HISTORY_LOCATION_UPDATA_NOTIFICATION object:nil];
    }
    else if (self.locationDataType == HirLocationDataType_lost){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(peripheralDicconnectLocationNeedRefresh:) name:PERIPHERAL_DISCONNECT_LOCATION_UPDATA_NOTIFICATION object:nil];
    }
    
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    CGPoint point = [longPress locationInView:self.currentTableView];
    NSIndexPath * indexPath = [self.currentTableView indexPathForRowAtPoint:point];

    if(indexPath == nil) return ;
    
    UITableViewCell *cell = [self.currentTableView cellForRowAtIndexPath:indexPath];
    
    self.copyRow = (NSUInteger)indexPath.row;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy",nil) action:@selector(menuCopy:)];
    [menu setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
    
    CGRect targetRect = cell.frame;
    [menu setTargetRect:targetRect inView:self.currentTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
    
    [menu update];


        //add your code here
}

-(void)menuCopy:(id)sender
{
    DBPeripheralLocationInfo *locationInfo;
    if (self.currentTableView == self.tableView) {
        locationInfo = [self.data objectAtIndex:self.copyRow];
    }else{
        locationInfo = [self.filterData objectAtIndex:self.copyRow];
    }
    
    NSString *title = NSLocalizedString(@"Location history", nil);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    
    NSString *dateStr = [dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:locationInfo.timestamp.longLongValue]];
    
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *hourStr = [dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:locationInfo.timestamp.longLongValue]];

    NSString *contentLabel;
    if (locationInfo.remark) {
        contentLabel = locationInfo.remark;
    }
    else{
        contentLabel = locationInfo.address;
    }
    
    NSString *copyStr = [NSString stringWithFormat:@"%@,%@ %@\n%@",title,dateStr,hourStr,contentLabel];
    
    [UIPasteboard generalPasteboard].string = copyStr;
    [self.currentTableView resignFirstResponder];
}

#pragma mark - Notification
- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
    
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark - MenuDelegate
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/*
 * 如果原 TableView 和 SearchDisplayController 中的 TableView 的 delete 指向同一个对象
 * 需要在回调中区分出当前是哪个 TableView
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_tableViewHadAddLongPressGestureRec && self.tableView == tableView){
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [tableView addGestureRecognizer:longPressGr];
        _tableViewHadAddLongPressGestureRec = YES;
    }
    
    if (!_searchTableViewHadAddLongPressGestureRec && self.tableView != tableView) {
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [tableView addGestureRecognizer:longPressGr];
        _searchTableViewHadAddLongPressGestureRec = YES;
    }
    
    self.currentTableView = tableView;
    
    if (tableView == self.tableView) {
        return self.data.count;
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"address contains [cd] %@ OR remark contains [cd] %@",self.searchDisplayController.searchBar.text,self.searchDisplayController.searchBar.text];
        
        self.filterData =  [[NSArray alloc] initWithArray:[self.data filteredArrayUsingPredicate:predicate]];
        return self.filterData.count;
    }
    
}

#pragma mark - notification
-(void)peripheralHistoryLocationNeedRefresh:(NSNotification *)notification{
    [self getDataAndRefreshTable];
}

-(void)peripheralDicconnectLocationNeedRefresh:(NSNotification *)notification{
    [self getDataAndRefreshTable];
}

-(void)getDataAndRefreshTable{
    DBPeripheral *currentPeriphera = [HirUserInfo shareUserInfo].currentPeriphera;
    
    self.data = [NSMutableArray arrayWithArray:[HirDataManageCenter findAllLocationRecordByPeripheralUUID:currentPeriphera.uuid dataType:@(self.locationDataType)]];

    [self.tableView reloadData];
}

#pragma mark - MultiFunctionTableViewDelegate
- (void)returnCellMenuIndex:(NSIndexPath *)indexPath menuIndexNum:(NSInteger)menuIndexNum isLeftMenu:(BOOL)isLeftMenu {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    
    HirLocationHistoryTableCell *cell = (HirLocationHistoryTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.7373 green:0.7373 blue:0.7373 alpha:1.0]
                                                 icon:[UIImage imageNamed:@"locationCell_edit"]];

        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.7373 green:0.7373 blue:0.7373 alpha:1.0]
                                                  icon:[UIImage imageNamed:@"locationCell_trash"]];
        
        cell = [[HirLocationHistoryTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:_tableView // Used for row height and selection
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
        
        cell.titleLabel.font = FONT_TABLE_CELL_TITLE;
        cell.contentLabel.font = FONT_TABLE_CELL_CONTENT;
        cell.timeLabel.font = FONT_TABLE_CELL_RIGHT_TIME;
    }
    
    DBPeripheralLocationInfo *locationInfo;
    if (tableView == self.tableView) {
        locationInfo = [self.data objectAtIndex:indexPath.row];
    }else{
        locationInfo = [self.filterData objectAtIndex:indexPath.row];
    }
    if (locationInfo.remark) {
        cell.contentLabel.text = locationInfo.remark;
    }
    else{
        cell.contentLabel.text = locationInfo.address;
    }
//    cell.timeLabel.text = @"15/10/15:10:50";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    
    cell.titleLabel.text = [dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:locationInfo.timestamp.longLongValue]];

    [dateFormatter setDateFormat:@"HH:mm:ss"];
    cell.timeLabel.text = [dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:locationInfo.timestamp.longLongValue]];
    
    cell.indexPath = indexPath;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HirLocationHistoryTableCell heightOfCellWithData:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBPeripheralLocationInfo *locationInfo;
    if (tableView == self.tableView) {
        locationInfo = [self.data objectAtIndex:indexPath.row];
    }
    else{
        locationInfo = [self.filterData objectAtIndex:indexPath.row];
    }
    
    if (self.locationDataType == HirLocationDataType_history) {
        HIRMapViewController *mapVC = [[HIRMapViewController alloc] init];
        DBPeripheral *remoteData = nil;
        if ([[HirUserInfo shareUserInfo].deviceInfoArray count] > [HirUserInfo shareUserInfo].currentPeripheraIndex) {
            remoteData = [[HirUserInfo shareUserInfo].deviceInfoArray objectAtIndex:[HirUserInfo shareUserInfo].currentPeripheraIndex];
            mapVC.hiRemoteName = remoteData.name;
            mapVC.remarkName = remoteData.remarkName;
        }
        DBPeripheralLocationInfo *locationInfo = [HirDataManageCenter findLastLocationByPeriperaUUID:remoteData.uuid];
        mapVC.locationStr = locationInfo.address;
        mapVC.location = [[[CLLocation alloc] initWithLatitude:locationInfo.latitude.doubleValue longitude:locationInfo.longitude.doubleValue]locationMarsFromEarth];
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    else{
        if([self.findDelegate respondsToSelector:@selector(resetTheLocation:peripheraLocationInfo:)]) {
            [self.findDelegate performSelector:@selector(resetTheLocation:peripheraLocationInfo:) withObject:[[[CLLocation alloc] initWithLatitude:locationInfo.latitude.doubleValue longitude:locationInfo.longitude.doubleValue]locationMarsFromEarth] withObject:locationInfo];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)swippableTableViewCell:(HirLocationHistoryTableCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
}

- (void)swippableTableViewCell:(HirLocationHistoryTableCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            DBPeripheralLocationInfo *peripheraLocationInfo = [self.data objectAtIndex:cell.indexPath.row];
            
            self.actionTextField = [[HirActionTextField alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
            if (peripheraLocationInfo.remark) {
                self.actionTextField.placeholder = peripheraLocationInfo.remark;
            }
            else{
                self.actionTextField.placeholder = peripheraLocationInfo.address;
            }
            self.actionTextField.delegate = self;
            
            HirAlertView *hirAlertView = [[HirAlertView alloc]initWithTitle:NSLocalizedString(@"changeName", nil) contenView:self.actionTextField clickBlock:^(NSInteger index){
                peripheraLocationInfo.remark = self.actionTextField.text;
                [HirDataManageCenter saveLocationRecordByModel:peripheraLocationInfo];
                [self.tableView reloadData];
            }cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) otherButtonTitles:NSLocalizedString(@"CONFIRM", nil), nil];
            [hirAlertView showWithAnimation:YES];
            break;
        }
        case 1:
        {
            HirAlertView *alertView = [[HirAlertView alloc]initWithTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"doYouWantToDelThisRecord", nil) clickBlock:^(NSInteger index){
                if (index == 1) {
                    [self.tableView beginUpdates];
                    DBPeripheralLocationInfo *peripheraLocationInfo = [self.data objectAtIndex:cell.indexPath.row];
                    [HirDataManageCenter delLocationRecordByModel:peripheraLocationInfo];
                    [self.data removeObjectAtIndex:cell.indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths: [NSArray arrayWithObjects:cell.indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                }
            }cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) otherButtonTitles:NSLocalizedString(@"CONFIRM", nil), nil];
            [alertView showWithAnimation:YES];
        }
            break;
        case 2:
        {
            NSLog(@"转发");
        }
            break;
            
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
}

#pragma mark -- UITextFeild delegater methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.actionTextField) {
        [self.actionTextField drawBorderColorWith:COLOR_THEME];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.actionTextField) {
        [self.actionTextField drawBorderColorWith:[UIColor clearColor]];
    }
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
