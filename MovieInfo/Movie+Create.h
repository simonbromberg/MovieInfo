//
//  Movie+Create.h
//  MovieInfo
//
//  Created by shim on 2014-08-11.
//  Copyright (c) 2014 Bupkis. All rights reserved.
//

#import "Movie.h"
extern NSString* const EntityMovie;
@class RTMovieResult;
@interface Movie (Create)
+(Movie*) movieWithResult: (RTMovieResult*) result inContext: (NSManagedObjectContext*) context;
@end
