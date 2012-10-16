//
//  SalesExtModel.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "CustomerAggr.h"

#import "User.h"
#import "CustomerAggrPerBrand.h"

@implementation CustomerAggr

@synthesize month, ytd, mat;
@synthesize monthString, ytdString, matString;
@synthesize aggrPerBrands;

+ (CustomerAggr *)AggrFrom:(NSString *)customer
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
    
    CustomerAggr *aggr = [[CustomerAggr alloc] init];
    CustomerAggrPerBrand *aggrPerBrand = [[CustomerAggrPerBrand alloc] init];
    for (NSDictionary *report in reports)
    {
        NSString *brand = [report objectForKey:@"brand"];
        
        if (aggrPerBrand.brand == nil)
            aggrPerBrand.brand = brand;
        else if (![aggrPerBrand.brand isEqualToString:brand])
        {
            [aggrPerBrand finishAdd];
            [aggr addAggrPerBrand:aggrPerBrand];
            
            aggrPerBrand = [[CustomerAggrPerBrand alloc] init];
            aggrPerBrand.brand = brand;
        }
        
        [aggrPerBrand addSalesReport:report];
    }
    
    if (aggrPerBrand.brand)
    {
        [aggrPerBrand finishAdd];
        [aggr.aggrPerBrands addObject:aggrPerBrand];
    }
    
    [aggr finishAdd];
    
    return aggr;
}


- (void)addAggrPerBrand:(CustomerAggrPerBrand *)aggrPerBrand
{
    month += aggrPerBrand.month;
    ytd += aggrPerBrand.ytd;
    mat += aggrPerBrand.mat;
    
    if (!aggrPerBrands)
        aggrPerBrands = [[NSMutableArray alloc] initWithCapacity:0];
    
    [aggrPerBrands addObject:aggrPerBrand];
}

- (void)finishAdd
{
    monthString = [NSString stringWithFormat:@"%.0f", round(month)];
    ytdString = [NSString stringWithFormat:@"%.0f", round(ytd)];
    matString = [NSString stringWithFormat:@"%.0f", round(mat)];
}

@end
