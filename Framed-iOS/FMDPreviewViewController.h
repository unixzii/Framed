//
//  FMDPreviewViewController.h
//  Framed
//
//  Created by 杨弘宇 on 2017/2/22.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>

OBJC_EXTERN NSString * const FMDPreviewViewControllerStoryboardIdentifier;

@interface FMDPreviewViewController : UIViewController

@property (strong, nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
