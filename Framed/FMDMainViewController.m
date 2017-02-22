//
//  FMDMainViewController.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/19.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "FMDMainViewController.h"
#import "FMDPreviewViewController.h"
#import "FMDDeviceModelItem.h"
#import "FMDResourceManager.h"
#import "FMDDeviceModel.h"
#import "FMDRenderer.h"
#import "AppDelegate.h"

static NSString * const CellIdentifier = @"FMDDeviceModelItem";

@interface FMDMainViewController () <NSCollectionViewDataSource, NSCollectionViewDelegate>

@property (weak) IBOutlet NSCollectionView *collectionView;

@property (weak) FMDResourceManager *resourceManager;
@property (strong, nonatomic) NSCache<NSURL *, NSImage *> *imageCache;

@property (strong) NSMutableArray<NSWindow *> *retainPreviewWindow;

@end

@implementation FMDMainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resourceManager = [AppDelegate sharedDelegate].resourceManager;
    self.imageCache = [[NSCache alloc] init];
    
    _retainPreviewWindow = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionItemDidClick:) name:FMDDeviceModelItemDidClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(previewWindowWillClose:) name:NSWindowWillCloseNotification object:nil];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    NSClipView *clipView = (id) self.collectionView.superview;
    [clipView scrollToPoint:NSMakePoint(-18, -72)];
    [((NSScrollView *) clipView.superview) reflectScrolledClipView:clipView];
}

- (NSImage *)createImageWithModel:(FMDDeviceModel *)model contentURL:(NSURL *)URL {
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef) URL, NULL);
    CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    if (!image) {
        return nil;
    }
    
    CGImageRef resultImage = [FMDRenderer createImageWithDeviceModel:model contentImage:image];
    
    CGImageRelease(image);
    CFRelease(imageSource);
    
    if (!resultImage) {
        return nil;
    }
    
    NSImage *resultCocoaImage = [[NSImage alloc] initWithCGImage:resultImage size:NSMakeSize(CGImageGetWidth(resultImage), CGImageGetHeight(resultImage))];
    
    CGImageRelease(resultImage);
    
    return resultCocoaImage;
}

- (void)showPreviewWindowWithImage:(NSImage *)image deviceColor:(uint8_t)color {
    NSWindow *panel = [NSWindow new];
    [panel setTitlebarAppearsTransparent:YES];
    [panel setAppearance:[NSAppearance appearanceNamed:color != 1 ? NSAppearanceNameVibrantLight : NSAppearanceNameVibrantDark]];
    panel.styleMask |= NSWindowStyleMaskClosable;
    panel.styleMask |= NSWindowStyleMaskFullSizeContentView;
    panel.animationBehavior = NSWindowAnimationBehaviorDocumentWindow;
    
    NSWindowController *wc = [[NSWindowController alloc] initWithWindow:panel];
    wc.contentViewController = [self.storyboard instantiateControllerWithIdentifier:@"FMDPreviewViewController"];
    ((FMDPreviewViewController *) wc.contentViewController).imageView.image = image;
    [wc.window setContentSize:NSMakeSize(image.size.width / 1.5, image.size.height / 1.5)];
    [wc.window center];
    
    [wc showWindow:nil];
    
    [self.retainPreviewWindow addObject:wc.window];
}

- (void)previewWindowWillClose:(NSNotification *)note {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.retainPreviewWindow removeObject:note.object];
    }];
}

- (void)collectionItemDidClick:(NSNotification *)note {
    NSIndexPath *indexPath = [self.collectionView indexPathForItem:note.object];
    FMDDeviceModel *model = [self.resourceManager deviceModelAtIndex:indexPath.item];
    
    [self beginCreatingImageWithModel:model];
}

#pragma mark - Actions

- (IBAction)colorCategoryDidChange:(id)sender {
    NSSegmentedControl *control = sender;
    self.resourceManager.deviceColors = control.selectedSegment == 0 ? FMDResourceDeviceColorSpaceGray : FMDResourceDeviceColorSilver;
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completionHandler:nil];
}

- (void)beginCreatingImageWithModel:(FMDDeviceModel *)model {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowedFileTypes = @[@"png"];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSImage *image = [self createImageWithModel:model contentURL:panel.URL];
                if (!image) {
                    NSAlert *alert = [[NSAlert alloc] init];
                    [alert setAlertStyle:NSAlertStyleCritical];
                    [alert setMessageText:@"Failed to synthetize."];
                    [alert setInformativeText:@"Screenshot is invalid.\n\nHint: You can use alternative images that has similar aspect ratio with actual devices'."];
                    [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
                    return;
                }
                
                [self showPreviewWindowWithImage:image deviceColor:model.color];
            }];
        }
    }];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.resourceManager numberOfDeviceModels];
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    FMDDeviceModel *model = [self.resourceManager deviceModelAtIndex:indexPath.item];
    NSImage *image;
    if (!(image = [self.imageCache objectForKey:model.frameResourceURL])) {
        image = [[NSImage alloc] initWithContentsOfURL:model.frameResourceURL];
        [self.imageCache setObject:image forKey:model.frameResourceURL];
    }
    
    FMDDeviceModelItem *item = [collectionView makeItemWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    item.thumbnailImageView.image = image;
    item.nameLabel.stringValue = model.name;
    
    return item;
}

@end
