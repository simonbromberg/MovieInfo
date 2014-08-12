//
//  File.h
//  MovieInfo
//
//  Created by shim on 2014-08-11.
//  Copyright (c) 2014 Bupkis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface File : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Movie *movie;

@end
