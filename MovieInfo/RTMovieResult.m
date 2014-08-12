//
//  RTMovieResult.m
//  MovieInfo
//
//  Created by shim on 2014-08-11.
//  Copyright (c) 2014 Bupkis. All rights reserved.
//

#import "RTMovieResult.h"
@interface RTMovieResult () {
    NSDictionary* movie;
}
@property (nonatomic,readonly) NSDictionary* ratings;
@end
@implementation RTMovieResult

-(id) initWithDictionary: (NSDictionary*) dictionary {
    if (self = [super init]) {
        movie = dictionary;
    }
    return self;
}

-(NSDictionary*) movieDic {
    return movie;
}
-(NSDictionary*) ratings {
    return movie[@"ratings"];
}
-(NSInteger) criticsScore {
    return [self.ratings[@"critics_score"] integerValue];
}


-(NSInteger) audienceScore {
    return [self.ratings[@"audience_score"] integerValue];
}


-(NSString*) criticsRating {
    return self.ratings[@"critics_rating"];
}

-(NSString*) audienceRating {
    return self.ratings[@"audience_rating"];
}

-(NSString*) name {
    return movie[@"title"];
}

-(NSInteger) year {
    return [movie[@"year"] integerValue];
}

-(NSInteger) runtime {
    return [movie[@"runtime"] integerValue];
}
-(NSString*) synopsis {
    return movie[@"synopsis"];
}
-(NSString*) posterThumbnailURL {
    return (movie[@"posters"])[@"thumbnail"];
}
-(NSArray*) abridgedCast {
    return movie[@"abridged_cast"];
}
-(NSString*) rtID {
    return movie[@"id"];
}
-(NSString*) mpaaRating {
    return movie[@"mpaa_rating"];
}
@end
