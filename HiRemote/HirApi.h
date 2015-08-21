//
//  HirApi.h
//  HiRemote
//
//  Created by minfengliu on 15/8/20.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#ifndef HiRemote_HirApi_h
#define HiRemote_HirApi_h

#ifdef DEBUG
#define HIR_DOMAIN   @"http://192.168.31.210:8090/lepow"
#else
#define HIR_DOMAIN   @""
#endif


//face book login
#define HIR_API_FACEBOOK_LOGIN  [NSString stringWithFormat:@"%@%@",HIR_DOMAIN,@"/api/member/facebook/login"]

//emial login
#define HIR_API_MEMBER_LOGIN    [NSString stringWithFormat:@"%@%@",HIR_DOMAIN,@"/api/member/login"]

//logout
#define HIR_API_MEMBER_LOGOUT   [NSString stringWithFormat:@"%@%@",HIR_DOMAIN,@"/api/member/logout"]

//findpwd
#define HIR_API_MEMBER_FIND_PWD [NSString stringWithFormat:@"%@%@",HIR_DOMAIN,@"/api/member/findpwd"]

//register
#define HIR_API_MEMBER_REGISTER [NSString stringWithFormat:@"%@%@",HIR_DOMAIN,@"/api/member/register"]

#endif
