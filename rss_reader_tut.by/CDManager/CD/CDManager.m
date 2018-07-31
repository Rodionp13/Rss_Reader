//
//  CDManager.m
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "CDManager.h"
#import "Channel.h"
#import "Article.h"

static NSString *const kHeaders = @"headers";
static NSString *const kChannels = @"channels";
static NSString *const kFreshNews = @"freshNews";

@interface CDManager()
@property(strong, nonatomic) NSManagedObjectContext *context;
@property(strong, nonatomic) APPManager *appManager;

@end

@implementation CDManager

- (NSManagedObjectContext *)context {
    if(_context != nil) {
        return _context;
    }
    return [[(AppDelegate*)[UIApplication sharedApplication].delegate persistentContainer] viewContext];
}

- (APPManager*)appManager {
    if(_appManager != nil) {
        return _appManager;
    }
    APPManager *appManager = [[APPManager alloc] init];
    _appManager = appManager;
    return _appManager;
}

- (NSArray *)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate andDescriptor:(nullable NSArray<NSSortDescriptor*>*)sortDescriptors {
    NSFetchRequest *request = [ChannelMO fetchRequest];
    [request setReturnsObjectsAsFaults:NO];
    [request setPredicate:predicate];
    [request setSortDescriptors:sortDescriptors];
    
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

- (void)addNewRecordsToDB:(NSDictionary *)channelsAndHeaders {
//    NSArray *channelGroups = [[channelsData valueForKey:kChannels] copy];
    NSArray *headers = [channelsAndHeaders valueForKey:kHeaders];
    NSArray *channelGroups = [channelsAndHeaders valueForKey:kChannels];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    for(int i = 0; i < channelGroups.count; i++) {
        NSArray *channels = channelGroups[i];
        for(int j = 0; j < channels.count; j++) {
            
            NSEntityDescription *entityDescr = [NSEntityDescription entityForName:kChannelEnt inManagedObjectContext:self.context];
            ChannelMO *newChannelMO = [[ChannelMO alloc] initWithEntity:entityDescr insertIntoManagedObjectContext:self.context];
            id channel = [channels objectAtIndex:j];
            NSString *name = [channel name];
            NSString *url = [channel url];
            NSString *channelGroup = headers[i];
            
            newChannelMO.name = name;
            newChannelMO.url = url;
            newChannelMO.channelGroup = channelGroup;
            [appDelegate saveContext];
        }
    }
    //check after parsing
//    NSError *err;
//    NSArray *result = [self.context executeFetchRequest:[ChannelMO fetchRequest] error:&err];
//    if(err != nil) {
//        NSLog(@"Fail((");
//    } else {
//        NSLog(@"RESULT FROM CD == %lu", result.count);
//        for(ChannelMO *channel in result) {
//            NSLog(@"%@", channel.name);
//        }
//    }
}

- (NSDictionary *)parseMOinToObjects:(NSArray*)managedObjects {
    NSMutableOrderedSet *headers = [NSMutableOrderedSet orderedSet];
    NSMutableArray *gorupOfChannels = [NSMutableArray array];
    NSMutableArray *subChannels = [NSMutableArray array];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kChannelGroup ascending:YES];
    NSArray *channelsSortedByGroup = [self loadDataFromDBWithPredicate:nil andDescriptor:@[descriptor]];
    NSLog(@"%lu,%@", channelsSortedByGroup.count, channelsSortedByGroup);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        
    for(int i = 0; i < channelsSortedByGroup.count; i++) {
        NSString *sortedChannelGroupProperty = [[channelsSortedByGroup objectAtIndex:i] channelGroup];
        NSString *secondSortedChannelGroupProperty;
        [headers addObject:sortedChannelGroupProperty];
        
        if((i+1) != channelsSortedByGroup.count) {
        secondSortedChannelGroupProperty = [[channelsSortedByGroup objectAtIndex:i + 1] channelGroup];
        } else {
            secondSortedChannelGroupProperty = [[channelsSortedByGroup objectAtIndex:i] channelGroup];
        }
        Channel *newChannel = [self convertMOinToObj:[channelsSortedByGroup objectAtIndex:i]];
        [subChannels addObject:newChannel];
        if(![sortedChannelGroupProperty isEqualToString:secondSortedChannelGroupProperty]) {
            [gorupOfChannels addObject:[subChannels copy]];
            [subChannels removeAllObjects];
        } else if((i+1) == channelsSortedByGroup.count) {
            [gorupOfChannels addObject:[subChannels copy]];
            [subChannels removeAllObjects];
        }
    }
    });
//    NSLog(@"%lu, %@", headers.count,headers);
//    NSArray *arr = [gorupOfChannels objectAtIndex:0];
//    NSLog(@"%@", [[arr objectAtIndex:0] name]);
//    NSLog(@"");
//    NSLog(@"");
    
    return @{kHeaders:headers,kChannels:gorupOfChannels};
}


- (Channel*)convertMOinToObj:(NSManagedObject*)managedObj {
    ChannelMO *channelMO = (ChannelMO*)managedObj;
    Channel *channel = [[Channel alloc] initWithName:channelMO.name url:channelMO.url];
    return channel;
}




@end
