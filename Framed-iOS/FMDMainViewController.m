//
//  FMDMainViewController.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/22.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "FMDMainViewController.h"
#import "AppDelegate.h"

@interface FMDMainViewController ()

@property (weak) FMDResourceManager *resourceManager;

@end

@implementation FMDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.resourceManager = [AppDelegate sharedDelegate].resourceManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)unwindInMainViewController:(UIStoryboardSegue *)segue {
    
}

- (IBAction)changeColorCategory:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.popoverPresentationController.barButtonItem = sender;
    
    void (^handler)(UIAlertAction *action) = ^(UIAlertAction * _Nonnull action) {
        
    };
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Space Gray" style:UIAlertActionStyleDefault handler:handler]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Silver" style:UIAlertActionStyleDefault handler:handler]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:handler]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)presentAboutViewController:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
