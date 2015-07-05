//
//  HIRRemoteData.m
//  HiRemote
//
//  Created by parker on 6/30/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRRemoteData.h"

@implementation HIRRemoteData
@synthesize name;
@synthesize avatarPath;
@synthesize uuid;
@synthesize lastLocation;
@synthesize battery;

-(id)init {
    if(self = [super init]) {
        self.name = @"";
        self.avatarPath = @"";
        self.uuid = @"";
        self.lastLocation = @"";
        self.battery = 0.5;
    }
    return self;
}


+ (void)saveHiRemoteData:(NSMutableArray *)dataArray {
    NSMutableArray *myDataArray = [NSMutableArray arrayWithCapacity:5];
    HIRRemoteData *tempData;
    for (tempData in dataArray) {
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        if ([tempData.name length] > 0) {
            [dataDic setObject:tempData.name forKey:@"name"];
        }
        if ([tempData.avatarPath length] > 0) {
            [dataDic setObject:tempData.avatarPath forKey:@"path"];
        }
        if ([tempData.uuid length] > 0) {
            [dataDic setObject:tempData.uuid forKey:@"uuid"];
        }
        if ([tempData.lastLocation length] > 0) {
            [dataDic setObject:tempData.lastLocation forKey:@"loca"];
        }
        if (tempData.battery > 0) {
            [dataDic setObject:[NSNumber numberWithFloat:tempData.battery] forKey:@"batt"];
        }
        if ([dataDic count] > 0) {
            [myDataArray addObject:dataDic];
        }
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:myDataArray forKey:@"hirRemoteData"];
    [userDefaults synchronize];
}

+ (NSMutableArray *)getHiRemoteDataArrayFromDisk {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *dataArray = (NSMutableArray *)[userDefaults objectForKey:@"hirRemoteData"];
    NSMutableArray *tempDataArray = [NSMutableArray arrayWithCapacity:5];
    NSMutableDictionary *tempDic;
    for (tempDic in dataArray) {
        HIRRemoteData *remoteData = [[HIRRemoteData alloc] init];
        if ([tempDic valueForKey:@"name"]) {
            remoteData.name = [tempDic valueForKey:@"name"];
        }else {
            remoteData.name = @"";
        }
        if ([tempDic valueForKey:@"path"]) {
            remoteData.avatarPath = [tempDic valueForKey:@"path"];
        }else {
            remoteData.avatarPath = @"";
        }
        if ([tempDic valueForKey:@"uuid"]) {
            remoteData.uuid = [tempDic valueForKey:@"uuid"];
        }else {
            remoteData.uuid = @"";
        }
        if ([tempDic valueForKey:@"loca"]) {
            remoteData.lastLocation = [tempDic valueForKey:@"loca"];
        }else {
            remoteData.lastLocation = @"";
        }
        if ([tempDic valueForKey:@"batt"]) {
            remoteData.battery = [[tempDic valueForKey:@"batt"] floatValue];
        }else {
            remoteData.battery = 0.5;
        }
        [tempDataArray addObject:remoteData];
    }
    return tempDataArray;
}


@end
