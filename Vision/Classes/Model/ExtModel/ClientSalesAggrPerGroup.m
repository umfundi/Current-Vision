//
//  ClientSalesAggrPerGroup.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ClientSalesAggrPerGroup.h"

@implementation ClientSalesAggrPerGroup

@synthesize group;
@synthesize rank;

@synthesize jan;
@synthesize janString;
@synthesize feb;
@synthesize febString;
@synthesize mar;
@synthesize marString;
@synthesize apr;
@synthesize aprString;
@synthesize may;
@synthesize mayString;
@synthesize jun;
@synthesize junString;
@synthesize jul;
@synthesize julString;
@synthesize aug;
@synthesize augString;
@synthesize sep;
@synthesize sepString;
@synthesize oct;
@synthesize octString;
@synthesize nov;
@synthesize novString;
@synthesize dec;
@synthesize decString;
@synthesize yearsum;
@synthesize yearsumString;
@synthesize totpro;
@synthesize lastyearsum;
@synthesize lastyearsumString;
@synthesize diffpro;
@synthesize diffsum;

- (void)addClientSales:(NSDictionary *)report YTDorMAT:(BOOL)isYTD
{
    if (isYTD)
    {
        jan += [[report objectForKey:@"janval"] doubleValue];
        feb += [[report objectForKey:@"febval"] doubleValue];
        mar += [[report objectForKey:@"marval"] doubleValue];
        apr += [[report objectForKey:@"aprval"] doubleValue];
        may += [[report objectForKey:@"mayval"] doubleValue];
        jun += [[report objectForKey:@"junval"] doubleValue];
        jul += [[report objectForKey:@"julval"] doubleValue];
        aug += [[report objectForKey:@"augval"] doubleValue];
        sep += [[report objectForKey:@"sepval"] doubleValue];
        oct += [[report objectForKey:@"octval"] doubleValue];
        nov += [[report objectForKey:@"novval"] doubleValue];
        dec += [[report objectForKey:@"decval"] doubleValue];
        
        lastyearsum += [[report objectForKey:@"ytdvalprv"] doubleValue];
    }
    else
    {
        jan += [[report objectForKey:@"m_11val"] doubleValue];
        feb += [[report objectForKey:@"m_10val"] doubleValue];
        mar += [[report objectForKey:@"m_9val"] doubleValue];
        apr += [[report objectForKey:@"m_8val"] doubleValue];
        may += [[report objectForKey:@"m_7val"] doubleValue];
        jun += [[report objectForKey:@"m_6val"] doubleValue];
        jul += [[report objectForKey:@"m_5val"] doubleValue];
        aug += [[report objectForKey:@"m_4val"] doubleValue];
        sep += [[report objectForKey:@"m_3val"] doubleValue];
        oct += [[report objectForKey:@"m_2val"] doubleValue];
        nov += [[report objectForKey:@"m_1val"] doubleValue];
        dec += [[report objectForKey:@"m0val"] doubleValue];
        
        lastyearsum += [[report objectForKey:@"matvalprv"] doubleValue];
    }
}

- (void)addClientSales:(NSDictionary *)report YTDorMAT:(BOOL)isYTD curYear:(NSString *)curYear lastYear:(NSString *)lastYear
{
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
            jan += [[report objectForKey:@"janval"] doubleValue];
            feb += [[report objectForKey:@"febval"] doubleValue];
            mar += [[report objectForKey:@"marval"] doubleValue];
            apr += [[report objectForKey:@"aprval"] doubleValue];
            may += [[report objectForKey:@"mayval"] doubleValue];
            jun += [[report objectForKey:@"junval"] doubleValue];
            jul += [[report objectForKey:@"julval"] doubleValue];
            aug += [[report objectForKey:@"augval"] doubleValue];
            sep += [[report objectForKey:@"sepval"] doubleValue];
            oct += [[report objectForKey:@"octval"] doubleValue];
            nov += [[report objectForKey:@"novval"] doubleValue];
            dec += [[report objectForKey:@"decval"] doubleValue];
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
            jan += [[report objectForKey:@"m_11val"] doubleValue];
            feb += [[report objectForKey:@"m_10val"] doubleValue];
            mar += [[report objectForKey:@"m_9val"] doubleValue];
            apr += [[report objectForKey:@"m_8val"] doubleValue];
            may += [[report objectForKey:@"m_7val"] doubleValue];
            jun += [[report objectForKey:@"m_6val"] doubleValue];
            jul += [[report objectForKey:@"m_5val"] doubleValue];
            aug += [[report objectForKey:@"m_4val"] doubleValue];
            sep += [[report objectForKey:@"m_3val"] doubleValue];
            oct += [[report objectForKey:@"m_2val"] doubleValue];
            nov += [[report objectForKey:@"m_1val"] doubleValue];
            dec += [[report objectForKey:@"m0val"] doubleValue];
        }
        else if ([period isEqualToString:lastYear])
        {
            lastyearsum += [[report objectForKey:@"m_11val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m_10val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m_9val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m_8val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m_7val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m_6val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m_5val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m_4val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m_3val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m_2val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m_1val"] doubleValue];
            lastyearsum += [[report objectForKey:@"m0val"] doubleValue];
        }
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
    
    yearsum = jan + feb + mar + apr + may + jun + jul + aug + sep + oct + nov + dec;
    yearsumString = [NSString stringWithFormat:@"%.0f", round(yearsum)];

    lastyearsumString = [NSString stringWithFormat:@"%.0f", round(lastyearsum)];
    
    if (lastyearsum)
        diffpro = [NSString stringWithFormat:@"%.0f%%", round((yearsum - lastyearsum) / lastyearsum * 100)];
    diffsum = [NSString stringWithFormat:@"%.0f", round(yearsum - lastyearsum)];
}

@end
