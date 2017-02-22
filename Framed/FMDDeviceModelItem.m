//
//  FMDDeviceModelItem.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/19.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import <Quartz/Quartz.h>

#import "FMDDeviceModelItem.h"

NSNotificationName const FMDDeviceModelItemDidClickNotification = @"FMDDeviceModelItemDidClickNotification";

@interface FMDDeviceModelItem () {
    CAShapeLayer *_highlightedBackgroundLayer;
    BOOL _highlighted;
}

@end

@implementation FMDDeviceModelItem

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _highlightedBackgroundLayer = [CAShapeLayer layer];
    _highlightedBackgroundLayer.fillColor = [NSColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00].CGColor;
    _highlightedBackgroundLayer.opacity = 0;
    
    [self.view.layer insertSublayer:_highlightedBackgroundLayer atIndex:0];
}

- (void)viewDidLayout {
    [super viewDidLayout];
    
    _highlightedBackgroundLayer.frame = self.view.bounds;
    CGPathRef path = CGPathCreateWithRoundedRect(self.view.bounds, 4, 4, nil);
    _highlightedBackgroundLayer.path = path;
    CGPathRelease(path);
}

- (void)mouseDown:(NSEvent *)event {
    _highlighted = YES;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _highlightedBackgroundLayer.opacity = 1;
    [CATransaction commit];
}

- (void)mouseUp:(NSEvent *)event {
    if (_highlighted) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FMDDeviceModelItemDidClickNotification object:self];
    }
    
    _highlightedBackgroundLayer.opacity = 0;
    _highlighted = NO;
}

- (void)mouseDragged:(NSEvent *)event {
    CGPoint location = [event locationInWindow];
    location = [self.view convertPoint:location fromView:nil];
    _highlighted = CGRectContainsPoint(self.view.bounds, location);
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    _highlightedBackgroundLayer.opacity = _highlighted ? 1 : 0;
    [CATransaction commit];
}

@end
