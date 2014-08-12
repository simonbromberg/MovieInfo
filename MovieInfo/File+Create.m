//
//  File+Create.m
//  MovieInfo
//
//  Created by shim on 2014-08-12.
//  Copyright (c) 2014 Bupkis. All rights reserved.
//

#import "File+Create.h"
NSString* const EntityFile = @"File";
@implementation File (Create)
+(File*) fileWithName: (NSString*) name inContext: (NSManagedObjectContext*) context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:EntityFile];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    [request setPredicate:predicate];
    NSError* error = nil;
    
    NSArray* results = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    if (results.count > 0) {
        return results[0];
    }
    else {
        File* file = [NSEntityDescription insertNewObjectForEntityForName:EntityFile inManagedObjectContext:context];
        file.name = name;
    }
    return nil;
}
@end
