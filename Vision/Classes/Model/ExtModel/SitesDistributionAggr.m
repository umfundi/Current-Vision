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

#warning Sites Distribution Filtered by Brands
+ (SitesDistributionAggr *)AggrFilteredByBrands:(NSArray *)brands
{
    NSMutableArray *brandNames = [[NSMutableArray alloc] initWithCapacity:brands.count];
    for (Focused_brand *brand in brands)
        [brandNames addObject:brand.brand_name];
    
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SALES_REPORT_Customer_OrderBy"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand IN %@", brandNames];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    SitesDistributionAggr *aggr = [[SitesDistributionAggr alloc] init];
    aggr.retainedItem = [[SitesDistributionAggrItem alloc] init];
    aggr.gainedItem = [[SitesDistributionAggrItem alloc] init];
    aggr.lostItem = [[SitesDistributionAggrItem alloc] init];
    
    for (NSDictionary *report in reports)
    {
        [aggr.retainedItem addSitesDistribution:report];
        [aggr.gainedItem addSitesDistribution:report];
        [aggr.lostItem addSitesDistribution:report];
    }
    
    [aggr.retainedItem finishAdd];
    [aggr.gainedItem finishAdd];
    [aggr.lostItem finishAdd];

    [aggr finishAdd];
    
    return aggr;
}

#warning Sites Distribution Filtered by Products
+ (SitesDistributionAggr *)AggrFilteredByProducts:(NSArray *)products
{
    NSMutableArray *brandNames = [[NSMutableArray alloc] initWithCapacity:products.count];
    for (Product *product in products)
        [brandNames addObject:product.brand];
    
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SALES_REPORT_Customer_OrderBy"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand IN %@", brandNames];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    SitesDistributionAggr *aggr = [[SitesDistributionAggr alloc] init];
    aggr.retainedItem = [[SitesDistributionAggrItem alloc] init];
    aggr.gainedItem = [[SitesDistributionAggrItem alloc] init];
    aggr.lostItem = [[SitesDistributionAggrItem alloc] init];
    
    for (NSDictionary *report in reports)
    {
        [aggr.retainedItem addSitesDistribution:report];
        [aggr.gainedItem addSitesDistribution:report];
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
    
    totalItem.cursites = retainedItem.cursites + gainedItem.cursites + lostItem.cursites;
    totalItem.prvqtr = retainedItem.prvqtr + gainedItem.prvqtr + lostItem.prvqtr;
    totalItem.curqtr = retainedItem.curqtr + gainedItem.curqtr + lostItem.curqtr;
    totalItem.change = retainedItem.change + gainedItem.change + lostItem.change;
    
    [totalItem finishAdd];
    totalItem.prvqtrAvg = @"";
    totalItem.curqtrAvg = @"";
}

@end
