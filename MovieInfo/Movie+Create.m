//
//  Movie+Create.m
//  MovieInfo
//
//  Created by shim on 2014-08-11.
//  Copyright (c) 2014 Bupkis. All rights reserved.
//

#import "Movie+Create.h"
#import "RTMovieResult.h"
#import "EntityNames.h"
#import "CastMember.h"

NSString* const EntityMovie = @"Movie";
@implementation Movie (Create)

+(Movie*) movieWithResult: (RTMovieResult*) result inContext: (NSManagedObjectContext*) context {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:EntityMovie];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"rtID = %@",result.rtID];
    [request setPredicate:predicate];
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@:%@",NSStringFromClass(self.class),error);
    }
    
    else if (results.count > 0) {
        return results[0];
    }
    else {
        Movie* movie = [NSEntityDescription insertNewObjectForEntityForName:EntityMovie inManagedObjectContext:context];
        movie.title = result.name;
        movie.synopsis = result.synopsis;
        movie.criticsRating = result.criticsRating;
        movie.audienceRating = result.audienceRating;
        movie.criticsScore = [NSNumber numberWithInteger:result.criticsScore];
        movie.audienceScore = [NSNumber numberWithInteger:result.audienceScore];
        movie.runtime = [NSNumber numberWithInteger:result.runtime];
        movie.year = [NSNumber numberWithInteger:result.year];
        movie.mpaaRating = result.mpaaRating;
        movie.thumbnailURL = result.posterThumbnailURL;
        for (NSDictionary* cast in result.abridgedCast) {
            CastMember* castMember = [NSEntityDescription insertNewObjectForEntityForName:EntityCastMember inManagedObjectContext:context];
            castMember.name = cast[@"name"];
            castMember.characters = [(NSArray*)cast[@"characters"] componentsJoinedByString:@", "];
            castMember.movie = movie;
        }
        return movie;
    }
    return nil;
}

@end