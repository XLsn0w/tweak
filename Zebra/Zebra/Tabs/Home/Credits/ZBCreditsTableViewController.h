//
//  ZBCreditsTableViewController.h
//  Zebra
//
//  Created by Wilson Styres on 10/25/19.
//  Copyright © 2019 Wilson Styres. All rights reserved.
//

#import <UIKit/UIKit.h>

@import SafariServices;

NS_ASSUME_NONNULL_BEGIN

@interface ZBCreditsTableViewController : UITableViewController <SFSafariViewControllerDelegate>
@property (nonatomic, strong) NSArray *credits;
@end

NS_ASSUME_NONNULL_END
