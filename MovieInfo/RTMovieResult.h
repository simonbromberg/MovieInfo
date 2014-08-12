//
//  RTMovieResult.h
//  MovieInfo
//
//  Created by shim on 2014-08-11.
//  Copyright (c) 2014 Bupkis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTMovieResult : NSObject
-(id) initWithDictionary: (NSDictionary*) dictionary;

@property (nonatomic,readonly) NSDictionary* movieDic;
@property (nonatomic,readonly) NSInteger criticsScore;
@property (nonatomic,readonly) NSInteger audienceScore;
@property (nonatomic,readonly) NSString* criticsRating;
@property (nonatomic,readonly) NSString* audienceRating;
@property (nonatomic,readonly) NSString* name;
@property (nonatomic,readonly) NSInteger year;
@property (nonatomic,readonly) NSInteger runtime;
@property (nonatomic,readonly) NSString* synopsis;
@property (nonatomic,readonly) NSString* posterThumbnailURL;
@property (nonatomic,readonly) NSArray* abridgedCast;
@property (nonatomic,readonly) NSString* rtID;
@property (nonatomic,readonly) NSString* mpaaRating;

@end
