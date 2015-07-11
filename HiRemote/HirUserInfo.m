//
//  HirUserDefault.m
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirUserInfo.h"

@interface HirUserInfo()
@property (nonatomic, strong)NSUserDefaults *stateUserDef;
@end

@implementation HirUserInfo
static HirUserInfo *hirUserDefault;
+(HirUserInfo *)shareUserInfo{
    @synchronized(self){
        if (!hirUserDefault) {
            hirUserDefault = [[HirUserInfo alloc]init];
        }
    }
    return hirUserDefault;
}

-(instancetype)init{
    if(self = [super init]){
        self.stateUserDef = [NSUserDefaults standardUserDefaults];
        self.deviceInfoArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

-(void)setCurrentViewController:(NSInteger)currentViewController{
    [self.stateUserDef setObject:@(currentViewController) forKey:@"currentViewController"];
    [self.stateUserDef synchronize];
}

-(NSInteger)currentViewController{
    return [[self.stateUserDef objectForKey:@"currentViewController"]integerValue];
}

-(void)setCurrentPeripheraIndex:(NSInteger)currentPeripheraIndex{
    [self.stateUserDef setObject:@(currentPeripheraIndex) forKey:@"currentPeripheraIndex"];
    [self.stateUserDef synchronize];
}

-(NSInteger)currentPeripheraIndex{
    return [[self.stateUserDef objectForKey:@"currentPeripheraIndex"]integerValue];
}

-(DBPeriphera *)currentPeriphera{
    if ([self.deviceInfoArray count] > self.currentPeripheraIndex) {
        _currentPeriphera = [self.deviceInfoArray objectAtIndex:self.currentPeripheraIndex];
        return _currentPeriphera;
    }
    else{
//        NSAssert(0, @"数据非法");
        return nil;
    }
}

-(void)setDeviceInfoArray:(NSMutableArray *)deviceInfoArray{
    NSLog(@"set deviceInfoArray,deviceInfoArray.count = %d",deviceInfoArray.count);
    _deviceInfoArray = deviceInfoArray;
}
@end