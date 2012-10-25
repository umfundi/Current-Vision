//
//  SalesExtModel.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "CustomerAggr.h"
#import "User.h"

@implementation CustomerAggr

@synthesize month, ytd, mat;
@synthesize monthString, ytdString, matString;

+ (CustomerAggr *)AggrFrom:(NSString *)customer
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SALES_REPORT_Customer_OrderBy"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_customer == %@", customer];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    CustomerAggr *aggr = [[CustomerAggr alloc] init];
    for (NSDictionary *report in reports)
    {
        aggr.month += [[report objectForKey:@"m0val"] doubleValue];
        aggr.ytd += [[report objectForKey:@"ytdvalcur"] doubleValue];
        aggr.mat += [[report objectForKey:@"matvalcur"] doubleValue];
    }
    
    [aggr finishAdd];
    
    return aggr;
}

- (void)finishAdd
{
    monthString = [NSString stringWithFormat:@"%.0f", round(month)];
    ytdString = [NSString stringWithFormat:@"%.0f", round(ytd)];
    matString = [NSString stringWithFormat:@"%.0f", round(mat)];
}

@end
