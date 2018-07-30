//
//  CDManager.m
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "CDManager.h"

@interface CDManager()
@property(strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation CDManager

- (NSManagedObjectContext *)context {
    if(_context != nil) {
        return _context;
    }
    return [[(AppDelegate*)[UIApplication sharedApplication].delegate persistentContainer] viewContext];
}

- (NSArray *)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate {
    NSFetchRequest *request = [ChannelMO fetchRequest];
    [request setReturnsObjectsAsFaults:NO];
    [request setPredicate:predicate];
    
    NSError *err;
    NSArray *result;
        result = [self.context executeFetchRequest:request error:&err];
        if(err != nil) {
            NSLog(@"1.Failed to load data from CD with predicate\n%@\n%@", err, [err localizedDescription]);
        } else {
            NSLog(@"1.Success load data from CD with predicate, element count=%lu\n%@", [result count], [result description]);
        }
    return result;
}

- (void)addNewRecordsToDB:(NSArray *)newRecords {
    
}



@end
