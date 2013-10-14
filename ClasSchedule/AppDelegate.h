//
//  AppDelegate.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-2-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSDataCenter,DFControllerManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CSDataCenter* dataCenter;
	DFControllerManager* controllerManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
