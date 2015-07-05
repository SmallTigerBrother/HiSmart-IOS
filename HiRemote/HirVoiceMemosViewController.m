//
//  HirVoceViewController.m
//  HiRemote
//
//  Created by minfengliu on 15/7/4.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirVoiceMemosViewController.h"
#import "HirVoiceCell.h"

@interface HirVoiceMemosViewController ()
<UISearchDisplayDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *data;
@property (nonatomic, strong)NSArray *filterData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *playVoiceRecordPanel;

@property (weak, nonatomic) IBOutlet UILabel *recordDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *voicePlayBtn;
@property (weak, nonatomic) IBOutlet UILabel *voiceBeginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceEndTimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *voiceProgressView;
@property (weak, nonatomic) IBOutlet UILabel *recordingLabel;

@property (nonatomic, strong)UISearchDisplayController *searchDisplayController;

@end

@implementation HirVoiceMemosViewController
@synthesize searchDisplayController;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"VoiceMemos", nil);
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
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

    self.tableView.tableHeaderView = searchBar;
    
    NSMutableArray *list = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSInteger i = 1; i<10; i++) {
        NSInteger re = i * 1111;
        NSString *s = [NSString stringWithFormat:@"%ld",(long)re];
        [list addObject:s];
    }
    self.data = list;

    self.playVoiceRecordPanel.hidden = YES;
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    
    HirVoiceCell *cell = (HirVoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[HirVoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView == self.tableView) {
        cell.titleLabel.text = self.data[indexPath.row];
    }else{
        cell.titleLabel.text = self.filterData[indexPath.row];
    }
    cell.dateLabel.text = @"xxxxx";
    cell.voiceRecodeTimeLabel.text = @"15/10/15:10:50";
    cell.titleLabel.font = FONT_TABLE_CELL_TITLE;
    cell.dateLabel.font = FONT_TABLE_CELL_CONTENT;
    cell.voiceRecodeTimeLabel.font = FONT_TABLE_CELL_CONTENT;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HirVoiceCell heightOfCellWithData:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == self.tableView){
        [self playVoiceModel:self.data[indexPath.row]];
    }
    else{
        [self playVoiceModel:self.filterData[indexPath.row]];
    }
    [self.playVoiceRecordPanel setHidden:NO];
    
}

//-(void)setVoicePlandHided:(BOOL)isHided{
//    if (isHided) {
//        [UIView animateWithDuration:.3 animations:^{
//            self.playVoiceRecordPanel.alpha =
//        }completion:^(BOOL finished){
//            
//        }];
//    }
//}

-(void)playVoiceModel:(id)voiceModel{
    self.recordingLabel.text = voiceModel;
    [self.playVoiceRecordPanel setHidden:NO];
    
    [self.view bringSubviewToFront:self.playVoiceRecordPanel];
}

- (IBAction)hidePlayVoceRecordPanel:(id)sender {
    [self.playVoiceRecordPanel setHidden:YES];
}

- (IBAction)editVoiceBtnPressed:(id)sender {
    NSLog(@"editVoiceBtnPressed");
}

- (IBAction)trashBtnPressed:(id)sender {
    NSLog(@"trashBtnPressed");
}

- (IBAction)transhpondBtnPressed:(id)sender {
    NSLog(@"transhpondBtnPressed");
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
