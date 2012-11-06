//
//  ClientSalesAggr.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ClientSalesAggr.h"

#import "User.h"
#import "ClientSalesAggrPerGroup.h"
#import "Focused_brand.h"
#import "Product.h"
#import "umfundiCommon.h"

@implementation ClientSalesAggr

@synthesize monthArray;

@synthesize year;
@synthesize lastyear;
@synthesize aggrPerGroups;

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

+ (ClientSalesAggr *)AggrWithYTDorMAT:(BOOL)isYTD
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SALES_REPORT_Customer_OrderBy"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"groupName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    ClientSalesAggr *aggr = [[ClientSalesAggr alloc] initWithYTDorMAT:isYTD];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger curyear = [components year];

    aggr.year = [NSString stringWithFormat:@"%d", curyear];
    aggr.lastyear = [NSString stringWithFormat:@"%d", curyear - 1];

    ClientSalesAggrPerGroup *aggrTotal = [[ClientSalesAggrPerGroup alloc] init];
    aggrTotal.aggrPerPractices = [[NSMutableArray alloc] initWithCapacity:0];
    aggrTotal.group = @"All Accounts";
    [aggr addAggrPerGroup:aggrTotal];
    
    ClientSalesAggrPerGroup *aggrPerGroup = [[ClientSalesAggrPerGroup alloc] init];
    aggrPerGroup.aggrPerPractices = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *report in reports)
    {
        NSString *group = [report objectForKey:@"groupName"];
        
        if (aggrPerGroup.group == nil)
            aggrPerGroup.group = group;
        else if (![aggrPerGroup.group isEqualToString:group])
        {
            [aggrPerGroup finishAdd];
            [aggr addAggrPerGroup:aggrPerGroup];
            
            aggrPerGroup = [[ClientSalesAggrPerGroup alloc] init];
            aggrPerGroup.group = group;
            aggrPerGroup.aggrPerPractices = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        [aggrPerGroup addClientSales:report YTDorMAT:isYTD];
        [aggrTotal addClientSales:report YTDorMAT:isYTD];
    }
    
    [aggrTotal finishAdd];
    
    if (aggrPerGroup.group)
    {
        [aggrPerGroup finishAdd];
        [aggr addAggrPerGroup:aggrPerGroup];
    }
    
    [aggr finishAdd];
    
    return aggr;
}

+ (ClientSalesAggr *)AggrByBrands:(NSArray *)brands YTDorMAT:(BOOL)isYTD
{
    NSMutableArray *product_ids = [[NSMutableArray alloc] initWithCapacity:0];
    for (Focused_brand *brand in brands)
    {
        for (Product *product in [Product AllProductsFromBrand:brand.brand_name])
            [product_ids addObject:product.pcode];
    }
    
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:isYTD ? @"SALES_REPORT_by_Products_YTD" : @"SALES_REPORT_by_Products_MAT"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_product IN %@", product_ids];
    [fetchRequest setPredicate:predicate];

    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"groupName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    ClientSalesAggr *aggr = [[ClientSalesAggr alloc] initWithYTDorMAT:isYTD];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger curyear = [components year];
    
    aggr.year = [NSString stringWithFormat:@"%d", curyear];
    aggr.lastyear = [NSString stringWithFormat:@"%d", curyear - 1];

    ClientSalesAggrPerGroup *aggrTotal = [[ClientSalesAggrPerGroup alloc] init];
    aggrTotal.aggrPerPractices = [[NSMutableArray alloc] initWithCapacity:0];
    aggrTotal.group = @"All Accounts";
    [aggr addAggrPerGroup:aggrTotal];

    ClientSalesAggrPerGroup *aggrPerGroup = [[ClientSalesAggrPerGroup alloc] init];
    aggrPerGroup.aggrPerPractices = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *report in reports)
    {
        NSString *group = [report objectForKey:@"groupName"];
        
        if (aggrPerGroup.group == nil)
            aggrPerGroup.group = group;
        else if (![aggrPerGroup.group isEqualToString:group])
        {
            [aggrPerGroup finishAdd];
            [aggr addAggrPerGroup:aggrPerGroup];
            
            aggrPerGroup = [[ClientSalesAggrPerGroup alloc] init];
            aggrPerGroup.group = group;
            aggrPerGroup.aggrPerPractices = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        [aggrPerGroup addClientSales:report YTDorMAT:isYTD curYear:aggr.year lastYear:aggr.lastyear];
        [aggrTotal addClientSales:report YTDorMAT:isYTD curYear:aggr.year lastYear:aggr.lastyear];
    }
    
    [aggrTotal finishAdd];

    if (aggrPerGroup.group)
    {
        [aggrPerGroup finishAdd];
        [aggr addAggrPerGroup:aggrPerGroup];
    }
    
    [aggr finishAdd];
    
    return aggr;
}


- (void)addAggrPerGroup:(ClientSalesAggrPerGroup *)aggrPerGroup
{
    if (!aggrPerGroups)
        aggrPerGroups = [[NSMutableArray alloc] initWithCapacity:0];
    
    [aggrPerGroups addObject:aggrPerGroup];
}

- (void)finishAdd
{
    if ([aggrPerGroups count] == 0)
        return;
    
    for (NSInteger i = 1 ; i < aggrPerGroups.count - 1 ; i ++ )
    {
        for (NSInteger j = i + 1 ; j < aggrPerGroups.count ; j ++ )
        {
            ClientSalesAggrPerGroup *aggrX = [aggrPerGroups objectAtIndex:i];
            ClientSalesAggrPerGroup *aggrY = [aggrPerGroups objectAtIndex:j];
            if (aggrX.yearsum < aggrY.yearsum)
                [aggrPerGroups exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    
    NSInteger rank = 0;
    for (ClientSalesAggrPerGroup *aggrPerGroup in aggrPerGroups)
    {
        if ([aggrPerGroup.group isEqualToString:@"-"])
            aggrPerGroup.group = @"No Group";

        if (rank)
            aggrPerGroup.rank = [NSString stringWithFormat:@"%d", rank];
        rank ++;
    }

    ClientSalesAggrPerGroup *aggrTotal = [aggrPerGroups objectAtIndex:0];
    if (aggrTotal.yearsum > 0)
    {
        aggrTotal.totpro = @"100%";
        
        for (ClientSalesAggrPerGroup *aggrPerGroup in aggrPerGroups)
        {
            if (aggrPerGroup == aggrTotal)
                continue;
            
            double pro = aggrPerGroup.yearsum / aggrTotal.yearsum * 100;
            aggrPerGroup.totpro = [NSString stringWithFormat:@"%.1f%%", pro];
        }
    }
}

@end
