//
//  FMDRenderer.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/21.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>

#import "FMDRenderer.h"

//#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
CGRect NSRectFromString(NSString *string) {
    CGRect result;
    NSString *normalized = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:normalized];
    [scanner scanString:@"{{" intoString:nil];
    [scanner scanDouble:&result.origin.x];
    [scanner scanString:@"," intoString:nil];
    [scanner scanDouble:&result.origin.y];
    [scanner scanString:@"},{" intoString:nil];
    [scanner scanDouble:&result.size.width];
    [scanner scanString:@"," intoString:nil];
    [scanner scanDouble:&result.size.height];
    
    return result;
}
//#endif

@implementation FMDRenderer

+ (CGImageRef)createImageWithDeviceModel:(FMDDeviceModel *)model contentImage:(CGImageRef)image {
    CGImageSourceRef frameImageSource = CGImageSourceCreateWithURL((__bridge CFURLRef) model.frameResourceURL, NULL);
    CGImageRef frameImage = CGImageSourceCreateImageAtIndex(frameImageSource, 0, NULL);
    
    if (!frameImage) {
        return nil;
    }
    
    CGRect screenFrame = NSRectFromString(model.frameRectString);
    
    CGFloat width = CGImageGetWidth(frameImage);
    CGFloat height = CGImageGetHeight(frameImage);
    
    CGFloat contentWidth = CGImageGetWidth(image);
    CGFloat contentHeight = CGImageGetHeight(image);
    
    CGFloat ratio = CGRectGetWidth(screenFrame) / CGRectGetHeight(screenFrame);
    CGFloat contentRatio = contentWidth / contentHeight;
    BOOL shouldRotate = NO;
    
    if (fabs(ratio - contentRatio) > 0.01) {
        if (fabs(ratio - 1.0 / contentRatio) > 0.01) {
            return NULL;
        }
        shouldRotate = YES;
    }
    
    // Scale the image via Core Image.
//    CIImage *contentCIImage = [CIImage imageWithCGImage:image];
//    CIFilter *scaleFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
//    [scaleFilter setValue:contentCIImage forKey:kCIInputImageKey];
//    [scaleFilter setValue:@(1) forKey:@"inputScale"];
//    [scaleFilter setValue:@(1) forKey:@"inputAspectRatio"];
//    CIImage *scaledContentCIImage = scaleFilter.outputImage;
//    CIContext *ciContext = [[CIContext alloc] initWithOptions:nil];
//    CGImageRef scaledContentImage = [ciContext createCGImage:scaledContentCIImage fromRect:scaledContentCIImage.extent];
    
    // TODO: Actually, I can't tell the filtered image from the original.
    CGImageRef scaledContentImage = image;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, shouldRotate ? height : width, shouldRotate ? width : height, 8, (shouldRotate ? height : width) * 4, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextSaveGState(context);
    
    if (shouldRotate) {
        CGContextTranslateCTM(context, height / 2, -width / 2);
        CGContextRotateCTM(context, M_PI_2);
        CGContextDrawImage(context, CGRectMake(width / 2, -height / 2, width, height), frameImage);
    } else {
        CGContextTranslateCTM(context, width / 2, -height / 2);
        CGContextDrawImage(context, CGRectMake(-width / 2, height / 2, width, height), frameImage);
    }
    
    CGContextRestoreGState(context);
    
    if (shouldRotate) {
        CGContextDrawImage(context, CGRectMake(screenFrame.origin.y, screenFrame.origin.x, screenFrame.size.height, screenFrame.size.width), scaledContentImage);
    } else {
        CGContextDrawImage(context, CGRectMake(screenFrame.origin.x, screenFrame.origin.y + 3, screenFrame.size.width, screenFrame.size.height), scaledContentImage);
    }
    
    CGImageRef resultImage = CGBitmapContextCreateImage(context);
    
//    CGImageRelease(scaledContentImage);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(frameImage);
    CFRelease(frameImageSource);
    
    return resultImage;
}

@end
