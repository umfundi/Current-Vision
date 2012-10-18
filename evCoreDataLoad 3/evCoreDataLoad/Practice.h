//
//  Practices.h
//  evCoreDataLoad
//
//  Created by Jiang Xiong on 9/28/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Practice : NSManagedObject

@property (nonatomic, retain) NSString * add1;
@property (nonatomic, retain) NSString * add2;
@property (nonatomic, retain) NSString * brick;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * practiceCode;
@property (nonatomic, retain) NSString * practiceName;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * sap_no;
@property (nonatomic, retain) NSString * tel;

- (void) fromJSONObject:(id) object;
@end
