//
//  SoundTool.h

//
//  Created by apple on 15-5-15.
//  Copyright (c) 2015年 suidehang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundNames.h"


@interface SoundTool : NSObject

// 公共的访问单例对象的方法
singleton_interface(SoundTool)
- (void)playLostMusic;
// 播放背景音乐
- (void)playBgMusic;

// 播放音频
- (void)playSound:(NSString *)soundName;

//停止播放音乐
- (void)pauseLostMusic;
// 设置音乐是否静音
@property (nonatomic, assign) BOOL musicMuted;

// 设置音效是否静音
@property (nonatomic, assign) BOOL soundMuted;
@end
