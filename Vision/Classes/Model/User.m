//
//  Users.m
//  Vision
//
//  Created by Ian Molesworth on 15/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "User.h"

#define DownloadURL     @"http://elancovision.umfundi.com/data/dbase/"

#define LastLoginUser       @"LastLoginUser"

@implementation User

NSManagedObjectContext *gManagedObjectContextForUsers;
NSManagedObjectModel *gManagedObjectModelForUsers;
NSPersistentStoreCoordinator *gPersistentStoreCoordinatorForUsers;

NSManagedObjectContext *gManagedObjectContextForData;
NSManagedObjectModel *gManagedObjectModelForData;
NSPersistentStoreCoordinator *gPersistentStoreCoordinatorForData;

User *gLoginUser;

@dynamic accessLevel;
@dynamic country;
@dynamic data;
@dynamic datalocation;
@dynamic id_user;
@dynamic login;
@dynamic password;
@dynamic datasource;
@dynamic timestamp;

#pragma mark -
#pragma mark for Users

+ (NSString *)sqliteFilepathForUsers
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [documentPath stringByAppendingPathComponent:@"users.sqlite"];
}

+ (BOOL)existsSqliteFileForUsers:(BOOL)tryCopy
{
    NSString *filepath = [self sqliteFilepathForUsers];
    if (filepath)
    {
        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath])
        {
            if (tryCopy)
            {
                NSString *srcpath = [[NSBundle mainBundle] pathForResource:@"users.sqlite" ofType:nil];
                if (srcpath)
                {
                    if (![[NSFileManager defaultManager] copyItemAtPath:srcpath toPath:filepath error:nil])
                        return NO;
                    return YES;
                }
            }
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSString *)sqliteDownloadURLForUsers
{
    return [DownloadURL stringByAppendingString:@"users.sqlite"];
}


+ (NSManagedObjectContext *)managedObjectContextForUsers
{
    if (!gManagedObjectContextForUsers)
    {
        NSPersistentStoreCoordinator *coordinator = [User persistentStoreCoordinatorForUsers];
        if (coordinator != nil)
        {
            gManagedObjectContextForUsers = [[NSManagedObjectContext alloc] init];
            [gManagedObjectContextForUsers setPersistentStoreCoordinator:coordinator];
        }
    }
    
    return gManagedObjectContextForUsers;
}

+ (NSManagedObjectModel *)managedObjectModelForUsers
{
    if (!gManagedObjectModelForUsers)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"usersModel" withExtension:@"momd"];
        gManagedObjectModelForUsers = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return gManagedObjectModelForUsers;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorForUsers
{
    if (!gPersistentStoreCoordinatorForUsers)
    {
        NSURL *storeURL = [NSURL fileURLWithPath:[User sqliteFilepathForUsers]];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                 NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES],
                                 NSInferMappingModelAutomaticallyOption, nil];
        
        gPersistentStoreCoordinatorForUsers = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[User managedObjectModelForUsers]];
        [gPersistentStoreCoordinatorForUsers addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:nil];
    }
    
    return gPersistentStoreCoordinatorForUsers;
}


+ (User *)checkCredentialsWithUser:(NSString *)aUser andPassword:(NSString *)aPassword
{
    NSManagedObjectContext *context = [self managedObjectContextForUsers];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(login == %@) AND (password == %@)", aUser, aPassword];
    [fetchRequest setPredicate:predicate];
    
    NSArray *users = [context executeFetchRequest:fetchRequest error:nil];
    if ([users count] > 0)
        return [users objectAtIndex:0];
    
    return nil;
}


#pragma mark -
#pragma mark for a specified User

+ (void)setLoginUser:(User *)aUser
{
    gLoginUser = aUser;
    
    [User setLastLoginUser:aUser.login];
}

+ (User *)loginUser
{
    return gLoginUser;
}


+ (NSString *)sqliteFilepathForData
{
    NSString *filename = [NSString stringWithFormat:@"%@.sqlite", gLoginUser.datasource];

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [documentPath stringByAppendingPathComponent:filename];
}

+ (BOOL)existsSqliteFileForData:(BOOL)tryCopy
{
    NSString *filepath = [self sqliteFilepathForData];
    if (filepath)
    {
        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath])
        {
            if (tryCopy)
            {
                NSString *srcpath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.sqlite", gLoginUser.datasource] ofType:nil];
                if (srcpath)
                {
                    if (![[NSFileManager defaultManager] copyItemAtPath:srcpath toPath:filepath error:nil])
                        return NO;
                    return YES;
                }
            }
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSString *)sqliteDownloadURLForData
{
    return [DownloadURL stringByAppendingString:[NSString stringWithFormat:@"%@.sqlite", gLoginUser.datasource]];
}


+ (NSManagedObjectContext *)managedObjectContextForData
{
    if (!gManagedObjectContextForData)
    {
        NSPersistentStoreCoordinator *coordinator = [User persistentStoreCoordinatorForData];
        if (coordinator != nil)
        {
            gManagedObjectContextForData = [[NSManagedObjectContext alloc] init];
            [gManagedObjectContextForData setPersistentStoreCoordinator:coordinator];
        }
    }
    
    return gManagedObjectContextForData;
}

+ (NSManagedObjectModel *)managedObjectModelForData
{
    if (!gManagedObjectModelForData)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"elancoModel" withExtension:@"momd"];
        gManagedObjectModelForData = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return gManagedObjectModelForData;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorForData
{
    if (!gPersistentStoreCoordinatorForData)
    {
        NSURL *storeURL = [NSURL fileURLWithPath:[User sqliteFilepathForData]];
        
        NSError *error;
        
        gPersistentStoreCoordinatorForData = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[User managedObjectModelForData]];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        [gPersistentStoreCoordinatorForData addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        
        NSLog(@"%@", [error description]);
    }
    
    return gPersistentStoreCoordinatorForData;
}


+ (NSString *)lastLoginUser
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginUser];
}

+ (void)setLastLoginUser:(NSString *)user
{
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:LastLoginUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
