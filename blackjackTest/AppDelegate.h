//
//  AppDelegate.h
//  blackjackTest
//
//  Created by Fabio Acri on 12/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSPersistentContainer *persistentContainer;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;


@end

