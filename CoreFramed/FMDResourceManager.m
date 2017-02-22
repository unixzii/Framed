//
//  FMDResourceManager.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/19.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "FMDResourceManager.h"
#import "FMDDeviceModel.h"

@interface FMDResourceManager () {
    NSBundle *_bundle;
    NSArray<FMDDeviceModel *> *_models;
    NSArray<FMDDeviceModel *> *_filteredModels;
}

@end

@implementation FMDResourceManager

- (instancetype)initWithBundle:(NSBundle *)bundle {
    self = [super init];
    if (self) {
        _bundle = bundle;
        [self loadData];
    }
    return self;
}

- (void)loadData {
    NSURL *manifestPlistURL = [_bundle URLForResource:@"manifest" withExtension:@"plist"];
    NSData *manifestPlistData = [NSData dataWithContentsOfURL:manifestPlistURL];
    NSArray *manifestPlist = [NSPropertyListSerialization propertyListWithData:manifestPlistData options:NSPropertyListImmutable format:nil error:nil];
    
    NSMutableArray *models = [NSMutableArray array];
    [manifestPlist enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FMDDeviceModel *spaceGrayModel = [[FMDDeviceModel alloc] init];
        spaceGrayModel.name = [obj objectForKey:@"FMDModelName"];
        spaceGrayModel.idString = [obj objectForKey:@"FMDModelID"];
        spaceGrayModel.frameRectString = [obj objectForKey:@"FMDContentFrame"];
        spaceGrayModel.frameResourceURL = [_bundle URLForResource:[NSString stringWithFormat:@"%@-B", spaceGrayModel.idString] withExtension:@"png"];
        spaceGrayModel.role = [[obj objectForKey:@"FMDModelRole"] unsignedCharValue];
        spaceGrayModel.color = FMDResourceDeviceColorSpaceGray;
        
        FMDDeviceModel *silverModel = [spaceGrayModel copy];
        silverModel.frameResourceURL = [_bundle URLForResource:[NSString stringWithFormat:@"%@-W", silverModel.idString] withExtension:@"png"];
        silverModel.color = FMDResourceDeviceColorSilver;
        
        [models addObject:spaceGrayModel];
        [models addObject:silverModel];
    }];
    
    _models = [models copy];
}

- (void)reloadFilteredData {
    NSMutableArray *filteredModels = [NSMutableArray array];
    [_models enumerateObjectsUsingBlock:^(FMDDeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL qualified = YES;
        
        if (!(obj.color & _deviceColors)) {
            qualified = NO;
        }
        
        if (!(obj.role & _deviceRoles)) {
            qualified = NO;
        }
        
        if (qualified) {
            [filteredModels addObject:obj];
        }
    }];
    
    _filteredModels = [filteredModels copy];
}

- (void)setDeviceRoles:(FMDResourceDeviceRole)deviceRoles {
    if (_deviceRoles != deviceRoles) {
        _deviceRoles = deviceRoles;
        [self reloadFilteredData];
    }
}

- (void)setDeviceColors:(FMDResourceDeviceColor)deviceColors {
    if (_deviceColors != deviceColors) {
        _deviceColors = deviceColors;
        [self reloadFilteredData];
    }
}

- (NSUInteger)numberOfDeviceModels {
    return _filteredModels.count;
}

- (FMDDeviceModel *)deviceModelAtIndex:(NSUInteger)idx {
    return [_filteredModels objectAtIndex:idx];
}

@end
