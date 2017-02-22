//
//  FMDPreviewViewController.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/21.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "FMDPreviewViewController.h"

@interface FMDPreviewViewController ()

@property (copy) NSArray<NSSharingService *> *sharingServices;

@end

@implementation FMDPreviewViewController

- (NSData *)dataRepresentation {
    NSImage *image = self.imageView.image;
    NSData *tiffData = [image TIFFRepresentation];
    return [[NSBitmapImageRep imageRepWithData:tiffData] representationUsingType:NSPNGFileType properties:@{}];
}

- (IBAction)share:(id)sender {
    if (!self.sharingServices)
        self.sharingServices = [NSSharingService sharingServicesForItems:@[self.imageView.image]];
    
    NSMenu *shareMenu = [[NSMenu alloc] init];
    [shareMenu addItemWithTitle:@"Save" action:@selector(save:) keyEquivalent:@""];
    [shareMenu addItem:[NSMenuItem separatorItem]];
    
    [self.sharingServices enumerateObjectsUsingBlock:^(NSSharingService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:obj.menuItemTitle action:@selector(shareItem:) keyEquivalent:@""];
        menuItem.image = obj.image;
        menuItem.tag = idx;
        [shareMenu addItem:menuItem];
    }];
    
    [shareMenu popUpMenuPositioningItem:nil atLocation:NSMakePoint(0, 20) inView:sender];
}

- (void)shareItem:(id)sender {
    NSSharingService *ss = [self.sharingServices objectAtIndex:[sender tag]];
    [ss performWithItems:@[self.imageView.image]];
}

- (void)copy:(id)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    [pb writeObjects:@[self.imageView.image]];
}

- (void)save:(id)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.allowedFileTypes = @[@"png"];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[self dataRepresentation] writeToURL:panel.URL atomically:YES];
            }];
        }
    }];
}

@end
