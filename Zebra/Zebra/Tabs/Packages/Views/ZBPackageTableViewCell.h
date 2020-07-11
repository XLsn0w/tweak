//
//  ZBPackageTableViewCell.h
//  Zebra
//
//  Created by Andrew Abosh on 2019-05-01.
//  Copyright © 2019 Wilson Styres. All rights reserved.
//

@class ZBPackage;
#import <UIKit/UIKit.h>
#import <Queue/ZBQueueType.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBPackageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backgroundContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isPaidImageView;
@property (weak, nonatomic) IBOutlet UIImageView *isInstalledImageView;
@property (weak, nonatomic) IBOutlet UILabel *queueStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorAndRepoAndSize;
- (void)updateData:(ZBPackage *)package;
- (void)updateData:(ZBPackage *)package calculateSize:(BOOL)calculateSize;
- (void)updateQueueStatus:(ZBPackage *)package;
- (void)setColors;
@end

NS_ASSUME_NONNULL_END
