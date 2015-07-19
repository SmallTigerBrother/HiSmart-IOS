//
//  HIRRenameViewController.m
//  HiRemote
//
//  Created by parker on 6/30/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRRenameViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVFoundation.h>
#import "PureLayout.h"
#import "HIRCBCentralClass.h"
//#import "HIRRemoteData.h"
#import "HIRArcImageView.h"
#import "AppDelegate.h"
#import "HirDataManageCenter+Perphera.h"

@interface HIRRenameViewController () <UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong)HIRArcImageView *photoView;
@property (nonatomic, strong)UIButton *photoButton;
@property (nonatomic, strong)UILabel *tipsLabel;
@property (nonatomic, strong)UIButton *renameButton;
@property (nonatomic, strong)UIButton *nextButton;
@property (nonatomic, strong) NSMutableArray *deviceInfoArray;
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, strong)DBPeriphera *hiRemoteData; ///保存更新后的名字
@end

@implementation HIRRenameViewController
@synthesize photoView;
@synthesize photoButton;
@synthesize tipsLabel;
@synthesize renameButton;
@synthesize nextButton;
@synthesize hiRemoteData;
@synthesize deviceInfoArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.35 green:0.75 blue:0.58 alpha:1];
    self.deviceInfoArray = [HirUserInfo shareUserInfo].deviceInfoArray;
    self.photoView = [[HIRArcImageView alloc] init];
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.photoButton setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    //[self.photoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.text = NSLocalizedString(@"photoTips", @"");
    self.tipsLabel.textColor = [UIColor whiteColor];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.numberOfLines = 0;
    self.renameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.renameButton.backgroundColor = [UIColor colorWithRed:0.44 green:0.76 blue:0.63 alpha:1];
    [self.renameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.renameButton setTitle:NSLocalizedString(@"rename", @"") forState:UIControlStateNormal];
    [self.renameButton addTarget:self action:@selector(renameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.nextButton.backgroundColor = [UIColor colorWithRed:0.44 green:0.76 blue:0.63 alpha:1];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton setTitle:NSLocalizedString(@"next", @"") forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    for (DBPeriphera *data in self.deviceInfoArray) {
        if ([[[HIRCBCentralClass shareHIRCBcentralClass].discoveredPeripheral.identifier UUIDString] isEqualToString:data.uuid]) {
            self.hiRemoteData = data;
            break;
        }
    }
    
    [self.view addSubview:self.photoView];
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.renameButton];
    [self.view addSubview:self.nextButton];
    [self.view setNeedsUpdateConstraints];
    
    double delayInSeconds = 0.1;
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(dispatchTime,dispatch_get_main_queue(), ^(void){
        
        if ([self.hiRemoteData.remarkName length] > 0) {
            [self.renameButton setTitle:self.hiRemoteData.remarkName forState:UIControlStateNormal];
        }else {
            [self.renameButton setTitle:self.hiRemoteData.name forState:UIControlStateNormal];
        }
        [self.photoView setImage:[UIImage imageNamed:@"defaultDevice"]];
        
//        if ([self.hiRemoteData.avatarPath length] > 0) {
//            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//            documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"HiRemoteData"];
//            if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
//                [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:TRUE attributes:nil error:nil];
//            }
//            if (documentsDirectory) {
//                 NSString *filePath = [documentsDirectory stringByAppendingPathComponent:self.hiRemoteData.avatarPath];
//                NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//                UIImage *image = [UIImage imageWithData:imageData];
//                if (image) {
//                    [self.photoView setImage:image];
//                    [self.photoButton setImage:nil forState:UIControlStateNormal];
//                    
//                }
//            }
//            if ([self.hiRemoteData.remarkName length] > 0) {
//                [self.renameButton setTitle:self.hiRemoteData.remarkName forState:UIControlStateNormal];
//            }else {
//                [self.renameButton setTitle:self.hiRemoteData.name forState:UIControlStateNormal];
//            }
//        }
    });
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.photoView autoSetDimensionsToSize:CGSizeMake(130, 130)];
        [self.photoView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.photoView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:80];
        
        [self.photoButton autoSetDimensionsToSize:CGSizeMake(130, 130)];
        [self.photoButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.photoView];
        [self.photoButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.photoView];

        [self.tipsLabel autoSetDimension:ALDimensionHeight toSize:60];
        [self.tipsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
        [self.tipsLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
        [self.tipsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.photoButton withOffset:10];
        
        [self.renameButton autoSetDimension:ALDimensionHeight toSize:40];
        [self.renameButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
        [self.renameButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
        [self.renameButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipsLabel withOffset:60];
        [self.nextButton autoSetDimension:ALDimensionHeight toSize:40];
        [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
        [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
        [self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.self.renameButton withOffset:50];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) photoButtonClick:(id)sender {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (version > 6.99) {
//        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        if (authStatus != AVAuthorizationStatusAuthorized) {
//            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"") message:NSLocalizedString(@"accessCameraTip", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @""), nil] show];
//            return;
//        }
//    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = YES;
        [self presentViewController:controller animated:YES completion:nil];
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = YES;
        [self presentViewController:controller animated:YES completion:nil];
    }
}


- (void)renameButtonClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"renameTips", @"") message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @""),NSLocalizedString(@"cancel", @""), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)nextButtonClick:(id)sender {
    AppDelegate *appDeleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  
    [HirDataManageCenter savePerpheraByModel:self.hiRemoteData];
    [appDeleg connectSuccessToShowRootVC];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (textField.text && [textField.text length] > 0) {
            self.hiRemoteData.remarkName = textField.text;
            [self.renameButton setTitle:textField.text forState:UIControlStateNormal];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil){
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    CGSize size = CGSizeMake(130, 130);
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    NSData *imageData = UIImagePNGRepresentation(scaledImage);
    
    [self.photoButton setImage:nil forState:UIControlStateNormal];
    [self.photoView setImage:scaledImage];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"HiRemoteData"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:TRUE attributes:nil error:nil];
    }
    if (!documentsDirectory) {
        return;
    }
    NSString *avatarName = [NSString stringWithFormat:@"avata%lld",(long long)[[NSDate date] timeIntervalSince1970]];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:avatarName];
    self.hiRemoteData.avatarPath = avatarName;
    
    [imageData writeToFile:filePath atomically:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"rename delloc");
    self.photoView = nil;
    self.photoButton = nil;
    self.tipsLabel = nil;
    self.renameButton = nil;
    self.nextButton = nil;
    self.hiRemoteData = nil;
}

@end
