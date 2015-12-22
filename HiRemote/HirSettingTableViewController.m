//
//  HirSettingTableViewController.m
//  HiRemote
//
//  Created by minfengliu on 15/8/2.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirSettingTableViewController.h"
#import "HirBaseWebViewCtl.h"

#define addANewDevice NSLocalizedString(@"addANewDevice", nil)
#define supportAndFaqs NSLocalizedString(@"supportAndFaqs", nil)
#define contactUs NSLocalizedString(@"contactUs", nil)
#define TermsAndConditions NSLocalizedString(@"TermsAndConditions", nil)
#define PrivacyPolicy NSLocalizedString(@"PrivacyPolicy", nil)

@interface HirSettingTableViewController ()
@property (nonatomic, strong)NSArray *titleList;
@property (nonatomic, strong)NSArray *contentList;
@end

@implementation HirSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Setting", @"");
    
    self.titleList = @[addANewDevice,supportAndFaqs,contactUs,TermsAndConditions,PrivacyPolicy];
    
    self.contentList = @[NSLocalizedString(@"Include another HiSmart device by adding it here.", nil),NSLocalizedString(@"Need any help? We can help you.", nil),NSLocalizedString(@"Did't find your answer in FAQs.", nil),NSLocalizedString(@"Find the information here.", nil),NSLocalizedString(@"Find the privacy policy here.", nil),];
    
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.titleList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.detailTextLabel.numberOfLines = 0;
        cell.textLabel.font = FONT_TABLE_CELL_TITLE;
        cell.textLabel.font = FONT_TABLE_CELL_CONTENT;
        UIImage *accessoryImg = [UIImage imageNamed:@"cellDetailAccessory"];
        UIImageView *accessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, accessoryImg.size.width, accessoryImg.size.height)];
        accessoryView.image = accessoryImg;
        cell.accessoryView = accessoryView;
    }
    
    NSInteger row = [indexPath row];
    NSString *title = [self.titleList objectAtIndex:row];
    NSString *content = [self.contentList objectAtIndex:row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = content;
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    NSString *title = [self.titleList objectAtIndex:row];
    
    if ([title isEqualToString:addANewDevice]) {
        NSLog(@"addANewDevice");
        ////添加新设备时，防止为上次的设备
        [HIRCBCentralClass shareHIRCBcentralClass].theAddNewNeedToAvoidLastUuid = [[HIRCBCentralClass shareHIRCBcentralClass].discoveredPeripheral.identifier UUIDString];
        [[HIRCBCentralClass shareHIRCBcentralClass] cancelConnectionWithPeripheral:nil];
        AppDelegate *appDeleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDeleg addNewDevice];
    }
    else if ([title isEqualToString:supportAndFaqs]) {
        NSString *url = [HirTool getFAQString];
        [self pushWebViewCtl:url title:title];
    }
    else if ([title isEqualToString:contactUs]) {
        NSString *url = [HirTool getquestionString];
        [self pushWebViewCtl:url title:title];
    }
    else if ([title isEqualToString:TermsAndConditions]) {
        NSString *url = [HirTool getPolicyString];
        [self pushWebViewCtl:url title:title];
    }
    else if ([title isEqualToString:PrivacyPolicy]) {
        NSString *url = [HirTool getPolicyString];
        [self pushWebViewCtl:url title:title];
    }
}

-(void)pushWebViewCtl:(NSString *)url title:(NSString *)title{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    return;
    title = NSLocalizedString(title, nil);
    HirBaseWebViewCtl *baseWebViewCtl = [[HirBaseWebViewCtl alloc]init];
    baseWebViewCtl.title = title;
    baseWebViewCtl.theUrl = [NSURL URLWithString:url];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:baseWebViewCtl];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
@end
