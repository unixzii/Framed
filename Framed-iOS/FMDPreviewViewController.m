//
//  FMDPreviewViewController.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/22.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "FMDPreviewViewController.h"

NSString * const FMDPreviewViewControllerStoryboardIdentifier = @"FMDPreviewViewController";

@interface FMDPreviewViewController ()

@end

@implementation FMDPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.image;
}

@end
