#import "EHAudioController.h"

@interface EHAudioController ()
<AVAudioPlayerDelegate,
AVAudioRecorderDelegate,
AVAudioSessionDelegate>
@property (nonatomic, strong) AVAudioRecorder *avRecorder;
@property (nonatomic, strong) AVAudioSession *avSession;
@end

@implementation EHAudioController

+ (instancetype)shareAudioController
{

    static dispatch_once_t onceToken;
    static EHAudioController *instance = nil;

    dispatch_once(&onceToken, ^{
        
        instance = [[EHAudioController alloc] init];
        
    });
    
    return instance;
    
}



- (id)init
{
    if (self = [super init]) {
        
        [self setUp];
        
    }
    return self;
}


- (void)setUp{
    
    _avSession = [AVAudioSession sharedInstance];
//    [_avSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [_avSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];

}


- (void)recordFire:(NSString *)destinationFilePath
{
    self.destinationFilePath = [destinationFilePath copy];
    if (!_avRecorder || !_avRecorder.recording)
    {
        NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                        [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                                        [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                        nil];

        
//        NSDictionary *recordSetting1 =  [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSNumber numberWithInt:kAudioFormatMPEGLayer3],AVFormatIDKey,
//                           [NSNumber numberWithInt:AVAudioQualityMin],AVEncoderAudioQualityKey,
//                           [NSNumber numberWithInt:16],
//                           AVEncoderBitRateKey,
//                           [NSNumber numberWithInt: 2],
//                           AVNumberOfChannelsKey,
//                           [NSNumber numberWithFloat:44100.0],
//                           AVSampleRateKey,nil];
        
        NSError *errorSetSession = nil;
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&errorSetSession];
//        [_avSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];

        [_avSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];

        if (errorSetSession) {
            NSLog(@"Setting the AVAudioSessionCategoryPlayback Category failed! %ld\n", (long)errorSetSession.code);
            return;
        }
        
        if(SYSTEM_VERSION >= 7.0)
        {
            NSLog(@"%@", [(AVAudioSessionPortDescription *)[AVAudioSession sharedInstance].availableInputs[0] dataSources] );
            
            NSArray *availableInputs = [[AVAudioSession sharedInstance] availableInputs];
            AVAudioSessionPortDescription *port = [availableInputs objectAtIndex:0];  //built in mic for your case
            NSError *portErr = nil;
            [[AVAudioSession sharedInstance] setPreferredInput:port error:&portErr];
        }
        
        NSError *error = [NSError new];
        _avRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:destinationFilePath] settings:recordSettings error:&error];
        [_avRecorder prepareToRecord];
        _avRecorder.delegate = self;
        [_avSession setActive:YES error:nil];
        [_avRecorder record];
    }
    else if(_avRecorder.recording)
    {
        [_avRecorder stop];
    }
}

- (void)recordStop
{
    if (_avRecorder && _avRecorder.isRecording) {
        [_avRecorder stop];
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    }
}


- (void)audioPlayFire:(NSString *)destinationFilePath duration:(AudioPlayCallBack)playCallBack
{
    self.playingAudioPath = destinationFilePath;
    if (!_avPlayer || !_avPlayer.isPlaying) {
        NSLog(@"playAudio\n");
        
        // set category back to something that will allow us to play audio since AVAudioSessionCategoryAudioProcessing will not
        NSError *error = nil;
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [_avSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        
        if (error) {
            NSLog(@"Setting the AVAudioSessionCategoryPlayback Category failed! %ld\n", (long)error.code);
            return;
        }
        
        // play the result
        _avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:destinationFilePath] error:&error];
        if (nil == _avPlayer) {
            NSLog(@"AVAudioPlayer alloc failed! %ld\n", (long)error.code);
            return;
        }
        
        [_avPlayer setDelegate:self];
        
        [_avSession setActive:YES error:nil];
        NSLog(@"Audio Times = %f", _avPlayer.duration);
        
//        //设置播放通道
//        [self setAudioSectionRoute:[self hasHeadset]];
        
        //设置红外线监听
//        [self openProximityMoniroingOrNot:YES];
        
        
        if(playCallBack)
        {
            playCallBack(_avPlayer.duration);
            playCallBack = nil;
        }
        [_avPlayer play];

    }
    else if (_avPlayer.isPlaying)
    {
    
        [_avPlayer stop];

    }
}


/**
 *  设置音频输出通道
 *
 *  @param hasHeadset 是否带耳机
 */
//- (void)setAudioSectionRoute:(BOOL)hasHeadset
//{
//    UInt32 audioRouteOverride = hasHeadset ?kAudioSessionOverrideAudioRoute_None:kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
//}


//- (void)openProximityMoniroingOrNot:(BOOL)enable
//{
//
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:enable]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
//    
//    
//    //添加监听
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     
//                                             selector:@selector(sensorStateChange:)
//     
//                                                 name:@"UIDeviceProximityStateDidChangeNotification"
//     
//                                               object:nil];
//    
//
//}

//处理监听触发事件

-(void)sensorStateChange:(NSNotificationCenter *)notification;

{
    
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    
    if ([[UIDevice currentDevice] proximityState] == YES)
        
    {
        
        NSLog(@"Device is close to user");
        
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        [_avSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        
    }
    
    else
        
    {
        
        NSLog(@"Device is not close to user");
        
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [_avSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];

        
    }
    
}





- (BOOL)hasHeadset {
    //模拟器不支持
#if TARGET_IPHONE_SIMULATOR
#warning *** Simulator mode: audio session code works only on a device
    return NO;
#else
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    
    if((route == NULL) || (CFStringGetLength(route) == 0)){
        // Silent Mode
        NSLog(@"AudioRoute: SILENT, do nothing!");
    } else {
        NSString* routeStr = (__bridge NSString*)route;
        NSLog(@"AudioRoute: %@", routeStr);
        
        /* Known values of route:
         * "Headset"
         * "Headphone"
         * "Speaker"
         * "SpeakerAndMicrophone"
         * "HeadphonesAndMicrophone"
         * "HeadsetInOut"
         * "ReceiverAndMicrophone"
         * "Lineout"
         */
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        if (headphoneRange.location != NSNotFound) {
            return YES;
        } else if(headsetRange.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
#endif
    
}

- (void)audioStopPlay
{
    if (_avPlayer && _avPlayer.isPlaying)
    {
        [_avPlayer stop];
//        [self openProximityMoniroingOrNot:NO];
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    }
    self.playingAudioPath = nil;
}


#pragma mark- AVAudioPlayer


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"audioPlayerDecodeErrorDidOccur %@", [error localizedDescription]);
    [self audioPlayerDidFinishPlaying:player successfully:false];
    
    //关闭红外线监听
//    [self openProximityMoniroingOrNot:NO];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"Session interrupted! --- audioPlayerBeginInterruption ---\n");
    
    // if the player was interrupted during playback we don't continue
    [self audioPlayerDidFinishPlaying:player successfully:true];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.playingAudioPath = nil;
	if (flag == NO) NSLog(@"Playback finished unsuccessfully!");
    
    NSLog(@"audioPlayerDidFinishPlaying\n");
    
	[player setDelegate:nil];
    
    [_avSession setActive:NO error:nil];
    
    
    
    //关闭红外线监听
//    [self openProximityMoniroingOrNot:NO];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(audioPlayFinish:)]) {
        NSString *filePath = [player.url absoluteString];
        [_delegate audioPlayFinish:filePath];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    NSLog(@"audioPlayerEndInterruption  \n");
    [_avSession setActive:YES error:nil];
   
}

#pragma mark - AVAudioRecord
/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{

    if (flag == NO) NSLog(@"RecordBack finished unsuccessfully!");
    
    NSLog(@"audioRecorderDidFinishRecording\n");
    [recorder setDelegate:nil];
    
    [_avSession setActive:NO error:nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(recordFinish:)]) {
        
        NSString *filrPath = [recorder.url absoluteString];
        [_delegate recordFinish:filrPath];
    }

}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{

    NSLog(@"audioRecorderEncodeErrorDidOccur : %@", [error localizedDescription]);
    [self audioRecorderDidFinishRecording:recorder successfully:false];
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    NSLog(@"Session interrupted! --- audioRecorderBeginInterruption \n");
    [self audioRecorderDidFinishRecording:recorder successfully:false];

}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
    NSLog(@"audioRecorderEndInterruption \n");
    [_avSession setActive:YES error:nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(recordError:)]) {
        NSString *filrPath = [recorder.url absoluteString];
        [_delegate recordError:filrPath];
    }

}

#pragma mark -- AVAudioSessionDelegate protocol 

- (void)beginInterruption
{
    
    NSLog(@"AVAudioSessionDelegate BeginInterruption");
}

- (void)endInterruption
{

    NSLog(@"AVAudioSessionDelegate endInterruption");
}




#pragma mark - Other

/**
 *  临时录制文件路径
 */
- (NSString *)tempAudioRecordFilePath
{
//    NSString *dateMD5 = [[[NSDate date] description] getMd5_32Bit_String:[[NSDate date] description]];
//    NSString *fileName = [NSString stringWithFormat:@"temp%@.%@", dateMD5, AUDIO_RECORD_TEMP_FILE_EXTEN_NAME];
//    NSString *fileFolder = [[EHFileManage sharedFileManage] cacheDirectory];
//    NSString *destinationPath = [NSString stringWithFormat:@"%@/%@", fileFolder, fileName];
//    return destinationPath;
    return nil;
}




/**
 *  是否播放中
 */
- (BOOL)isPlaying
{

    BOOL playing = _avPlayer.playing;
    return playing;
    
}


/**
 *  获取音频时间
 *
 *  @param audioFileString 路径
 *
 *  @return 时间
 */
- (CGFloat)audioDuration:(NSString *)audioFileString
{

    NSURL *audioFileURL = [[NSURL alloc] initFileURLWithPath:audioFileString];
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:audioFileURL options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    CGFloat audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    return audioDurationSeconds;
}
@end
