//
//  HirVoceViewController.m
//  HiRemote
//
//  Created by minfengliu on 15/7/4.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirVoiceMemosViewController.h"
#import "HirVoiceCell.h"
#import <AVFoundation/AVFoundation.h>

@interface HirVoiceMemosViewController ()
<UISearchDisplayDelegate,
UITableViewDataSource,
UITableViewDelegate,
AVAudioRecorderDelegate>
{
    BOOL toggle;
    
    //Variable setup for access in the class
    NSURL *recordedTmpFile;
    AVAudioRecorder *recorder;

}
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
    searchBar.placeholder = NSLocalizedString(@"search", nil);
    
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
    
    [self prepareAudio];
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

-(void)prepareAudio{
    NSError *adioError;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &adioError];
    //Activate the session
    [audioSession setActive:YES error: &adioError];
}

- (IBAction)start_button_pressed{
    
    if(toggle)
    {
        toggle = NO;
        
        //Begin the recording session.
        //Error handling removed.  Please add to your own code.
        
        //Setup the dictionary object with all the recording settings that this
        //Recording sessoin will use
        //Its not clear to me which of these are required and which are the bare minimum.
        //This is a good resource: http://www.totodotnet.net/tag/avaudiorecorder/
        NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
        
        [recordSetting setValue:[NSNumber numberWithFloat:44110] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        
        //Now that we have our settings we are going to instanciate an instance of our recorder instance.
        //Generate a temp file for use by the recording.
        //This sample was one I found online and seems to be a good choice for making a tmp file that
        //will not overwrite an existing one.
        //I know this is a mess of collapsed things into 1 call.  I can break it out if need be.
        recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
        NSLog(@"Using File called: %@",recordedTmpFile);
        //Setup the recorder to use this file and record to it.
        
        NSError *error;
        recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
        //Use the recorder to start the recording.
        //Im not sure why we set the delegate to self yet.
        //Found this in antother example, but Im fuzzy on this still.
        [recorder setDelegate:self];
        //We call this to start the recording process and initialize
        //the subsstems so that when we actually say "record" it starts right away.
        [recorder prepareToRecord];
        //Start the actual Recording
        [recorder record];
        //There is an optional method for doing the recording for a limited time see
        //[recorder recordForDuration:(NSTimeInterval) 10]
        
    }
    else
    {
        toggle = YES;
        
        NSLog(@"Using File called: %@",recordedTmpFile);
        //Stop the recorder.
        [recorder stop];
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag;
{
    
}
/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error;
{
    
}

/* AVAudioRecorder INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */

/* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder NS_DEPRECATED_IOS(2_2, 8_0);
{
    
}
/* audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags NS_DEPRECATED_IOS(6_0, 8_0);
{
    
}
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags NS_DEPRECATED_IOS(4_0, 6_0);
{
    
}
/* audioRecorderEndInterruption: is called when the preferred method, audioRecorderEndInterruption:withFlags:, is not implemented. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder NS_DEPRECATED_IOS(2_2, 6_0);
{
    
}

-(IBAction) play_button_pressed{
    
    //The play button was pressed...
    //Setup the AVAudioPlayer to play the file that we just recorded.
    NSError *error;
    AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedTmpFile error:&error];
    [avPlayer prepareToPlay];
    [avPlayer play];
    
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //Clean up the temp file.
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError *error;
    [fm removeItemAtPath:[recordedTmpFile path] error:&error];
    //Call the dealloc on the remaining objects.
    recorder = nil;
    recordedTmpFile = nil;
}

@end
