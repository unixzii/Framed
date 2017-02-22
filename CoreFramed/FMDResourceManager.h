//
//  FMDResourceManager.h
//  Framed
//
//  Created by 杨弘宇 on 2017/2/19.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDDeviceModel;

typedef NS_OPTIONS(NSUInteger, FMDResourceDeviceColor) {
    FMDResourceDeviceColorSpaceGray = 1,
    FMDResourceDeviceColorSilver = 1 << 1
};

typedef NS_OPTIONS(NSUInteger, FMDResourceDeviceRole) {
    FMDResourceDeviceRoleAll = 7,
    FMDResourceDeviceRolePhone = 1,
    FMDResourceDeviceRolePad = 1 << 1,
    FMDResourceDeviceRoleWatch = 1 << 2,
};

@interface FMDResourceManager : NSObject

@property (assign, nonatomic) FMDResourceDeviceColor deviceColors;
@property (assign, nonatomic) FMDResourceDeviceRole deviceRoles;

- (instancetype)initWithBundle:(NSBundle *)bundle;

- (NSUInteger)numberOfDeviceModels;
- (FMDDeviceModel *)deviceModelAtIndex:(NSUInteger)idx;

@end
