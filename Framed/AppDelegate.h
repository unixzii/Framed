//
//  AppDelegate.h
//  Framed
//
//  Created by 杨弘宇 on 2017/2/19.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FMDResourceManager;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly) FMDResourceManager *resourceManager;

+ (instancetype)sharedDelegate;

@end

