//
//  File+Create.h
//  MovieInfo
//
//  Created by shim on 2014-08-12.
//  Copyright (c) 2014 Bupkis. All rights reserved.
//

#import "File.h"

@interface File (Create)
+(File*) fileWithName: (NSString*) name inContext: (NSManagedObjectContext*) context;
@end
