//
//  SalesTrendAggr.m
//  Vision
//
//  Created by Jin on 11/6/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SalesTrendAggr.h"

#import "SalesTrendAggrPerBrand.h"
#import "User.h"
#import "Customer.h"
#import "umfundiCommon.h"

@implementation SalesTrendAggr

@synthesize monthArray;
@synthesize aggrPerBrands;

- (id)initWithYTDorMAT:(BOOL)isYTD
{
    self = [super init];
    if (self)
    {
        NSInteger currentMonth;
        if (isYTD)
            currentMonth = 1;
        else
            currentMonth = [[User loginUser] monthForData];
        
        monthArray = [NSArray arrayWithObjects:[umfundiCommon monthString:currentMonth],
                      [umfundiCommon monthString:currentMonth + 1],
                      [umfundiCommon monthString:currentMonth + 2],
                      [umfundiCommon monthString:currentMonth + 3],
                      [umfundiCommon monthString:currentMonth + 4],
                      [umfundiCommon monthString:currentMonth + 5],
                      [umfundiCommon monthString:currentMonth + 6],
                      [umfundiCommon monthString:currentMonth + 7],
                      [umfundiCommon monthString:currentMonth + 8],
                      [umfundiCommon monthString:currentMonth + 9],
                      [umfundiCommon monthString:currentMonth + 10],
                      [umfundiCommon monthString:currentMonth + 11], nil];
    }
    
    return self;
}

+ (SalesTrendAggr *)aggrFromAggrPerBrands:(NSArray *)aggrPerBrands YTDorMAT:(BOOL)isYTD
{
    SalesTrendAggr *aggr = [[SalesTrendAggr alloc] initWithYTDorMAT:isYTD];
    aggr.aggrPerBrands = aggrPerBrands;
    return aggr;
}


+ (SalesTrendAggr *)SalesTrendsGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SALES_REPORT_Customer_OrderBy"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"brand" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSString *format = [NSString stringWithFormat:@"%@ == %%@", aField];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format, aValue];
    [fetchRequest setPredicate:predicate];
    
    NSArray *trends = [context executeFetchRequest:fetchRequest error:nil];
    
    return [SalesTrendAggr aggrFromAggrPerBrands:[SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:trends YTDorMAT:isYTD] YTDorMAT:isYTD];
}

+ (SalesTrendAggr *)SalesTrendsGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD
{
    NSArray *filteredCustomers = [Customer searchCustomerIDsWithField:aField andValue:aValue];
    
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SALES_REPORT_Customer_OrderBy"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"brand" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_customer in %@", filteredCustomers];
    [fetchRequest setPredicate:predicate];
    
    NSArray *trends = [context executeFetchRequest:fetchRequest error:nil];
    
    return [SalesTrendAggr aggrFromAggrPerBrands:[SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:trends YTDorMAT:isYTD] YTDorMAT:isYTD];
}

+ (SalesTrendAggr *)yearReportsFrom:(NSArray *)monthReports YTDorMAT:(BOOL)isYTD
{
    NSMutableArray *reports = [[NSMutableArray alloc] initWithCapacity:monthReports.count];
    
    for (SalesTrendAggrPerBrand *aggr in monthReports)
        [reports addObject:[aggr convertToYearAggr]];
    
    SalesTrendAggr *aggr = [[SalesTrendAggr alloc] initWithYTDorMAT:isYTD];
    aggr.aggrPerBrands = reports;
    return aggr;
}

@end
