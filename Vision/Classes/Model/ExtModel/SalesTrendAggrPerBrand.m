//
//  SalesTrendAggrPerBrand.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SalesTrendAggrPerBrand.h"

#import "User.h"

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

+ (NSArray *)SalesTrendsGroupByBrandFrom:(NSString *)customer
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SALES_REPORT_CustomerSalesTrends"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"brand" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_customer == %@", customer];
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
        
        [aggrPerBrand addSalesTrend:trend];
    }
    
    if (aggrPerBrand.brand)
    {
        [aggrPerBrand finishAdd];
        [aggrs addObject:aggrPerBrand];
    }
    
    return aggrs;
}

+ (NSArray *)YTDReportsFrom:(NSArray *)monthReports
{
    NSMutableArray *reports = [[NSMutableArray alloc] initWithCapacity:monthReports.count];
    
    for (SalesTrendAggrPerBrand *aggr in monthReports)
        [reports addObject:[aggr convertToYTDAggr]];
    
    return reports;
}


- (void)addSalesTrend:(NSDictionary *)trend
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

- (SalesTrendAggrPerBrand *)convertToYTDAggr
{
    SalesTrendAggrPerBrand *ytdAggr = [[SalesTrendAggrPerBrand alloc] init];
    
    ytdAggr.brand = brand;
    ytdAggr.jan = jan;
    ytdAggr.feb = ytdAggr.jan + feb;
    ytdAggr.mar = ytdAggr.feb + mar;
    ytdAggr.apr = ytdAggr.mar + apr;
    ytdAggr.may = ytdAggr.apr + may;
    ytdAggr.jun = ytdAggr.may + jun;
    ytdAggr.jul = ytdAggr.jun + jul;
    ytdAggr.aug = ytdAggr.jul + aug;
    ytdAggr.sep = ytdAggr.aug + sep;
    ytdAggr.oct = ytdAggr.sep + oct;
    ytdAggr.nov = ytdAggr.oct + nov;
    ytdAggr.dec = ytdAggr.nov + dec;
    [ytdAggr finishAdd];
    
    return ytdAggr;
}

@end
