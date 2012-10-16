//
//  ErReportAggrPerBrand.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ErReportAggrPerBrand.h"

#import "User.h"
#import "ErReportAggrPerYear.h"

@implementation ErReportAggrPerBrand

@synthesize brand;
@synthesize aggrPerYears;

#warning ErReport Group By Brand
+ (NSArray *)ErReportGroupByBrandFrom:(NSString *)customer
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_customer == %@", customer];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *sales = [[NSMutableArray alloc] initWithCapacity:0];
    
    ErReportAggrPerBrand *aggrPerBrand = [[ErReportAggrPerBrand alloc] init];
    ErReportAggrPerYear *aggrPerYear = [[ErReportAggrPerYear alloc] init];
    for (NSDictionary *report in reports)
    {
        NSString *brand = [report objectForKey:@"brand"];
        NSString *year = @"2012";
        
        if (aggrPerBrand.brand == nil)
            aggrPerBrand.brand = brand;
        else if (![aggrPerBrand.brand isEqualToString:brand])
        {
            if (aggrPerYear.year)
            {
                [aggrPerYear finishAdd];
                [aggrPerBrand addAggrPerYear:aggrPerYear];
            }
            
            [sales addObject:aggrPerBrand];
            
            aggrPerBrand = [[ErReportAggrPerBrand alloc] init];
            aggrPerBrand.brand = brand;
        }
        
        if (aggrPerYear.year == nil)
            aggrPerYear.year = year;
        else if (![aggrPerYear.year isEqualToString:year])
        {
            [aggrPerYear finishAdd];
            [aggrPerBrand addAggrPerYear:aggrPerYear];
            
            aggrPerYear = [[ErReportAggrPerYear alloc] init];
            aggrPerYear.year = year;
        }
        
        [aggrPerYear addErReport:report];
    }
    
    if (aggrPerYear.year)
    {
        [aggrPerYear finishAdd];
        [aggrPerBrand addAggrPerYear:aggrPerYear];
    }
    
    if (aggrPerBrand.brand)
        [sales addObject:aggrPerBrand];
    
    return sales;
}

- (void)addAggrPerYear:(ErReportAggrPerYear *)aggrPerYear
{
    if (!aggrPerYears)
        aggrPerYears = [[NSMutableArray alloc] initWithCapacity:0];
    
    [aggrPerYears addObject:aggrPerYear];
}

@end
