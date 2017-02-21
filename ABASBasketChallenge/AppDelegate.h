//
//  AppDelegate.h
//  ABASBasketChallenge
//
//  Created by Sean O'Connor on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

