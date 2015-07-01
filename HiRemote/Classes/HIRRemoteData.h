//
//  HIRRemoteData.h
//  HiRemote
//
//  Created by parker on 6/30/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kHiRemoteName @"theHiRemoteName"
#define kHiRemoteAvatarName @"theHiRemoteAvatarName"
#define kHiRemoteUuid @"theHiRemoteUuid"
#define kHiRemoteLastLocation @"theHiRemoteLastLocation"
#define kHiRemoteBattery @"theHiRemoteBattery"

@interface HIRRemoteData : NSObject <NSCoding,NSCopying>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarPath;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *lastLocation;
@property (nonatomic, assign) float battery;

+ (void)saveHiRemoteData:(NSArray *)dataArray;
+ (NSArray *)getHiRemoteDataArrayFromDisk;
@end
