//
//  ZBSourceImportTableViewController.h
//  Zebra
//
//  Created by Wilson Styres on 1/5/20.
//  Copyright © 2020 Wilson Styres. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "../Helpers/ZBSourceVerificationDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBSourceImportTableViewController : UITableViewController <ZBSourceVerificationDelegate>
@property (nonatomic) NSArray <NSURL *> *sourceFilesToImport;
- (id)initWithSourceFiles:(NSArray <NSURL *> *)filePaths;
@end

NS_ASSUME_NONNULL_END
