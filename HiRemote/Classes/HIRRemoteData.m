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

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:kHiRemoteName];
        self.avatarPath = [decoder decodeObjectForKey:kHiRemoteAvatarName];
        self.uuid = [decoder decodeObjectForKey:kHiRemoteUuid];
        self.lastLocation = [decoder decodeObjectForKey:kHiRemoteLastLocation];
        self.battery = [[decoder decodeObjectForKey:kHiRemoteBattery] floatValue];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encode {
    [encode encodeObject:name forKey:kHiRemoteName];
    [encode encodeObject:avatarPath forKey:kHiRemoteAvatarName];
    [encode encodeObject:uuid forKey:kHiRemoteUuid];
    [encode encodeObject:lastLocation forKey:kHiRemoteLastLocation];
    [encode encodeObject:[NSNumber numberWithFloat:battery] forKey:kHiRemoteBattery];
}

- (id)copyWithZone:(NSZone *)zone{
    HIRRemoteData *theRemote = [[[self class] allocWithZone:zone] init];
    theRemote.name = self.name;
    theRemote.avatarPath = self.avatarPath;
    theRemote.uuid = self.uuid;
    return theRemote;
}


+ (void)saveHiRemoteData:(NSArray *)dataArray {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    documentsDirectory =[documentsDirectory stringByAppendingPathComponent:@"HiRemoteData"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:TRUE attributes:nil error:nil];
    }
    if (!documentsDirectory) {
        return;
    }
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"HiRemoteInfo"];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dataArray forKey:@"DATAKEY"];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

+ (NSArray *)getHiRemoteDataArrayFromDisk {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    documentsDirectory =[documentsDirectory stringByAppendingPathComponent:@"HiRemoteData/HiRemoteInfo"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        return nil;
    }
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:documentsDirectory];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *dataArray = (NSArray *)[unarchiver decodeObjectForKey:@"DATAKEY"];
    return dataArray;
}


@end
