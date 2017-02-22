//
//  FMDMainWindow.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/19.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "FMDMainWindow.h"

@implementation FMDMainWindow

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [NSColor whiteColor];
    self.titlebarAppearsTransparent = YES;
    self.styleMask |= NSWindowStyleMaskFullSizeContentView;
}

@end
