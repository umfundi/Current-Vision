//
//  SALES_REPORT_Customer_OrderBy.m
//  evCoreDataLoad
//
//  Created by Jiang Xiong on 9/28/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SALES_REPORT_Customer_OrderBy.h"


@implementation SALES_REPORT_Customer_OrderBy

@dynamic dl;
@dynamic aprval;
@dynamic augval;
@dynamic brand;
@dynamic decval;
@dynamic febval;
@dynamic groupName;
@dynamic id_customer;
@dynamic id_practice;
@dynamic id_user;
@dynamic janval;
@dynamic julval;
@dynamic junval;
@dynamic m0val;
@dynamic m_10val;
@dynamic m_11val;
@dynamic m_12val;
@dynamic m_1val;
@dynamic m_2val;
@dynamic m_3val;
@dynamic m_4val;
@dynamic m_5val;
@dynamic m_6val;
@dynamic m_7val;
@dynamic m_8val;
@dynamic m_9val;
@dynamic matvalcur;
@dynamic m_12val2;
@dynamic matvalprv;
@dynamic matvalprv2;
@dynamic mayval;
@dynamic novval;
@dynamic octval;
@dynamic rankmatcustgroup;
@dynamic rankmatcustpractice;
@dynamic marval;
@dynamic rankmatcusttotal;
@dynamic rankmatcustuser;
@dynamic rankmatgrouptotal;
@dynamic rankmatgroupuser;
@dynamic rankmatpracgroup;
@dynamic rankmatpractotal;
@dynamic rankmatpracuser;
@dynamic rankytdcustgroup;
@dynamic rankytdcustpractice;
@dynamic rankytdcusttotal;
@dynamic rankytdcustuser;
@dynamic rankytdgrouptotal;
@dynamic rankytdgroupuser;
@dynamic rankytdpracgroup;
@dynamic rankytdpractotal;
@dynamic rankytdpracuser;
@dynamic runningmatvalcur;
@dynamic runningytdvalcur;
@dynamic sepval;
@dynamic ytdvalcur;
@dynamic ytdvalprv;
@dynamic ytdvalprv2;

- (void) fromJSONObject:(id) object
{
    
    self.dl = [object objectForKey:@"DL"] ? [object objectForKey:@"DL"] : @"";
    self.aprval = [object objectForKey:@"aprval"] ? [object objectForKey:@"aprval"] : @"";
    self.augval = [object objectForKey:@"aprval"] ? [object objectForKey:@"aprval"] : @"";
    self.brand = [object objectForKey:@"brand"] ? [object objectForKey:@"brand"] : @"";
    self.decval = [object objectForKey:@"decval"] ? [object objectForKey:@"decval"] : @"";
    self.febval = [object objectForKey:@"febval"] ? [object objectForKey:@"febval"] : @"";
    self.groupName = [object objectForKey:@"groupName"] ? [object objectForKey:@"groupName"] : @"";
    self.id_customer = [object objectForKey:@"id_customer"] ? [object objectForKey:@"id_customer"] : @"";
    self.id_practice = [object objectForKey:@"id_practice"] ? [object objectForKey:@"id_practice"] : @"";
    self.id_user = [object objectForKey:@"id_user"] ? [object objectForKey:@"id_user"] : @"";
    
    self.janval = [object objectForKey:@"janval"] ? [object objectForKey:@"janval"] : @"";
    self.julval = [object objectForKey:@"julval"] ? [object objectForKey:@"julval"] : @"";
    self.junval = [object objectForKey:@"junval"] ? [object objectForKey:@"junval"] : @"";
    self.m0val = [object objectForKey:@"m0val"] ? [object objectForKey:@"m0val"] : @"";
    self.m_1val = [object objectForKey:@"m_1val"] ? [object objectForKey:@"m_1val"] : @"";
    self.m_2val = [object objectForKey:@"m_2val"] ? [object objectForKey:@"m_2val"] : @"";
    self.m_3val = [object objectForKey:@"m_3val"] ? [object objectForKey:@"m_3val"] : @"";
    self.m_4val = [object objectForKey:@"m_4val"] ? [object objectForKey:@"m_4val"] : @"";
    self.m_5val = [object objectForKey:@"m_5val"] ? [object objectForKey:@"m_5val"] : @"";
    self.m_6val = [object objectForKey:@"m_6val"] ? [object objectForKey:@"m_6val"] : @"";
    
    self.m_7val = [object objectForKey:@"m_7val"] ? [object objectForKey:@"m_7val"] : @"";
    self.m_8val = [object objectForKey:@"m_8val"] ? [object objectForKey:@"m_8val"] : @"";
    self.m_9val = [object objectForKey:@"m_9val"] ? [object objectForKey:@"m_9val"] : @"";
    self.m_10val = [object objectForKey:@"m_10val"] ? [object objectForKey:@"m_10val"] : @"";
    self.m_11val = [object objectForKey:@"m_11val"] ? [object objectForKey:@"m_11val"] : @"";
    self.m_12val = [object objectForKey:@"m_12val"] ? [object objectForKey:@"m_12val"] : @"";
    self.marval = [object objectForKey:@"marval"] ? [object objectForKey:@"marval"] : @"";
    self.matvalcur = [object objectForKey:@"matvalcur"] ? [object objectForKey:@"matvalcur"] : @"";
    self.matvalprv = [object objectForKey:@"matvalprv"] ? [object objectForKey:@"matvalprv"] : @"";
    self.matvalprv2 = [object objectForKey:@"matvalprv2"] ? [object objectForKey:@"matvalprv2"] : @"";
    
    self.mayval = [object objectForKey:@"mayval"] ? [object objectForKey:@"mayval"] : @"";
    self.novval = [object objectForKey:@"novval"] ? [object objectForKey:@"novval"] : @"";
    self.octval = [object objectForKey:@"octval"] ? [object objectForKey:@"octval"] : @"";
    self.rankmatcustgroup = [object objectForKey:@"rankmatcustgroup"] ? [object objectForKey:@"rankmatcustgroup"] : @"";
    self.rankmatcustpractice = [object objectForKey:@"rankmatcustpractice"] ? [object objectForKey:@"rankmatcustpractice"] : @"";
    self.rankmatcusttotal = [object objectForKey:@"rankmatcusttotal"] ? [object objectForKey:@"rankmatcusttotal"] : @"";
    self.rankmatcustuser = [object objectForKey:@"rankmatcustuser"] ? [object objectForKey:@"rankmatcustuser"] : @"";
    self.rankmatgrouptotal = [object objectForKey:@"rankmatgrouptotal"] ? [object objectForKey:@"rankmatgrouptotal"] : @"";
    self.rankmatgroupuser = [object objectForKey:@"rankmatgroupuser"] ? [object objectForKey:@"rankmatgroupuser"] : @"";
    self.rankmatpracgroup = [object objectForKey:@"rankmatpracgroup"] ? [object objectForKey:@"rankmatpracgroup"] : @"";
    
    self.rankmatpractotal = [object objectForKey:@"rankmatpractotal"] ? [object objectForKey:@"rankmatpractotal"] : @"";
    self.rankmatpracuser = [object objectForKey:@"rankmatpracuser"] ? [object objectForKey:@"rankmatpracuser"] : @"";
    self.rankytdcustgroup = [object objectForKey:@"rankytdcustgroup"] ? [object objectForKey:@"rankytdcustgroup"] : @"";
    self.rankytdcustpractice = [object objectForKey:@"rankytdcustpractice"] ? [object objectForKey:@"rankytdcustpractice"] : @"";
    self.rankytdcusttotal = [object objectForKey:@"rankytdcusttotal"] ? [object objectForKey:@"rankytdcusttotal"] : @"";
    self.rankytdcustuser = [object objectForKey:@"rankytdcustuser"] ? [object objectForKey:@"rankytdcustuser"] : @"";
    self.rankytdgrouptotal = [object objectForKey:@"rankytdgrouptotal"] ? [object objectForKey:@"rankytdgrouptotal"] : @"";
    
    self.rankytdgroupuser = [object objectForKey:@"rankytdgroupuser"] ? [object objectForKey:@"rankytdgroupuser"] : @"";
    self.rankytdpracgroup = [object objectForKey:@"rankytdpracgroup"] ? [object objectForKey:@"rankytdpracgroup"] : @"";
    self.rankytdpractotal = [object objectForKey:@"rankytdpractotal"] ? [object objectForKey:@"rankytdpractotal"] : @"";
    self.rankytdpracuser = [object objectForKey:@"rankytdpracuser"] ? [object objectForKey:@"rankytdpracuser"] : @"";
    self.runningmatvalcur = [object objectForKey:@"runningmatvalcur"] ? [object objectForKey:@"runningmatvalcur"] : @"";
    self.runningytdvalcur = [object objectForKey:@"runningytdvalcur"] ? [object objectForKey:@"runningytdvalcur"] : @"";
    self.sepval = [object objectForKey:@"sepval"] ? [object objectForKey:@"sepval"] : @"";
    self.ytdvalcur = [object objectForKey:@"rankytdgroupuser"] ? [object objectForKey:@"ytdvalcur"] : @"";
    self.ytdvalprv = [object objectForKey:@"ytdvalprv"] ? [object objectForKey:@"ytdvalprv"] : @"";
    self.ytdvalprv = [object objectForKey:@"ytdvalprv"] ? [object objectForKey:@"ytdvalprv"] : @"";
}

@end
