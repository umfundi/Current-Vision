//
//  SALES_REPORT_CustomerDistribution_detail.h
//  Vision
//
//  Created by Jin on 10/23/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SALES_REPORT_CustomerDistribution_detail : NSManagedObject

@property (nonatomic, retain) NSString *brand;
@property (nonatomic, retain) NSString *ctype;
@property (nonatomic, retain) NSString *dl;
@property (nonatomic, retain) NSString *id_customer;
@property (nonatomic, retain) NSString *id_product;
@property (nonatomic, retain) NSString *id_user;
@property (nonatomic, retain) NSString *interval;
@property (nonatomic, retain) NSString *plevel;
@property (nonatomic, retain) NSString *pname;
@property (nonatomic, retain) NSString *ptype;
@property (nonatomic, retain) NSString *pvalcur;
@property (nonatomic, retain) NSString *pvalprv;

@end
