//
//  ClientSalesAggr.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ClientSalesAggr.h"

#import "User.h"
#import "ClientSalesAggrPerGroup.h"
#import "Product.h"

@implementation ClientSalesAggr

@synthesize year;
@synthesize lastyear;
@synthesize aggrPerGroups;

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
    
    ClientSalesAggr *aggr = [[ClientSalesAggr alloc] init];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger curyear = [components year];

    aggr.year = [NSString stringWithFormat:@"%d", curyear];
    aggr.lastyear = [NSString stringWithFormat:@"%d", curyear - 1];

    ClientSalesAggrPerGroup *aggrPerGroup = [[ClientSalesAggrPerGroup alloc] init];
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
        }
        
        [aggrPerGroup addClientSales:report YTDorMAT:isYTD];
    }
    
    if (aggrPerGroup.group)
    {
        [aggrPerGroup finishAdd];
        [aggr addAggrPerGroup:aggrPerGroup];
    }
    
    [aggr finishAdd];
    
    return aggr;
}

+ (ClientSalesAggr *)AggrByProducts:(NSArray *)products YTDorMAT:(BOOL)isYTD
{
    NSMutableArray *product_ids = [[NSMutableArray alloc] initWithCapacity:products.count];
    for (Product *product in products)
        [product_ids addObject:product.pcode];
    
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
    
    ClientSalesAggr *aggr = [[ClientSalesAggr alloc] init];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger curyear = [components year];
    
    aggr.year = [NSString stringWithFormat:@"%d", curyear];
    aggr.lastyear = [NSString stringWithFormat:@"%d", curyear - 1];

    ClientSalesAggrPerGroup *aggrPerGroup = [[ClientSalesAggrPerGroup alloc] init];
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
        }
        
        [aggrPerGroup addClientSales:report YTDorMAT:isYTD curYear:aggr.year lastYear:aggr.lastyear];
    }
    
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
    
    ClientSalesAggrPerGroup *aggrTotal = [[ClientSalesAggrPerGroup alloc] init];
    aggrTotal.group = @"All Accounts";

    for (NSInteger i = 0 ; i < aggrPerGroups.count - 1 ; i ++ )
    {
        for (NSInteger j = i + 1 ; j < aggrPerGroups.count ; j ++ )
        {
            ClientSalesAggrPerGroup *aggrX = [aggrPerGroups objectAtIndex:i];
            ClientSalesAggrPerGroup *aggrY = [aggrPerGroups objectAtIndex:j];
            if (aggrX.yearsum < aggrY.yearsum)
                [aggrPerGroups exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    
    NSInteger rank = 1;
    for (ClientSalesAggrPerGroup *aggrPerGroup in aggrPerGroups)
    {
        if ([aggrPerGroup.group isEqualToString:@"-"])
            aggrPerGroup.group = @"No Group";
        
        aggrTotal.jan += aggrPerGroup.jan;
        aggrTotal.feb += aggrPerGroup.feb;
        aggrTotal.mar += aggrPerGroup.mar;
        aggrTotal.apr += aggrPerGroup.apr;
        aggrTotal.may += aggrPerGroup.may;
        aggrTotal.jun += aggrPerGroup.jun;
        aggrTotal.jul += aggrPerGroup.jul;
        aggrTotal.aug += aggrPerGroup.aug;
        aggrTotal.sep += aggrPerGroup.sep;
        aggrTotal.oct += aggrPerGroup.oct;
        aggrTotal.nov += aggrPerGroup.nov;
        aggrTotal.dec += aggrPerGroup.dec;
        
        aggrPerGroup.rank = [NSString stringWithFormat:@"%d", rank];
        rank ++;
    }
    
    [aggrTotal finishAdd];
    
    if (aggrTotal.yearsum > 0)
    {
        aggrTotal.totpro = @"100%";

        for (ClientSalesAggrPerGroup *aggrPerGroup in aggrPerGroups)
        {
            double pro = aggrPerGroup.yearsum / aggrTotal.yearsum * 100;
            aggrPerGroup.totpro = [NSString stringWithFormat:@"%.1f%%", pro];
        }
    }
    
    [aggrPerGroups insertObject:aggrTotal atIndex:0];
}

@end
