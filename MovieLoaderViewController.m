//
//  MovieLoaderViewController.m
//  MovieInfo
//
//  Created by shim on 2014-08-10.
//  Copyright (c) 2014 Bupkis. All rights reserved.
//

#import "MovieLoaderViewController.h"
#import "AFNetworking.h"
#import "RTMovieResult.h"
#import "Movie+Create.h"
#import "File+Create.h"
#import "AppDelegate.h"

@import CoreData;

static NSString* const SearchMovieURL = @"http://api.rottentomatoes.com/api/public/v1.0/movies.json";
static NSString* const RTKey = @"j6e4dtu4hmu3v42qtgrm67k9";

static NSString* const DefaultFolderKey = @"DefaultFolder";
@interface MovieLoaderViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (nonatomic,strong) NSArray* fileNames;
@property (nonatomic,strong) NSMutableArray* movieResults;
@property (nonatomic,weak) IBOutlet NSTableView* tableView;
@property (nonatomic,weak) IBOutlet NSTextField* titleLabel;
@property (nonatomic,weak) IBOutlet NSTextField* criticsScoreLabel;
@property (nonatomic,weak) IBOutlet NSTextField* audienceScoreLabel;
@property (nonatomic,weak) IBOutlet NSTextField* criticsRatingLabel;
@property (nonatomic,weak) IBOutlet NSTextField* audienceRatingLabel;
@property (nonatomic,weak) IBOutlet NSTextField* synposis;
@property (nonatomic,weak) IBOutlet NSImageView* thumbnail;
@property (nonatomic,copy) NSURL* folderPath;

@end

@implementation MovieLoaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSURL* url = [[NSUserDefaults standardUserDefaults] URLForKey:DefaultFolderKey];
        if (url) {
            self.folderPath = url;
        }
    }
    return self;
}

-(void) loadView {
    [super loadView];
    if (self.folderPath) {
        [self loadMoviesAtFolder:self.folderPath];
    }
}
-(IBAction) loadMovies: (id) sender {
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:YES];
    [openDlg setPrompt:@"Select"];
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg URLs];
        NSURL* fileName = [files objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setURL:fileName forKey:DefaultFolderKey];
        self.folderPath = fileName;
        [self loadMoviesAtFolder: fileName];
    }
}

-(void) loadMoviesAtFolder: (NSURL*) fileName {
    NSError* error = nil;
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:fileName includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    NSMutableArray* temp = [NSMutableArray arrayWithCapacity:fileList.count];
    for (NSURL* url in fileList) {
        error = nil;
        NSNumber* isDirectory = nil;
        
        if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            NSLog(@"%@",error);
        }
        else if (![isDirectory boolValue]) {
            if (![url.pathExtension isEqualToString:@"srt"]) {
                [temp addObject:[[[NSFileManager defaultManager] displayNameAtPath:url.path] stringByDeletingPathExtension]];
            }
            else {
                NSLog(@"srt found");
            }
        }
    }
    self.fileNames = temp;
    
    self.movieResults = [NSMutableArray arrayWithCapacity:self.fileNames.count];
    for (NSInteger i = 0; i < self.fileNames.count; i++) {
        [self.movieResults addObject:[NSNull null]];
    }
    
    NSManagedObjectContext* context = ApplicationDelegate.managedObjectContext;
    for (NSInteger i = 0; i < self.movieResults.count; i++) {
        NSString* movieName = self.fileNames[i];
        File* file = [File fileWithName:movieName inContext:context];
        if (file.movie) {
            NSLog(@"found movie %@",file.name);
            [self.movieResults replaceObjectAtIndex:i withObject:file.movie];
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self searchMovie:movieName completion:^(NSArray *results) {
                    if (results == nil || results.count == 0) {
                        return;
                    }
                    NSDictionary* firstResult = results[0];
                    RTMovieResult* rtMovie = [[RTMovieResult alloc] initWithDictionary:firstResult];
                    Movie* movie = [Movie movieWithResult:rtMovie inContext:context];
                    movie.file = file;
                    [self.movieResults replaceObjectAtIndex:i withObject:movie];
                    NSIndexSet* rowSet = [NSIndexSet indexSetWithIndex:i];
                    NSIndexSet* colSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)];
                    [self.tableView reloadDataForRowIndexes:rowSet columnIndexes:colSet];
                }];
            });
        }
        error = nil;
        [context save:&error];
        if (error) {
            NSLog(@"Error %@: %@",NSStringFromClass(self.class),error);
        }
        [self.tableView reloadData];
    }
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    if ([tableColumn.identifier isEqualToString:@"Movies"]) {
        cellView.textField.stringValue = self.fileNames[row];
        return cellView;
    }
    
    if ([tableColumn.identifier isEqualToString:@"Score"]) {
        if (self.movieResults[row] != [NSNull null]) {
            NSInteger score = [((Movie*) self.movieResults[row]).criticsScore integerValue];
            cellView.textField.stringValue = [NSString stringWithFormat:@"%ld",score];
        }
        return cellView;
    }
    
    if ([tableColumn.identifier isEqualToString:@"Year"]) {
        if (self.movieResults[row] != [NSNull null]) {
            NSInteger year = [((Movie*) self.movieResults[row]).year integerValue];
            cellView.textField.stringValue = [NSString stringWithFormat:@"%ld",year];
        }
        return cellView;
    }
    return cellView;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.fileNames.count;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSInteger selectedRow = [self.tableView selectedRow];
    
    if (selectedRow >= 0 && self.fileNames.count > selectedRow) {
        Movie* movie = self.movieResults[selectedRow];
        if (movie == (id)[NSNull null]) return;
        self.titleLabel.stringValue = movie.title;
        self.criticsRatingLabel.stringValue = movie.criticsRating;
        self.criticsScoreLabel.stringValue = [NSString stringWithFormat:@"%ld",[movie.criticsScore integerValue]];
        self.audienceRatingLabel.stringValue = movie.audienceRating;
        self.audienceScoreLabel.stringValue = [NSString stringWithFormat:@"%ld",[movie.audienceScore integerValue]];
        self.synposis.stringValue = movie.synopsis;
        
        NSImage* image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:movie.thumbnailURL]];
        self.thumbnail.image = image;
        
    }
}

-(void) searchMovie: (NSString*) name completion: (void (^)(NSArray* results))completion {
    NSString* urlFriendlyName = [name stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    urlFriendlyName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)urlFriendlyName,NULL,(CFStringRef)@"!*'();:@&=$,/?%#[]", kCFStringEncodingUTF8));
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString* requestURL = [NSString stringWithFormat:@"%@?q=%@&page_limit=%d&page=%d&apikey=%@",SearchMovieURL,urlFriendlyName,2,1,RTKey];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* results = responseObject[@"movies"];
        if (completion) {
            completion(results);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        if (completion) {
            completion(nil);
        }
    }];
}

@end
