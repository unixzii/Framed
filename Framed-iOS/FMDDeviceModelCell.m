//
//  FMDDeviceModelCell.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/22.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "FMDDeviceModelCell.h"

NSNotificationName const FMDDeviceModelCellDidTapNotification = @"FMDDeviceModelCellDidTapNotification";

@implementation FMDDeviceModelCell

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.contentView.alpha = 0.6;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self pointInside:[touches.allObjects.firstObject locationInView:self] withEvent:event]) {
        if (self.contentView.alpha != 0.6) {
            [self performFadeAnimation:YES slow:YES];
        }
    } else {
        if (self.contentView.alpha != 1) {
            [self performFadeAnimation:NO slow:YES];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performFadeAnimation:NO slow:NO];
    
    if ([self pointInside:[touches.allObjects.firstObject locationInView:self] withEvent:event]) {
        NSLog(@"YES");
        [[NSNotificationCenter defaultCenter] postNotificationName:FMDDeviceModelCellDidTapNotification object:self];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performFadeAnimation:NO slow:NO];
}

#pragma mark - Privates

- (void)performFadeAnimation:(BOOL)highlighted slow:(BOOL)slow {
    [UIView animateWithDuration:(slow ? 0.6 : 0.3) delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentView.alpha = highlighted ? 0.6 : 1;
    } completion:nil];
}

@end
