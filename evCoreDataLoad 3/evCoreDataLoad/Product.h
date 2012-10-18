//
//  Product.h
//  evCoreDataLoad
//
//  Created by Jiang Xiong on 9/28/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * pcode;
@property (nonatomic, retain) NSString * pname;
@property (nonatomic, retain) NSString * pclass;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * group1;
@property (nonatomic, retain) NSString * group2;
@property (nonatomic, retain) NSString * group3;
@property (nonatomic, retain) NSString * group4;
@property (nonatomic, retain) NSString * group5;
@property (nonatomic, retain) NSString * group6;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * datecrea;
@property (nonatomic, retain) NSNumber * status;

- (void) fromJSONObject:(id) object;
@end
