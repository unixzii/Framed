//
//  FMDDeviceModel.h
//  Framed
//
//  Created by 杨弘宇 on 2017/2/19.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDDeviceModel : NSObject <NSCopying>

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *idString;
@property (copy, nonatomic) NSString *frameRectString;
@property (copy, nonatomic) NSURL *frameResourceURL;
@property (assign, nonatomic) uint8_t role;
@property (assign, nonatomic) uint8_t color;

@end
