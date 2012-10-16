//
//  SitesDistributionAggrItem.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SitesDistributionAggrItem.h"

@implementation SitesDistributionAggrItem

@synthesize cursites;
@synthesize cursitesString;
@synthesize prvqtr;
@synthesize prvqtrString;
@synthesize curqtr;
@synthesize curqtrString;
@synthesize change;
@synthesize changeString;
@synthesize prvqtrAvg;
@synthesize curqtrAvg;

- (void)addSitesDistribution:(NSDictionary *)sitesDistribution
{
    cursites ++;
    prvqtr += [[sitesDistribution objectForKey:@"ytdvalprv"] doubleValue];
    curqtr += [[sitesDistribution objectForKey:@"ytdvalcur"] doubleValue];
}

- (void)finishAdd
{
    change = curqtr - prvqtr;
    cursitesString = [NSString stringWithFormat:@"%d", cursites];
    prvqtrString = [NSString stringWithFormat:@"%.0f", prvqtr];
    curqtrString = [NSString stringWithFormat:@"%.0f", curqtr];
    changeString = [NSString stringWithFormat:@"%.0f", change];
    prvqtrAvg = [NSString stringWithFormat:@"%.0f", prvqtr / cursites];
    curqtrAvg = [NSString stringWithFormat:@"%.0f", curqtr / cursites];
}

@end
