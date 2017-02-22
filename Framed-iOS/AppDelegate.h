//
//  AppDelegate.h
//  Framed-iOS
//
//  Created by 杨弘宇 on 2017/2/22.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDResourceManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly) FMDResourceManager *resourceManager;

+ (instancetype)sharedDelegate;

@end

