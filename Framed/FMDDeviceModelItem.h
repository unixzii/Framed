//
//  FMDDeviceModelItem.h
//  Framed
//
//  Created by 杨弘宇 on 2017/2/19.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

OBJC_EXTERN NSNotificationName const FMDDeviceModelItemDidClickNotification;

@interface FMDDeviceModelItem : NSCollectionViewItem

@property (weak) IBOutlet NSImageView *thumbnailImageView;
@property (weak) IBOutlet NSTextField *nameLabel;

@end
