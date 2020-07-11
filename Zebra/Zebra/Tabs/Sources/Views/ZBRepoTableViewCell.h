//
//  ZBRepoTableViewCell.h
//  Zebra
//
//  Created by Andrew Abosh on 2019-05-02.
//  Copyright © 2019 Wilson Styres. All rights reserved.
//

@class ZBBaseSource;

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBRepoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *repoLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundContainerView;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chevronView;

- (void)clearAccessoryView;
- (void)setSpinning:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
