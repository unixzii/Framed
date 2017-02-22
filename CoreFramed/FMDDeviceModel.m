//
//  FMDDeviceModel.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/19.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "FMDDeviceModel.h"

@implementation FMDDeviceModel

- (id)copyWithZone:(NSZone *)zone {
    FMDDeviceModel *instance = [[FMDDeviceModel allocWithZone:zone] init];
    instance.name = self.name;
    instance.idString = self.idString;
    instance.frameRectString = self.frameRectString;
    instance.frameResourceURL = self.frameResourceURL;
    instance.role = self.role;
    instance.color = self.color;
    
    return instance;
}

@end
