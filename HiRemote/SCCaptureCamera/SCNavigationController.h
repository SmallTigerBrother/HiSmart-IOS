//
//  SCNavigationController.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-17.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDefines.h"
#import "SCCaptureCameraController.h"


@protocol SCNavigationControllerDelegate;

@interface SCNavigationController : UINavigationController


- (void)showCameraWithParentController:(UIViewController*)parentController;

@property (nonatomic, assign) id <SCNavigationControllerDelegate> scNaigationDelegate;

@property (nonatomic, strong)SCCaptureCameraController *captureCameraController;


@end



@protocol SCNavigationControllerDelegate <NSObject>
@optional
- (BOOL)willDismissNavigationController:(SCNavigationController*)navigatonController;

- (void)didTakePicture:(SCNavigationController*)navigationController image:(UIImage*)image;

@end