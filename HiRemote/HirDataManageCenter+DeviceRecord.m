//
//  HirDataManageCenter+DeviceRecord.m
//  HiRemote
//
//  Created by minfengliu on 15/7/13.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter+DeviceRecord.h"

@implementation HirDataManageCenter (DeviceRecord)
+(DBDeviceRecord *)findDeviceRecordByPeripheraUUID:(NSString *)peripheraUUID{
    if (!peripheraUUID) {
        return nil;
    }
    DBDeviceRecord *deviceRecord = [[DBDeviceRecord MR_findByAttribute:@"peripheraUUID" withValue:peripheraUUID]firstObject];
    return deviceRecord;
}

+(NSMutableArray *)findAllRecord{
    NSArray *list = [DBDeviceRecord MR_findAllSortedBy:@"recoderTimestamp" ascending:NO];
    
    if ([list count] == 0) {
        return [NSMutableArray arrayWithCapacity:3];
    }
    return  [NSMutableArray arrayWithArray:list];
}

//插入一条记录
+(void)insertVoicePath:(NSString *)voicePath peripheraUUID:(NSString *)peripheraUUID recoderTimestamp:(NSNumber *)recoderTimestamp title:(NSString *)title voiceTime:(NSNumber *)voiceTime{
    DBDeviceRecord *deviceRecord = [HirDataManageCenter findDeviceRecordByPeripheraUUID:peripheraUUID];
    if (deviceRecord) {
        if (voicePath) {
            deviceRecord.voicePath = voicePath;
        }
        if (peripheraUUID) {
            deviceRecord.peripheraUUID = peripheraUUID;
        }
        if (recoderTimestamp) {
            deviceRecord.recoderTimestamp = recoderTimestamp;
        }
        if (title) {
            deviceRecord.title = title;
        }
        if (voiceTime) {
            deviceRecord.voiceTime = voiceTime;
        }
    }
    else{
        DBDeviceRecord *deviceRecord = [DBDeviceRecord MR_createEntity];
        deviceRecord.voicePath = voicePath;
        deviceRecord.recoderTimestamp = recoderTimestamp;
        deviceRecord.title = title;
        deviceRecord.voiceTime = voiceTime;
    }
    
    [[NSManagedObjectContext MR_context]MR_saveOnlySelfAndWait];
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.7 * NSEC_PER_SEC));
    dispatch_after(dispatchTime,dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE_RECORD_UPDATA_NOTIFICATION object:nil];
    });
}

//删除一条记录
+(void)delDeviceRecordByModel:(DBDeviceRecord *)deviceRecord{
    //删除文件
//

    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:deviceRecord.voicePath];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:soundFilePath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:soundFilePath error:&err];
    }
    
    [deviceRecord MR_deleteEntity];
    [[NSManagedObjectContext MR_context]MR_saveOnlySelfAndWait];
}

//保存修改后的记录
+(void)saveDeviceRecordByModel:(DBDeviceRecord *)deviceRecord{
    [[NSManagedObjectContext MR_context]MR_saveOnlySelfAndWait];
}
@end
