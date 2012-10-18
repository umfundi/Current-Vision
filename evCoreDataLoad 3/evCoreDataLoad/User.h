//
//  User.h
//  evCoreDataLoad
//
//  Created by Ian Molesworth on 26/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * id_user;
@property (nonatomic, retain) NSString * datalocation;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * accesslevel;
@property (nonatomic, retain) NSString * timestamp;

- (void) fromJSONObject:(id) object;
@end
