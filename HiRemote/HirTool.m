//
//  HirTool.m
//  HiRemote
//
//  Created by minfengliu on 15/12/23.
//  Copyright © 2015年 hiremote. All rights reserved.
//

#import "HirTool.h"

@implementation HirTool
+(int)theCurrentLanguage{
    int currentLanguage = 1;
    NSArray *locLangs = [NSLocale preferredLanguages];
    if ([locLangs count] > 0) {
        NSString *currentLang = [locLangs objectAtIndex:0];
        if([currentLang hasPrefix:@"zh-Hans"] || [currentLang hasPrefix:@"zh-Hant"])
        {
            currentLanguage = 2;
            NSLog(@"current Language == Chinese");
        }else if([currentLang hasPrefix:@"ko"])
        {
            currentLanguage = 3;
            NSLog(@"current Language == korean");
        }else{
            currentLanguage = 1;
            NSLog(@"current Language == English");
        }
    }else {
        currentLanguage = 1;
    }
    return currentLanguage;
}

+(NSString *)getFAQString{
    NSString *url;
    switch ([HirTool theCurrentLanguage]) {
        case 3:
        {
            url = @"http://hismart.co.kr/faq";
        }
            break;
            
        default:
            url = @"http://hismart.us/faq";
            break;
    }
    return url;
}

+(NSString *)getquestionString{
    NSString *url;
    switch ([HirTool theCurrentLanguage]) {
        case 3:
        {
            url = @"http://hismart.co.kr/question";
        }
            break;
            
        default:
            url = @"http://hismart.us/contact";
            break;
    }
    return url;
}

+(NSString *)getPolicyString{
    NSString *url;
    switch ([HirTool theCurrentLanguage]) {
        case 3:
        {
            url = @"http://hismart.co.kr/privacy_policy";
        }
            break;
            
        default:
            url = @"http://hismart.us/help/privacy";
            break;
    }
    return url;
}

@end
