//
//  FMDMainViewController.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/22.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "FMDMainViewController.h"
#import "FMDPreviewViewController.h"
#import "FMDDeviceModelCell.h"
#import "FMDDeviceModel.h"
#import "FMDRenderer.h"
#import "AppDelegate.h"

static NSString * const CellIdentifier = @"Cell";

@interface FMDMainViewController () <UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    FMDDeviceModel *_lastSelectedModel;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSCache<NSURL *, UIImage *> *imageCache;

@property (weak) FMDResourceManager *resourceManager;

@end

@implementation FMDMainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.resourceManager = [AppDelegate sharedDelegate].resourceManager;
    self.imageCache = [[NSCache alloc] init];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 20);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionCellDidTap:) name:FMDDeviceModelCellDidTapNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self invalidateCellSize];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self invalidateCellSize];
    }];
    
}

- (void)invalidateCellSize {
    UICollectionViewFlowLayout *flowLayout = (id) self.collectionView.collectionViewLayout;
    CGFloat size;
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
            // iPad in fullscreen mode.
            size = (CGRectGetWidth(self.collectionView.frame) - 80) / 3;
        } else {
            // iPhone Plus.
            size = CGRectGetWidth(self.collectionView.frame) / 4;
        }
    } else {
        size = CGRectGetWidth(self.collectionView.frame) / 2;
    }
    
    size -= 10;

    flowLayout.itemSize = CGSizeMake(size, size);
    [flowLayout invalidateLayout];
}

- (void)collectionCellDidTap:(NSNotification *)notification {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:notification.object];
    FMDDeviceModel *model = [self.resourceManager deviceModelAtIndex:indexPath.item];
    
    [self beginCreatingImageWithModel:model];
}

- (UIImage *)createImageWithModel:(FMDDeviceModel *)model contentImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    
    CGImageRef resultImage = [FMDRenderer createImageWithDeviceModel:model contentImage:image.CGImage];
    
    if (!resultImage) {
        return nil;
    }
    
    UIImage *resultUIImage = [UIImage imageWithCGImage:resultImage];
    
    CGImageRelease(resultImage);
    
    return resultUIImage;
}

- (void)showPreviewControllerWithImage:(UIImage *)image {
    FMDPreviewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:FMDPreviewViewControllerStoryboardIdentifier];
    vc.image = image;
    [self showViewController:vc sender:nil];
}

#pragma mark - Actions

- (IBAction)unwindInMainViewController:(UIStoryboardSegue *)segue {
    
}

- (IBAction)changeColorCategory:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.popoverPresentationController.barButtonItem = sender;
    
    void (^handler)(UIAlertAction *action) = ^(UIAlertAction * _Nonnull action) {
        NSUInteger idx = [alert.actions indexOfObject:action];
        self.resourceManager.deviceColors = idx ? FMDResourceDeviceColorSilver : FMDResourceDeviceColorSpaceGray;
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:nil];
    };
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Space Gray" style:UIAlertActionStyleDefault handler:handler]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Silver" style:UIAlertActionStyleDefault handler:handler]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)beginCreatingImageWithModel:(FMDDeviceModel *)model {
    _lastSelectedModel = model;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.resourceManager numberOfDeviceModels];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMDDeviceModel *model = [self.resourceManager deviceModelAtIndex:indexPath.item];
    UIImage *image;
    if (!(image = [self.imageCache objectForKey:model.frameResourceURL])) {
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:model.frameResourceURL]];
        [self.imageCache setObject:image forKey:model.frameResourceURL];
    }
    
    FMDDeviceModelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = image;
    cell.textLabel.text = model.name;
    
    return cell;
}

#pragma mark - Image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIImage *image = [self createImageWithModel:_lastSelectedModel contentImage:info[UIImagePickerControllerOriginalImage]];
        if (!image) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed to synthetize." message:@"Screenshot is invalid.\n\nHint: You can use alternative images that has similar aspect ratio with actual devices'." preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        [self showPreviewControllerWithImage:image];
    }];
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
