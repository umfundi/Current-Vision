//
//  SitesDistributionAggrPerCustomer.m
//  Vision
//
//  Created by Jin on 11/1/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SitesDistributionAggrPerCustomer.h"

@implementation SitesDistributionAggrPerCustomer

@synthesize id_customer;
@synthesize customerName;
@synthesize prvTotal;
@synthesize prvTotalString;
@synthesize curTotal;
@synthesize curTotalString;
@synthesize growthString;

- (void)finishAdd
{
    prvTotalString = [NSString stringWithFormat:@"%.0f", prvTotal];
    curTotalString = [NSString stringWithFormat:@"%.0f", curTotal];
    if (prvTotal != 0)
        growthString = [NSString stringWithFormat:@"%.0f%%", (curTotal - prvTotal) / prvTotal * 100];
}

@end
