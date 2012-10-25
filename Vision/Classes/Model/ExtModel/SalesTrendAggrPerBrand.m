//
//  SalesTrendAggrPerBrand.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SalesTrendAggrPerBrand.h"

#import "User.h"
#import "Customer.h"

@implementation SalesTrendAggrPerBrand

@synthesize brand;
@synthesize jan, janString;
@synthesize feb, febString;
@synthesize mar, marString;
@synthesize apr, aprString;
@synthesize may, mayString;
@synthesize jun, junString;
@synthesize jul, julString;
@synthesize aug, augString;
@synthesize sep, sepString;
@synthesize oct, octString;
@synthesize nov, novString;
@synthesize dec, decString;
@synthesize growthString;

+ (NSArray *)SalesTrendsGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YDTorMAT:(BOOL)isYTD
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
    
    NSMutableArray *aggrs = [[NSMutableArray alloc] initWithCapacity:0];
    SalesTrendAggrPerBrand *aggrPerBrand = [[SalesTrendAggrPerBrand alloc] init];
    for (NSDictionary *trend in trends)
    {
        NSString *brand = [trend objectForKey:@"brand"];
        
        if (aggrPerBrand.brand == nil)
            aggrPerBrand.brand = brand;
        else if (![aggrPerBrand.brand isEqualToString:brand])
        {
            [aggrPerBrand finishAdd];
            [aggrs addObject:aggrPerBrand];
            
            aggrPerBrand = [[SalesTrendAggrPerBrand alloc] init];
            aggrPerBrand.brand = brand;
        }
        
        [aggrPerBrand addSalesTrend:trend YDTorMAT:isYTD];
    }
    
    if (aggrPerBrand.brand)
    {
        [aggrPerBrand finishAdd];
        [aggrs addObject:aggrPerBrand];
    }
    
    return aggrs;
}

+ (NSArray *)SalesTrendsGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YDTorMAT:(BOOL)isYTD
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
    
    NSMutableArray *aggrs = [[NSMutableArray alloc] initWithCapacity:0];
    SalesTrendAggrPerBrand *aggrPerBrand = [[SalesTrendAggrPerBrand alloc] init];
    for (NSDictionary *trend in trends)
    {
        NSString *brand = [trend objectForKey:@"brand"];
        
        if (aggrPerBrand.brand == nil)
            aggrPerBrand.brand = brand;
        else if (![aggrPerBrand.brand isEqualToString:brand])
        {
            [aggrPerBrand finishAdd];
            [aggrs addObject:aggrPerBrand];
            
            aggrPerBrand = [[SalesTrendAggrPerBrand alloc] init];
            aggrPerBrand.brand = brand;
        }
        
        [aggrPerBrand addSalesTrend:trend YDTorMAT:isYTD];
    }
    
    if (aggrPerBrand.brand)
    {
        [aggrPerBrand finishAdd];
        [aggrs addObject:aggrPerBrand];
    }
    
    return aggrs;
}


+ (NSArray *)yearReportsFrom:(NSArray *)monthReports
{
    NSMutableArray *reports = [[NSMutableArray alloc] initWithCapacity:monthReports.count];
    
    for (SalesTrendAggrPerBrand *aggr in monthReports)
        [reports addObject:[aggr convertToYearAggr]];
    
    return reports;
}


- (void)addSalesTrend:(NSDictionary *)trend YDTorMAT:(BOOL)isYTD
{
    if (isYTD)
    {
        jan += [[trend objectForKey:@"janval"] doubleValue];
        feb += [[trend objectForKey:@"febval"] doubleValue];
        mar += [[trend objectForKey:@"marval"] doubleValue];
        apr += [[trend objectForKey:@"aprval"] doubleValue];
        may += [[trend objectForKey:@"mayval"] doubleValue];
        jun += [[trend objectForKey:@"junval"] doubleValue];
        jul += [[trend objectForKey:@"julval"] doubleValue];
        aug += [[trend objectForKey:@"augval"] doubleValue];
        sep += [[trend objectForKey:@"sepval"] doubleValue];
        oct += [[trend objectForKey:@"octval"] doubleValue];
        nov += [[trend objectForKey:@"novval"] doubleValue];
        dec += [[trend objectForKey:@"decval"] doubleValue];
    }
    else
    {
        jan += [[trend objectForKey:@"m_11val"] doubleValue];
        feb += [[trend objectForKey:@"m_10val"] doubleValue];
        mar += [[trend objectForKey:@"m_9val"] doubleValue];
        apr += [[trend objectForKey:@"m_8val"] doubleValue];
        may += [[trend objectForKey:@"m_7val"] doubleValue];
        jun += [[trend objectForKey:@"m_6val"] doubleValue];
        jul += [[trend objectForKey:@"m_5val"] doubleValue];
        aug += [[trend objectForKey:@"m_4val"] doubleValue];
        sep += [[trend objectForKey:@"m_3val"] doubleValue];
        oct += [[trend objectForKey:@"m_2val"] doubleValue];
        nov += [[trend objectForKey:@"m_1val"] doubleValue];
        dec += [[trend objectForKey:@"m0val"] doubleValue];
    }
}

- (void)finishAdd
{
    janString = [NSString stringWithFormat:@"%.0f", round(jan)];
    febString = [NSString stringWithFormat:@"%.0f", round(feb)];
    marString = [NSString stringWithFormat:@"%.0f", round(mar)];
    aprString = [NSString stringWithFormat:@"%.0f", round(apr)];
    mayString = [NSString stringWithFormat:@"%.0f", round(may)];
    junString = [NSString stringWithFormat:@"%.0f", round(jun)];
    julString = [NSString stringWithFormat:@"%.0f", round(jul)];
    augString = [NSString stringWithFormat:@"%.0f", round(aug)];
    sepString = [NSString stringWithFormat:@"%.0f", round(sep)];
    octString = [NSString stringWithFormat:@"%.0f", round(oct)];
    novString = [NSString stringWithFormat:@"%.0f", round(nov)];
    decString = [NSString stringWithFormat:@"%.0f", round(dec)];
#warning growth in SalesTrend
    growthString = [NSString stringWithFormat:@"%.0f%%", round(0)];
}

- (SalesTrendAggrPerBrand *)convertToYearAggr
{
    SalesTrendAggrPerBrand *yearAggr = [[SalesTrendAggrPerBrand alloc] init];
    
    yearAggr.brand = brand;
    yearAggr.jan = jan;
    yearAggr.feb = yearAggr.jan + feb;
    yearAggr.mar = yearAggr.feb + mar;
    yearAggr.apr = yearAggr.mar + apr;
    yearAggr.may = yearAggr.apr + may;
    yearAggr.jun = yearAggr.may + jun;
    yearAggr.jul = yearAggr.jun + jul;
    yearAggr.aug = yearAggr.jul + aug;
    yearAggr.sep = yearAggr.aug + sep;
    yearAggr.oct = yearAggr.sep + oct;
    yearAggr.nov = yearAggr.oct + nov;
    yearAggr.dec = yearAggr.nov + dec;
    [yearAggr finishAdd];
    
    return yearAggr;
}

@end
