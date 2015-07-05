//
//  HirUserDefault.m
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirUserDefault.h"

@interface HirUserDefault()
@property (nonatomic, strong)NSUserDefaults *stateUserDef;
@end

@implementation HirUserDefault
static HirUserDefault *hirUserDefault;
+(HirUserDefault *)shareUserDefaults{
    @synchronized(self){
        if (!hirUserDefault) {
            hirUserDefault = [[HirUserDefault alloc]init];
        }
    }
    return hirUserDefault;
}

-(NSUserDefaults *)stateUserDef{
    return [NSUserDefaults standardUserDefaults];
}

-(void)setCurrentViewController:(NSInteger)currentViewController{
    [_stateUserDef setObject:@(currentViewController) forKey:@"currentViewController"];
    [_stateUserDef synchronize];
}

-(NSInteger)currentViewController{
    return [[_stateUserDef objectForKey:@"currentViewController"]integerValue];
}
@end