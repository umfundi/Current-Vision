//
//  Customers.m
//  evCoreDataLoad
//
//  Created by Ian Molesworth on 25/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "Customer.h"


@implementation Customer

@dynamic address1;
@dynamic address2;
@dynamic address3;
@dynamic brick;
@dynamic city;
@dynamic country;
@dynamic customerName;
@dynamic customerName2;
@dynamic fax;
@dynamic grade;
@dynamic groupName;
@dynamic groupType;
@dynamic id_customer;
@dynamic id_practice;
@dynamic id_user;
@dynamic isMain;
@dynamic postcode;
@dynamic province;
@dynamic sap_no;
@dynamic website;
@dynamic tel;

- (void) fromJSONObject:(id) object
{
    self.address1 = [object objectForKey:@"address1"] ? [object objectForKey:@"address1"] : @"";
    self.address2 = [object objectForKey:@"address2"] ? [object objectForKey:@"address2"] : @"";
    self.address3 = [object objectForKey:@"address3"] ? [object objectForKey:@"address3"] : @"";
    self.brick = [object objectForKey:@"brick"] ? [object objectForKey:@"brick"] : @"";
    self.city = [object objectForKey:@"city"] ? [object objectForKey:@"city"] : @"";
    self.country = [object objectForKey:@"country"] ? [object objectForKey:@"country"] : @"";
    self.customerName = [object objectForKey:@"customerName"] ? [object objectForKey:@"customerName"] : @"";
    self.customerName2 = [object objectForKey:@"customerName2"] ? [object objectForKey:@"customerName2"] : @"";
    self.fax = [object objectForKey:@"fax"] ? [object objectForKey:@"fax"] : @"";
    self.grade = [object objectForKey:@"grade"] ? [object objectForKey:@"grade"] : @"";
    self.groupName = [object objectForKey:@"groupName"] ? [object objectForKey:@"groupName"] : @"";
    self.groupType = [object objectForKey:@"groupType"] ? [object objectForKey:@"groupType"] : @"";
    self.id_customer = [object objectForKey:@"id_customer"] ? [object objectForKey:@"id_customer"] : @"";
    self.id_practice = [object objectForKey:@"id_practice"] ? [object objectForKey:@"id_practice"] : @"";
    self.id_user = [object objectForKey:@"id_user"] ? [object objectForKey:@"id_user"] : @"";
    self.isMain = [object objectForKey:@"isMain"] ? [object objectForKey:@"isMain"] : @"";
    self.postcode = [object objectForKey:@"postcode"] ? [object objectForKey:@"postcode"] : @"";
    self.province = [object objectForKey:@"province"] ? [object objectForKey:@"province"] : @"";
    self.sap_no = [object objectForKey:@"sap_no"] ? [object objectForKey:@"sap_no"] : @"";
    self.tel = [object objectForKey:@"tel"] ? [object objectForKey:@"tel"] : @"";
    self.website = [object objectForKey:@"website"] ? [object objectForKey:@"website"] : @"";
}
@end
