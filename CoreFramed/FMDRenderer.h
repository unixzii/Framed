//
//  FMDRenderer.h
//  Framed
//
//  Created by 杨弘宇 on 2017/2/21.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "FMDDeviceModel.h"

@interface FMDRenderer : NSObject

+ (CGImageRef)createImageWithDeviceModel:(FMDDeviceModel *)model contentImage:(CGImageRef)image;

@end
