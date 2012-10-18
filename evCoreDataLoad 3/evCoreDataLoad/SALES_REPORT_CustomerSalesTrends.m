//
//  SALES_REPORT_CustomerSalesTrends.m
//  evCoreDataLoad
//
//  Created by Jiang Xiong on 9/28/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SALES_REPORT_CustomerSalesTrends.h"


@implementation SALES_REPORT_CustomerSalesTrends

@dynamic id_user;
@dynamic id_practice;
@dynamic id_customer;
@dynamic groupName;
@dynamic brand;
@dynamic datatype;
@dynamic dl;
@dynamic janval;
@dynamic febval;
@dynamic marval;
@dynamic aprval;
@dynamic mayval;
@dynamic junval;
@dynamic julval;
@dynamic augval;
@dynamic sepval;
@dynamic octval;
@dynamic novval;
@dynamic decval;
@dynamic ytdvalcur;
@dynamic ytdvalprv;
@dynamic ytdunitcur;
@dynamic ytdunitprv;
@dynamic m_12val;
@dynamic m_11val;
@dynamic m_1val;
@dynamic m_10val;
@dynamic m_9val;
@dynamic m_8val;
@dynamic m_2val;
@dynamic m_3val;
@dynamic m_4val;
@dynamic m_5val;
@dynamic m_7val;
@dynamic m_6val;
@dynamic m0val;
@dynamic matvalcur;
@dynamic matvalprv;
@dynamic matunitcur;
@dynamic matunitprv;

- (void) fromJSONObject:(id) object
{
    self.id_user = [object objectForKey:@"id_user"] ? [object objectForKey:@"id_user"] : @"";
    self.id_customer = [object objectForKey:@"id_customer"] ? [object objectForKey:@"id_customer"] : @"";
    self.id_practice = [object objectForKey:@"id_practice"] ? [object objectForKey:@"id_practice"] : @"";
    self.groupName = [object objectForKey:@"groupName"] ? [object objectForKey:@"groupName"] : @"";
    self.brand = [object objectForKey:@"brand"] ? [object objectForKey:@"brand"] : @"";
    self.datatype = [object objectForKey:@"datatype"] ? [object objectForKey:@"datatype"] : @"";
    self.dl = [object objectForKey:@"DL"] ? [object objectForKey:@"DL"] : @"";
    self.janval = [object objectForKey:@"janval"] ? [object objectForKey:@"janval"] : @"";
    self.febval = [object objectForKey:@"febval"] ? [object objectForKey:@"febval"] : @"";
    self.marval = [object objectForKey:@"marval"] ? [object objectForKey:@"marval"] : @"";
    self.aprval = [object objectForKey:@"aprval"] ? [object objectForKey:@"aprval"] : @"";
    self.mayval = [object objectForKey:@"mayval"] ? [object objectForKey:@"mayval"] : @"";
    self.junval = [object objectForKey:@"junval"] ? [object objectForKey:@"junval"] : @"";
    self.julval = [object objectForKey:@"julval"] ? [object objectForKey:@"julval"] : @"";
    self.augval = [object objectForKey:@"augval"] ? [object objectForKey:@"augval"] : @"";
    self.sepval = [object objectForKey:@"sepval"] ? [object objectForKey:@"sepval"] : @"";
    self.octval = [object objectForKey:@"octval"] ? [object objectForKey:@"octval"] : @"";
    self.novval = [object objectForKey:@"novval"] ? [object objectForKey:@"novval"] : @"";
    self.decval = [object objectForKey:@"decval"] ? [object objectForKey:@"decval"] : @"";
    self.ytdvalcur = [object objectForKey:@"ytdvalcur"] ? [object objectForKey:@"ytdvalcur"] : @"";
    self.ytdvalprv = [object objectForKey:@"ytdvalprv"] ? [object objectForKey:@"ytdvalprv"] : @"";
    self.ytdunitcur = [object objectForKey:@"ytdunitcur"] ? [object objectForKey:@"ytdunitcur"] : @"";
    self.ytdunitprv = [object objectForKey:@"ytdunitprv"] ? [object objectForKey:@"ytdunitprv"] : @"";
    self.m_12val = [object objectForKey:@"m_12val"] ? [object objectForKey:@"m_12val"] : @"";
    self.m_11val = [object objectForKey:@"m_11val"] ? [object objectForKey:@"m_11val"] : @"";
    self.m_10val = [object objectForKey:@"m_10val"] ? [object objectForKey:@"m_10val"] : @"";
    self.m_9val = [object objectForKey:@"m_9val"] ? [object objectForKey:@"m_9val"] : @"";
    self.m_8val = [object objectForKey:@"m_8val"] ? [object objectForKey:@"m_8val"] : @"";
    self.m_7val = [object objectForKey:@"m_7val"] ? [object objectForKey:@"m_7val"] : @"";
    self.m_6val = [object objectForKey:@"m_6val"] ? [object objectForKey:@"m_6val"] : @"";
    self.m_5val = [object objectForKey:@"m_5val"] ? [object objectForKey:@"m_5val"] : @"";
    self.m_4val = [object objectForKey:@"m_4val"] ? [object objectForKey:@"m_4val"] : @"";
    self.m_3val = [object objectForKey:@"m_3val"] ? [object objectForKey:@"m_3val"] : @"";
    self.m_2val = [object objectForKey:@"m_2val"] ? [object objectForKey:@"m_2val"] : @"";
    self.m_1val = [object objectForKey:@"m_1val"] ? [object objectForKey:@"m_1val"] : @"";
    self.m0val = [object objectForKey:@"m0val"] ? [object objectForKey:@"m0val"] : @"";
    self.matvalcur = [object objectForKey:@"matvalcur"] ? [object objectForKey:@"matvalcur"] : @"";
    self.matvalprv = [object objectForKey:@"matvalprv"] ? [object objectForKey:@"matvalprv"] : @"";
    self.matunitcur = [object objectForKey:@"matunitcur"] ? [object objectForKey:@"matunitcur"] : @"";
    self.matunitprv = [object objectForKey:@"matunitprv"] ? [object objectForKey:@"matunitprv"] : @"";
}

@end
