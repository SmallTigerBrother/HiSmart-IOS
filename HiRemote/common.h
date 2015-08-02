


//#import "serverInterface.h"

#pragma mark -singletonClass

#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}


#define API_KEY @"P6S5YolY2RZWMgk4kguq6SF2" // 请修改为您在百度开发者平台申请的API_KEY
#define SECRET_KEY @"zxE6eYCmRmIaRzm5LVV6t6CDfiiskt5Z" // 请修改您在百度开发者平台申请的SECRET_KEY

#pragma mark -Common
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define KUIStoryBoard(name)   [UIStoryboard storyboardWithName:(name) bundle:nil]
#define kMainBundlePath  [[NSBundle mainBundle] bundlePath]
#define kLoadImage(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:@"png"]]
#define KNSstring(number) [NSString stringWithFormat:@"%@",number]
#define KRGB(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define KRGBA(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define iphone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define iOS6  ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)
#define iOS7  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
#define iOS8  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)

#define  kUIScreenBounds  [UIScreen mainScreen].bounds
#define  kRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

#define  kApplicationDelegate ([[UIApplication sharedApplication]delegate])
#define  kAcessViewHeight  40
#define KConnectViewHeight 44
#define kDocumentFile(fileName)  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:fileName]

#define kCachesFile(fileName)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:fileName]

#define kTempFile(fileName)([NSTemporaryDirectory()stringByAppendingPathComponent:fileName])





#define UserDefaults [NSUserDefaults standardUserDefaults]
#pragma mark - localizable
#define klocalizeString(name) NSLocalizedString((@#name), nil)
#define SWITCH_HEIGHT                            27
#define SWITCH_WIDTH                             48
#define CHINESE @zh-Hans
#define ENGLISH @en

#define kUserFacePath @"userPhotoImage"
#define kTempUserFacePath @"UnloginUserPhotoImage"
#define kRegisterUserFacePath @"registerUserPhotoImage"
#define kTestHeartRateInterval 240
#define kKileMeter 0.001
#define kCaloriePerStep 0.04
#define kTransitionInterval 0.1
#define kUnLoginUserId @"0000"
#define kSpeedTimes (3.6*3600)
#define kDataPackageCGfloatNum (288.0)
#define kDataPackageIntergerNum (288)
#define kSearchCount  5
#define kFileManger [NSFileManager defaultManager]

#define ShareSdkAPIKey @"625d488c3cb1"//625d488c3cb1
#define ShareAppTitle  NSLocalizedString(@"localShareVCCompanyTitle", nil)

#define UMENG_APPKEY   @"55ab623067e58ea3c8009438"
#define ShareAppUrl @"http://www.i-spk.com"

#define UpdateAppUrlString @""

#define ShowTestAlert   @"ShowTestAlert"

#define NotificationVoiceOpen @"NotificationVoiceOpen"


#define HirFAQUrl @"http://hismart.us/faq"
#define HirContactUs @"http://hismart.us/contact"
#define HirTeamsAndConditions @"http://hismart.us/about"
#define HirPrivacyPolicy @"http://hismart.us/help/privacy"

#if DEBUG
// 日志输出
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif
