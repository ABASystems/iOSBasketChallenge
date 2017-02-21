//
//  AppDelegate.m
//  ABASBasketChallenge
//
//  Created by Sean O'Connor on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import "AppDelegate.h"

#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureStubs];
    // Override point for customization after application launch.
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
    
#pragma mark - Configuration Methods
    
- (void)configureStubs {
    static id<OHHTTPStubsDescriptor> textStub = nil;
    textStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [self isABARequest:request];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self responseForRequest:request];
    }];
}
    
#pragma mark - Mocking Methods
    
- (BOOL)isABARequest:(NSURLRequest *)request {
    return [request.URL.host rangeOfString:@"aba-systems.com.au"].location != NSNotFound;
}
    
- (OHHTTPStubsResponse *)responseForRequest:(NSURLRequest *)request {
    NSData *requestData = request.HTTPBody;
    NSError *error = nil;
    NSDictionary *requestJSON = [NSJSONSerialization JSONObjectWithData:requestData options:0 error:&error];
    
    NSMutableDictionary *responseJSON = [NSMutableDictionary new];
    int statusCode = 200;
    NSDictionary *headers = @{@"Content-Type":@"application/json"};
    
    if ([request.HTTPMethod isEqualToString:@"POST"] == NO) {
        statusCode = 405;
    }
    
    if ([[self endpointForRequest:request] isEqual:@"baskets/"]) {
        responseJSON = requestJSON.mutableCopy;
        [responseJSON setObject:[NSNumber numberWithInt:arc4random() % 99] forKey:@"id"];
    }
    else if ([[self endpointForRequest:request] isEqual:@"basketitems/"]) {
        if ([requestJSON[@"type"] isKindOfClass:[NSNumber class]] && [requestJSON[@"type"] integerValue] > 0) {
            responseJSON = requestJSON.mutableCopy;
            [responseJSON setObject:[NSNumber numberWithInt:arc4random() % 99] forKey:@"id"];
        } else {
            statusCode = 400;
        }
    }
    else if ([[self endpointForRequest:request] isEqual:@"basketitemtypes/"]) {
        responseJSON = requestJSON.mutableCopy;
        [responseJSON setObject:[NSNumber numberWithInt:arc4random() % 99] forKey:@"id"];
    } else {
        statusCode = 404;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:responseJSON
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    
    return [[OHHTTPStubsResponse responseWithData:data statusCode:statusCode headers:headers] requestTime:0.0f responseTime:OHHTTPStubsDownloadSpeedWifi];
}
    
- (NSString *)endpointForRequest:(NSURLRequest *)request {
    return [request.URL.absoluteString componentsSeparatedByString:@"https://aba-systems.com.au/api/v1/"].lastObject;
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ABASBasketChallenge"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
