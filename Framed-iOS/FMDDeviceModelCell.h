//
//  FMDDeviceModelCell.h
//  Framed
//
//  Created by 杨弘宇 on 2017/2/22.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>

OBJC_EXTERN NSNotificationName const FMDDeviceModelCellDidTapNotification;

@interface FMDDeviceModelCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
