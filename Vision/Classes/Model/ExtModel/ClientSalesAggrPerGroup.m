//
//  ClientSalesAggrPerGroup.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ClientSalesAggrPerGroup.h"
#import "Practice.h"

@implementation ClientSalesAggrPerGroup

@synthesize group;
@synthesize rank;

@synthesize monthValArray, monthValStringArray;
@synthesize yearsum;
@synthesize yearsumString;
@synthesize totpro;
@synthesize lastyearsum;
@synthesize lastyearsumString;
@synthesize diffpro;
@synthesize diffsum;

@synthesize aggrPerPractices;

- (id)init
{
    self = [super init];
    if (self)
    {
        monthValArray = (double *)malloc(sizeof(double) * 13);
        for (NSInteger i = 0 ; i < 12 ; i ++ )
            monthValArray[i] = 0;
    }
    
    return self;
}

- (void)addClientSales:(NSDictionary *)report YTDorMAT:(BOOL)isYTD
{
    if (aggrPerPractices)
    {
        NSString *id_practice = [report objectForKey:@"id_practice"];
        NSString *practiceName = [Practice PracticeNameFrom:id_practice];
        
        ClientSalesAggrPerGroup *aggrPerPractice;
        for (aggrPerPractice in aggrPerPractices)
        {
            if ([aggrPerPractice.group isEqualToString:practiceName])
                break;
        }
        if (!aggrPerPractice)
        {
            aggrPerPractice = [[ClientSalesAggrPerGroup alloc] init];
            aggrPerPractice.group = practiceName;
            
            [aggrPerPractices addObject:aggrPerPractice];
        }
        [aggrPerPractice addClientSales:report YTDorMAT:isYTD];
    }
    
    if (isYTD)
    {
        monthValArray[0] += [[report objectForKey:@"janval"] doubleValue];
        monthValArray[1] += [[report objectForKey:@"febval"] doubleValue];
        monthValArray[2] += [[report objectForKey:@"marval"] doubleValue];
        monthValArray[3] += [[report objectForKey:@"aprval"] doubleValue];
        monthValArray[4] += [[report objectForKey:@"mayval"] doubleValue];
        monthValArray[5] += [[report objectForKey:@"junval"] doubleValue];
        monthValArray[6] += [[report objectForKey:@"julval"] doubleValue];
        monthValArray[7] += [[report objectForKey:@"augval"] doubleValue];
        monthValArray[8] += [[report objectForKey:@"sepval"] doubleValue];
        monthValArray[9] += [[report objectForKey:@"octval"] doubleValue];
        monthValArray[10] += [[report objectForKey:@"novval"] doubleValue];
        monthValArray[11] += [[report objectForKey:@"decval"] doubleValue];
        
        lastyearsum += [[report objectForKey:@"ytdvalprv"] doubleValue];
    }
    else
    {
        for (NSInteger i = 0 ; i < 12 ; i ++ )
        {
            NSInteger col_index = 11 - i;
            if (col_index == 0)
                monthValArray[i] += [[report objectForKey:@"m0val"] doubleValue];
            else
                monthValArray[i] += [[report objectForKey:[NSString stringWithFormat:@"m_%dval", col_index]] doubleValue];
        }
        
        lastyearsum += [[report objectForKey:@"matvalprv"] doubleValue];
    }
}

- (void)addClientSales:(NSDictionary *)report YTDorMAT:(BOOL)isYTD curYear:(NSString *)curYear lastYear:(NSString *)lastYear
{
    if (aggrPerPractices)
    {
        NSString *id_practice = [report objectForKey:@"id_practice"];
        NSString *practiceName = [Practice PracticeNameFrom:id_practice];
        
        ClientSalesAggrPerGroup *aggrPerPractice;
        for (aggrPerPractice in aggrPerPractices)
        {
            if ([aggrPerPractice.group isEqualToString:practiceName])
                break;
        }
        if (!aggrPerPractice)
        {
            aggrPerPractice = [[ClientSalesAggrPerGroup alloc] init];
            aggrPerPractice.group = practiceName;
            
            [aggrPerPractices addObject:aggrPerPractice];
        }
        [aggrPerPractice addClientSales:report YTDorMAT:isYTD curYear:curYear lastYear:lastYear];
    }
    
    NSString *period = [report objectForKey:@"period"];
    NSRange seperator_range = [period rangeOfString:@"-"];
    if (seperator_range.location != NSNotFound)
    {
        period = [period substringFromIndex:seperator_range.location + 1];
        
        seperator_range = [period rangeOfString:@"/"];
        if (seperator_range.location != NSNotFound)
            period = [period substringFromIndex:seperator_range.location + 1];
    }

    if (isYTD)
    {
        if ([period isEqualToString:curYear])
        {
            monthValArray[0] += [[report objectForKey:@"janval"] doubleValue];
            monthValArray[1] += [[report objectForKey:@"febval"] doubleValue];
            monthValArray[2] += [[report objectForKey:@"marval"] doubleValue];
            monthValArray[3] += [[report objectForKey:@"aprval"] doubleValue];
            monthValArray[4] += [[report objectForKey:@"mayval"] doubleValue];
            monthValArray[5] += [[report objectForKey:@"junval"] doubleValue];
            monthValArray[6] += [[report objectForKey:@"julval"] doubleValue];
            monthValArray[7] += [[report objectForKey:@"augval"] doubleValue];
            monthValArray[8] += [[report objectForKey:@"sepval"] doubleValue];
            monthValArray[9] += [[report objectForKey:@"octval"] doubleValue];
            monthValArray[10] += [[report objectForKey:@"novval"] doubleValue];
            monthValArray[11] += [[report objectForKey:@"decval"] doubleValue];
        }
        else if ([period isEqualToString:lastYear])
        {
            lastyearsum += [[report objectForKey:@"janval"] doubleValue];
            lastyearsum += [[report objectForKey:@"febval"] doubleValue];
            lastyearsum += [[report objectForKey:@"marval"] doubleValue];
            lastyearsum += [[report objectForKey:@"aprval"] doubleValue];
            lastyearsum += [[report objectForKey:@"mayval"] doubleValue];
            lastyearsum += [[report objectForKey:@"junval"] doubleValue];
            lastyearsum += [[report objectForKey:@"julval"] doubleValue];
            lastyearsum += [[report objectForKey:@"augval"] doubleValue];
            lastyearsum += [[report objectForKey:@"sepval"] doubleValue];
            lastyearsum += [[report objectForKey:@"octval"] doubleValue];
            lastyearsum += [[report objectForKey:@"novval"] doubleValue];
            lastyearsum += [[report objectForKey:@"decval"] doubleValue];
        }
    }
    else
    {
        if ([period isEqualToString:curYear])
        {
            for (NSInteger i = 0 ; i < 12 ; i ++ )
            {
                NSInteger col_index = 11 - i;
                if (col_index == 0)
                    monthValArray[i] += [[report objectForKey:@"m0val"] doubleValue];
                else
                    monthValArray[i] += [[report objectForKey:[NSString stringWithFormat:@"m_%dval", col_index]] doubleValue];
            }
        }
        else if ([period isEqualToString:lastYear])
        {
            for (NSInteger i = 0 ; i < 12 ; i ++ )
            {
                NSInteger col_index = 11 - i;
                if (col_index == 0)
                    lastyearsum += [[report objectForKey:@"m0val"] doubleValue];
                else
                    lastyearsum += [[report objectForKey:[NSString stringWithFormat:@"m_%dval", col_index]] doubleValue];
            }
        }
    }
}

- (void)finishAdd
{
    if (aggrPerPractices)
    {
        for (ClientSalesAggrPerGroup *aggrPerPractice in aggrPerPractices)
            [aggrPerPractice finishAdd];

        ClientSalesAggrPerGroup *aggrTotal = [[ClientSalesAggrPerGroup alloc] init];
        aggrTotal.group = @"Total";
        
        for (NSInteger i = 0 ; i < aggrPerPractices.count - 1 ; i ++ )
        {
            for (NSInteger j = i + 1 ; j < aggrPerPractices.count ; j ++ )
            {
                ClientSalesAggrPerGroup *aggrX = [aggrPerPractices objectAtIndex:i];
                ClientSalesAggrPerGroup *aggrY = [aggrPerPractices objectAtIndex:j];
                if (aggrX.yearsum < aggrY.yearsum)
                    [aggrPerPractices exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
        
        NSInteger _rank = 1;
        for (ClientSalesAggrPerGroup *aggrPerGroup in aggrPerPractices)
        {
            for (NSInteger i = 0 ; i < 12 ; i ++ )
                aggrTotal.monthValArray[i] += aggrPerGroup.monthValArray[i];
            
            aggrPerGroup.rank = [NSString stringWithFormat:@"%d", _rank];
            _rank ++;
        }
        
        [aggrTotal finishAdd];
        
        if (aggrTotal.yearsum > 0)
        {
            aggrTotal.totpro = @"100%";
            
            for (ClientSalesAggrPerGroup *aggrPerGroup in aggrPerPractices)
            {
                double pro = aggrPerGroup.yearsum / aggrTotal.yearsum * 100;
                aggrPerGroup.totpro = [NSString stringWithFormat:@"%.1f%%", pro];
            }
        }
        
        [aggrPerPractices insertObject:aggrTotal atIndex:0];
    }

    NSMutableArray *stringArray = [[NSMutableArray alloc] initWithCapacity:12];
    for (NSInteger i = 0 ; i < 12 ; i ++ )
    {
        [stringArray addObject:[NSString stringWithFormat:@"%.0f", round(monthValArray[i])]];
        yearsum += monthValArray[i];
    }
    monthValStringArray = stringArray;
    
    yearsumString = [NSString stringWithFormat:@"%.0f", round(yearsum)];

    lastyearsumString = [NSString stringWithFormat:@"%.0f", round(lastyearsum)];
    
    if (lastyearsum)
        diffpro = [NSString stringWithFormat:@"%.0f%%", round((yearsum - lastyearsum) / lastyearsum * 100)];
    diffsum = [NSString stringWithFormat:@"%.0f", round(yearsum - lastyearsum)];
}

@end
