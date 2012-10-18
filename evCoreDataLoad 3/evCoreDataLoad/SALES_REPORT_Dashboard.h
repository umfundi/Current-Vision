//
//  SALES_REPORT_Dashboard.h
//  evCoreDataLoad
//
//  Created by Jiang Xiong on 9/28/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SALES_REPORT_Dashboard : NSManagedObject

@property (nonatomic, retain) NSString * ptype;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * dl;
@property (nonatomic, retain) NSString * id_user;
@property (nonatomic, retain) NSString * matvalcur;
@property (nonatomic, retain) NSString * matvalprv;
@property (nonatomic, retain) NSString * ytdvalcur;
@property (nonatomic, retain) NSString * ytdvalprv;
@property (nonatomic, retain) NSString * mvalcur;
@property (nonatomic, retain) NSString * mvalprv;

@end
