//
//  Users.h
//  Vision
//
//  Created by Ian Molesworth on 15/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString *accessLevel;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSString *datalocation;
@property (nonatomic, retain) NSString *id_user;
@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *datasource;
@property (nonatomic, retain) NSString *timestamp;

#pragma mark for Users

+ (NSString *)sqliteFilepathForUsers;
+ (BOOL)existsSqliteFileForUsers:(BOOL)tryCopy;
+ (NSString *)sqliteDownloadURLForUsers;

+ (NSManagedObjectContext *)managedObjectContextForUsers;
+ (NSManagedObjectModel *)managedObjectModelForUsers;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorForUsers;

+ (NSArray *)allUsers;
+ (User *)checkCredentialsWithUser:(NSString *)aUser andPassword:(NSString *)aPassword;

#pragma mark for a specified User

+ (void)setLoginUser:(User *)aUser;
+ (User *)loginUser;

+ (NSString *)sqliteFilepathForData;
+ (BOOL)existsSqliteFileForData:(BOOL)tryCopy;
+ (NSString *)sqliteDownloadURLForData;

+ (NSManagedObjectContext *)managedObjectContextForData;
+ (NSManagedObjectModel *)managedObjectModelForData;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorForData;

+ (NSString *)lastLoginUser;
+ (void)setLastLoginUser:(NSString *)user;

- (NSInteger)monthForData;
- (NSInteger)dayForData;

@end
