//
//  HirTool.h
//  HiRemote
//
//  Created by minfengliu on 15/12/23.
//  Copyright © 2015年 hiremote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HirTool : NSObject
+(NSString *)getFAQString;
+(NSString *)getquestionString;
+(NSString *)getPolicyString;
+(int)theCurrentLanguage;

@end
