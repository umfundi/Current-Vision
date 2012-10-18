//
//  Practices.m
//  evCoreDataLoad
//
//  Created by Jiang Xiong on 9/28/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "Practice.h"


@implementation Practice

@dynamic add1;
@dynamic add2;
@dynamic brick;
@dynamic city;
@dynamic country;
@dynamic fax;
@dynamic isActive;
@dynamic postcode;
@dynamic practiceCode;
@dynamic practiceName;
@dynamic province;
@dynamic sap_no;
@dynamic tel;


- (void) fromJSONObject:(id) object
{
    self.add1 = [object objectForKey:@"Add1"];
    self.add2 = [object objectForKey:@"Add2"];
    self.brick = [object objectForKey:@"Brick"];
    self.city = [object objectForKey:@"City"];
    self.country = [object objectForKey:@"Country"];
    self.fax = [object objectForKey:@"Fax"];
    self.postcode = [object objectForKey:@"PostCode"];
    
    
    self.practiceCode = [object objectForKey:@"PracticeCODE"];
    self.practiceName = [object objectForKey:@"PracticeName"];
    self.province = [object objectForKey:@"Province"];
    self.sap_no = [object objectForKey:@"sap_no"];
    self.tel = [object objectForKey:@"Tel"];
    
    self.isActive = [NSNumber numberWithBool:[[object objectForKey:@"isActive"] boolValue]];
}
@end
