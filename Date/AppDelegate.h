//
//  AppDelegate.h
//  Date
//
//  Created by maoyu on 12-11-10.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "PPRevealSideViewController.h"

@class RemindersInboxViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) PPRevealSideViewController * revealSideViewController;
@property (strong, nonatomic) UINavigationController * navController;
@property (strong, nonatomic) MenuViewController * menuViewController;
@property (strong, nonatomic) RemindersInboxViewController * homeViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(AppDelegate *)delegate;

- (void)checkRemindersExpired;

@end
