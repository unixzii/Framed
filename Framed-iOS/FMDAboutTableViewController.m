//
//  FMDAboutTableViewController.m
//  Framed
//
//  Created by 杨弘宇 on 2017/2/22.
//  Copyright © 2017年 Cyandev. All rights reserved.
//

#import "FMDAboutTableViewController.h"

@interface FMDAboutItem : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSString *copyableString;
@property (strong, nonatomic) id representedObject;

+ (instancetype)itemWithTitle:(NSString *)title detail:(NSString *)detail representing:(id)obj;

@end

@implementation FMDAboutItem

+ (instancetype)itemWithTitle:(NSString *)title detail:(NSString *)detail representing:(id)obj {
    FMDAboutItem *item = [[FMDAboutItem alloc] init];
    item.title = title;
    item.detail = detail;
    item.representedObject = obj;
    
    return item;
}

@end


static NSString * const CellIdentifier = @"Cell";

@interface FMDAboutTableViewController ()

@property (copy, nonatomic) NSArray<NSArray<FMDAboutItem *> *> *items;

@end

@implementation FMDAboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeItems {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *coreVersion = [[NSBundle bundleWithIdentifier:@"com.cyandev.xplatform.CoreFramed-iOS"] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    FMDAboutItem *verItem = [FMDAboutItem itemWithTitle:@"Version" detail:version representing:nil];
    FMDAboutItem *coreVerItem = [FMDAboutItem itemWithTitle:@"Core Version" detail:coreVersion representing:nil];
    
    FMDAboutItem *emailItem = [FMDAboutItem itemWithTitle:@"Email" detail:@"unixzii@gmail.com" representing:@"mailto:unixzii@gmail.com"];
    emailItem.copyableString = emailItem.detail;
    FMDAboutItem *weiboItem = [FMDAboutItem itemWithTitle:@"Weibo" detail:@"@Cyandev" representing:@"http://weibo.com/2834711045/profile"];
    weiboItem.copyableString = [weiboItem.detail substringFromIndex:1];
    FMDAboutItem *githubItem = [FMDAboutItem itemWithTitle:@"GitHub" detail:@"unixzii" representing:@"https://github.com/unixzii"];
    githubItem.copyableString = githubItem.detail;
    
    FMDAboutItem *scItem = [FMDAboutItem itemWithTitle:@"Source Code" detail:nil representing:@"https://github.com/unixzii/Framed"];
    
    self.items = @[
                   @[verItem, coreVerItem],
                   @[emailItem, weiboItem, githubItem],
                   @[scItem]
                   ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    FMDAboutItem *item = self.items[indexPath.section][indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.detail;
    cell.selectionStyle = item.representedObject ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDAboutItem *item = self.items[indexPath.section][indexPath.row];
    return item.copyableString;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return [NSStringFromSelector(action) isEqualToString:NSStringFromSelector(@selector(copy:))];
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    FMDAboutItem *item = self.items[indexPath.section][indexPath.row];
    [[UIPasteboard generalPasteboard] setString:item.copyableString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDAboutItem *item = self.items[indexPath.section][indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.representedObject] options:@{} completionHandler:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
