#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define AUDIO_RECORD_TEMP_FILE_EXTEN_NAME @"aac"

typedef void(^AudioPlayCallBack)(CGFloat duration);
@protocol EHAudioControllerDelegate <NSObject>

@optional;
/**
 *  成功完成录制
 *
 *  @param destinationFilePath 文件路径
 */
- (void)recordFinish:(NSString *)destinationFilePath;

/**
 *  录制错误
 *
 *  @param destinationFilePath 文件路径
 */
- (void)recordError:(NSString *)destinationFilePath;

/**
 *  播放音频完成
 *
 *  @param destinationFilePath 文件路径
 */
- (void)audioPlayFinish:(NSString *)destinationFilePath;


/**
 *  播放音频错误
 *
 *  @param destinationFilePath 文件路径
 */
- (void)audioPlayError:(NSString *)destinationFilePath;

@end

@interface EHAudioController : NSObject
@property (nonatomic, weak) id<EHAudioControllerDelegate>delegate;
@property (nonatomic,copy) NSString* playingAudioPath;
@property (nonatomic,copy) NSString *destinationFilePath;
@property (nonatomic, strong) AVAudioPlayer *avPlayer;

+ (instancetype)shareAudioController;

/**
 *  开始录制音频
 *
 *  @param destinationFilePath 文件路径
 */
- (void)recordFire:(NSString *)destinationFilePath;

/**
 *  停止录制
 */
- (void)recordStop;

/**
 *  开始播放音频
 *
 *  @param destinationFilePath 文件路径
 */
- (void)audioPlayFire:(NSString *)destinationFilePath duration:(AudioPlayCallBack)playCallBack;


/**
 *  停止播放
 */
- (void)audioStopPlay;



/**
 *  临时录制文件路径
 */
- (NSString *)tempAudioRecordFilePath;

/**
 *  是否播放中
 */
- (BOOL)isPlaying;



/**
 *  获取音频时间
 *
 *  @param audioFileString 路径
 *
 *  @return 时间
 */
- (CGFloat)audioDuration:(NSString *)audioFileString;

@end
