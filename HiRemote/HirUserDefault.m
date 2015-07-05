//
//  HirUserDefault.m
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirUserDefault.h"

@implementation HirUserDefault
-(NSUserDefaults *)shareUserDefaults{
//    @synchronized(self){
    if (_shareUserDefaults) {
        _shareUserDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _shareUserDefaults;
}


@end
