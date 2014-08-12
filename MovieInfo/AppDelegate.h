//
//  AppDelegate.h
//  MovieInfo
//
//  Created by shim on 2014-08-10.
//  Copyright (c) 2014 Bupkis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define ApplicationDelegate ((AppDelegate *)[NSApplication sharedApplication].delegate)
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
