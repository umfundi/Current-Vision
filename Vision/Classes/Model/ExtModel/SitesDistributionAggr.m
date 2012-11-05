//
//  SitesDistributionAggr.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SitesDistributionAggr.h"

#import "SitesDistributionAggrItem.h"
#import "Focused_brand.h"
#import "Product.h"
#import "User.h"

@implementation SitesDistributionAggr

@synthesize retainedItem;
@synthesize gainedItem;
@synthesize lostItem;
@synthesize totalItem;

+ (SitesDistributionAggr *)AggrFilteredByBrands:(NSArray *)brands period:(SitesDistributionPeriod)period
{
    NSMutableArray *brandNames = [[NSMutableArray alloc] initWithCapacity:brands.count];
    for (Focused_brand *brand in brands)
        [brandNames addObject:brand.brand_name];
    
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSString *table;
    switch (period)
    {
        case PrevYear:
            table = @"SALES_REPORT_CustomerDistribution_detail_LY";
            break;
        case CurYear:
            table = @"SALES_REPORT_CustomerDistribution_detail";
            break;
        case YTD:
            table = @"SALES_REPORT_CustomerDistribution_detail_YTD";
            break;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:table
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(brand IN %@) AND (plevel == %@)",
                              brandNames, @"brand"];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    SitesDistributionAggr *aggr = [[SitesDistributionAggr alloc] init];
    aggr.retainedItem = [[SitesDistributionAggrItem alloc] init];
    aggr.retainedItem.type = Retained;
    aggr.gainedItem = [[SitesDistributionAggrItem alloc] init];
    aggr.gainedItem.type = Gained;
    aggr.lostItem = [[SitesDistributionAggrItem alloc] init];
    aggr.lostItem.type = Lost;
    
    for (NSDictionary *report in reports)
    {
        NSString *ctype = [report objectForKey:@"ctype"];
        
        if ([ctype isEqualToString:@"retained"])
            [aggr.retainedItem addSitesDistribution:report];
        else if ([ctype isEqualToString:@"gained"])
            [aggr.gainedItem addSitesDistribution:report];
        else if ([ctype isEqualToString:@"lost"])
            [aggr.lostItem addSitesDistribution:report];
    }
    
    [aggr.retainedItem finishAdd];
    [aggr.gainedItem finishAdd];
    [aggr.lostItem finishAdd];

    [aggr finishAdd];
    
    return aggr;
}

+ (SitesDistributionAggr *)AggrFilteredByProducts:(NSArray *)products period:(SitesDistributionPeriod)period
{
    NSMutableArray *productNames = [[NSMutableArray alloc] initWithCapacity:products.count];
    for (Product *product in products)
        [productNames addObject:product.pname];
    
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSString *table;
    switch (period)
    {
        case PrevYear:
            table = @"SALES_REPORT_CustomerDistribution_detail_LY";
            break;
        case CurYear:
            table = @"SALES_REPORT_CustomerDistribution_detail";
            break;
        case YTD:
            table = @"SALES_REPORT_CustomerDistribution_detail_YTD";
            break;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:table
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(pname IN %@) AND (plevel == %@)",
                              productNames, @"product"];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    SitesDistributionAggr *aggr = [[SitesDistributionAggr alloc] init];
    aggr.retainedItem = [[SitesDistributionAggrItem alloc] init];
    aggr.retainedItem.type = Retained;
    aggr.gainedItem = [[SitesDistributionAggrItem alloc] init];
    aggr.gainedItem.type = Gained;
    aggr.lostItem = [[SitesDistributionAggrItem alloc] init];
    aggr.lostItem.type = Lost;
    
    for (NSDictionary *report in reports)
    {
        NSString *ctype = [report objectForKey:@"ctype"];
        
        if ([ctype isEqualToString:@"retained"])
            [aggr.retainedItem addSitesDistribution:report];
        else if ([ctype isEqualToString:@"gained"])
            [aggr.gainedItem addSitesDistribution:report];
        else if ([ctype isEqualToString:@"lost"])
            [aggr.lostItem addSitesDistribution:report];
    }
    
    [aggr.retainedItem finishAdd];
    [aggr.gainedItem finishAdd];
    [aggr.lostItem finishAdd];
    
    [aggr finishAdd];
    
    return aggr;
}


- (void)finishAdd
{
    totalItem = [[SitesDistributionAggrItem alloc] init];
    
    totalItem.prvqtr = retainedItem.prvqtr + gainedItem.prvqtr + lostItem.prvqtr;
    totalItem.curqtr = retainedItem.curqtr + gainedItem.curqtr + lostItem.curqtr;
    totalItem.change = retainedItem.change + gainedItem.change + lostItem.change;
    
    [totalItem finishAdd];
    totalItem.cursitesString = [NSString stringWithFormat:@"%d", [retainedItem.aggrPerCustomerArray count] + [gainedItem.aggrPerCustomerArray count] + [lostItem.aggrPerCustomerArray count]];
    totalItem.prvqtrAvg = @"";
    totalItem.curqtrAvg = @"";
}

@end
