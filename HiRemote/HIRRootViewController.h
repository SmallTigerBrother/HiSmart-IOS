//
//  HIRRootViewController.h
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HirRootSetSwith) {
  //  HirRootSetSwith_Connect,
//    HirRootSetSwith_FindMyItem,
    HirRootSetSwith_Notification,
    HirRootSetSwith_VoiceMemo,
    HirRootSetSwith_PlaySounds,
};

@interface HIRRootViewController : UIViewController

///1 english 2chinese 3korea
+(int)theCurrentLanguage;
@end

