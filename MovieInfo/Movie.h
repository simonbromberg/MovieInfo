//
//  Movie.h
//  MovieInfo
//
//  Created by shim on 2014-08-11.
//  Copyright (c) 2014 Bupkis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CastMember, File;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * audienceRating;
@property (nonatomic, retain) NSNumber * audienceScore;
@property (nonatomic, retain) NSString * criticsRating;
@property (nonatomic, retain) NSNumber * criticsScore;
@property (nonatomic, retain) NSString * mpaaRating;
@property (nonatomic, retain) NSString * rtID;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSString * synopsis;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSOrderedSet *cast;
@property (nonatomic, retain) File *file;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)insertObject:(CastMember *)value inCastAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCastAtIndex:(NSUInteger)idx;
- (void)insertCast:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCastAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCastAtIndex:(NSUInteger)idx withObject:(CastMember *)value;
- (void)replaceCastAtIndexes:(NSIndexSet *)indexes withCast:(NSArray *)values;
- (void)addCastObject:(CastMember *)value;
- (void)removeCastObject:(CastMember *)value;
- (void)addCast:(NSOrderedSet *)values;
- (void)removeCast:(NSOrderedSet *)values;
@end
