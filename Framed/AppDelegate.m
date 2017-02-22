//
//  AppDelegate.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/19.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDResourceManager.h"

@interface AppDelegate () {
    FMDResourceManager *_resourceManager;
}

@end

@implementation AppDelegate

+ (instancetype)sharedDelegate {
    return NSApp.delegate;
}

- (FMDResourceManager *)resourceManager {
    if (!_resourceManager) {
        NSURL *resourceBundleURL = [[NSBundle mainBundle] URLForResource:@"FramedResources" withExtension:@"bundle"];
        _resourceManager = [[FMDResourceManager alloc] initWithBundle:[NSBundle bundleWithURL:resourceBundleURL]];
        _resourceManager.deviceRoles = FMDResourceDeviceRoleAll;
        _resourceManager.deviceColors = FMDResourceDeviceColorSpaceGray;
    }
    
    return _resourceManager;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
