//
//  ZBRefreshableTableViewController.m
//  Zebra
//
//  Created by Thatchapon Unprasert on 17/6/2019
//  Copyright © 2019 Wilson Styres. All rights reserved.
//

#import "ZBRefreshableTableViewController.h"
#import <ZBAppDelegate.h>
#import <ZBTabBarController.h>
#import <UIColor+GlobalColors.h>
#import <Database/ZBDatabaseManager.h>
#import <Sources/Helpers/ZBSource.h>
#import <Packages/Controllers/ZBPackageListTableViewController.h>
#import <ZBDevice.h>

@interface ZBRefreshableTableViewController () {
    UIRefreshControl *refreshControl;
}
@end

@implementation ZBRefreshableTableViewController

@synthesize databaseManager;

+ (BOOL)supportRefresh {
    return YES;
}

- (void)cancelRefresh:(id)sender {
    [databaseManager cancelUpdates:self];
    [[ZBAppDelegate tabBarController] clearRepos];
    if (self.refreshControl.refreshing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self didEndRefreshing];
//            [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    databaseManager = [ZBDatabaseManager sharedInstance];
    [self layoutNavigationButtons];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutNavigationButtons) name:@"ZBUpdateNavigationButtons" object:nil];
    
//    if (self.refreshControl) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([ZBDevice darkModeEnabled]) {
//                [self.refreshControl setTintColor:[UIColor whiteColor]];
//            }
//            else {
//                [self.refreshControl setTintColor:[UIColor blackColor]];
//            }
//        });
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = [UIColor tableViewBackgroundColor];
    self.tableView.separatorColor = [UIColor cellSeparatorColor];
    self.navigationController.navigationBar.tintColor = [UIColor accentColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    [refreshControl endRefreshing];
    
    if ([[self class] supportRefresh] && refreshControl == nil) {
        [databaseManager addDatabaseDelegate:self];
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshSources:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
    }
//    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self updateRefreshView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

- (BOOL)updateRefreshView {
    if (self.refreshControl) {
        if ([databaseManager isDatabaseBeingUpdated]) {
            if (!self.refreshControl.refreshing) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    if ([ZBDevice darkModeEnabled]) {
//                        [self.refreshControl setTintColor:[UIColor whiteColor]];
//                    }
//                    else {
//                        [self.refreshControl setTintColor:[UIColor blackColor]];
//                    }
                    
                    [self.refreshControl beginRefreshing];
                    [self didEndRefreshing];
//                    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl.frame.size.height) animated:YES];
                });
            }
            [self layoutNavigationButtonsRefreshing];
            return YES;
        }
    }
    [self layoutNavigationButtonsNormal];
    return NO;
}

- (void)layoutNavigationButtonsRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelRefresh:)];
        self.navigationItem.leftBarButtonItems = @[cancelButton];
    });
}

- (void)layoutNavigationButtonsNormal {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.leftBarButtonItems = @[];
    });
}

- (void)layoutNavigationButtons {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshControl.refreshing) {
            [self layoutNavigationButtonsRefreshing];
        } else {
            [self layoutNavigationButtonsNormal];
        }
    });
}

- (void)setRepoRefreshIndicatorVisible:(BOOL)visible {
    if (![[self class] supportRefresh]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [(ZBTabBarController *)self.tabBarController setRepoRefreshIndicatorVisible:visible];
    });
}

- (void)refreshSources:(id)sender {
    if (![[self class] supportRefresh] || [self updateRefreshView]) {
        return;
    }
    [self setEditing:NO animated:NO];
    [self setRepoRefreshIndicatorVisible:YES];
    BOOL singleRepo = NO;
    if ([self respondsToSelector:@selector(repo)]) {
        ZBSource *repo = [(ZBPackageListTableViewController *)self repo];
        if ([repo repoID] > 0) {
            //FIXME: fix me!
//            [databaseManager updateRepo:repo useCaching:YES];
            singleRepo = YES;
        }
    }
    if (!singleRepo) {
        [databaseManager updateDatabaseUsingCaching:YES userRequested:YES];
    }
    [self updateRefreshView];
}

- (void)didEndRefreshing {
    [self layoutNavigationButtons];
}

- (void)databaseCompletedUpdate:(int)packageUpdates {
    if (![[self class] supportRefresh]) {
        return;
    }
    [self setRepoRefreshIndicatorVisible:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (packageUpdates != -1) {
            [(ZBTabBarController *)self.tabBarController setPackageUpdateBadgeValue:packageUpdates];
        }
        [self->refreshControl endRefreshing];
        [self didEndRefreshing];
//        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    });
}

- (void)databaseStartedUpdate {
    if (![[self class] supportRefresh]) {
        return;
    }
    [self setRepoRefreshIndicatorVisible:YES];
    [self layoutNavigationButtons];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

@end
