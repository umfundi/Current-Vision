//
//  SitesDistributionAggrItem.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SitesDistributionAggrItem.h"
#import "SitesDistributionAggrPerCustomer.h"
#import "Customer.h"

@implementation SitesDistributionAggrItem

@synthesize cursitesString;
@synthesize prvqtr;
@synthesize prvqtrString;
@synthesize curqtr;
@synthesize curqtrString;
@synthesize change;
@synthesize changeString;
@synthesize prvqtrAvg;
@synthesize curqtrAvg;

@synthesize aggrPerCustomerArray;
@synthesize count;
@synthesize type;

- (id)init
{
    self = [super init];
    if (self)
    {
        aggrPerCustomerArray = [[NSMutableArray alloc] initWithCapacity:0];
        count = 0;
    }
    
    return self;
}

- (void)addSitesDistribution:(NSDictionary *)sitesDistribution
{
    NSString *id_customer = [sitesDistribution objectForKey:@"id_customer"];
    
    SitesDistributionAggrPerCustomer *aggrPerCustomer;
    for (aggrPerCustomer in aggrPerCustomerArray)
    {
        if ([id_customer isEqualToString:aggrPerCustomer.id_customer])
            break;
    }
    
    if (!aggrPerCustomer)
    {
        aggrPerCustomer = [[SitesDistributionAggrPerCustomer alloc] init];
        aggrPerCustomer.id_customer = id_customer;
        aggrPerCustomer.customerName = [Customer CustomerNameFromID:id_customer];
        
        [aggrPerCustomerArray addObject:aggrPerCustomer];
    }
    
    double pvalprv = [[sitesDistribution objectForKey:@"pvalprv"] doubleValue];
    double pvalcur = [[sitesDistribution objectForKey:@"pvalcur"] doubleValue];
    
    count ++;
    prvqtr += pvalprv;
    curqtr += pvalcur;
    aggrPerCustomer.prvTotal += pvalprv;
    aggrPerCustomer.curTotal += pvalcur;
}

- (void)finishAdd
{
    change = curqtr - prvqtr;
    cursitesString = [NSString stringWithFormat:@"%d", [aggrPerCustomerArray count]];
    prvqtrString = [NSString stringWithFormat:@"%.0f", prvqtr];
    curqtrString = [NSString stringWithFormat:@"%.0f", curqtr];
    changeString = [NSString stringWithFormat:@"%.0f", change];
    prvqtrAvg = [NSString stringWithFormat:@"%.0f", prvqtr / count];
    curqtrAvg = [NSString stringWithFormat:@"%.0f", curqtr / count];
    
    for (SitesDistributionAggrPerCustomer *aggrPerCustomer in aggrPerCustomerArray)
        [aggrPerCustomer finishAdd];
}

@end
