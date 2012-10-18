//
//  main.m
//  evCoreDataLoad
//
//  Created by Ian Molesworth on 18/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//
//  Mac server utility
//
//  Reads a series of XML files and turns them into JSON files
//  

#import <Foundation/Foundation.h>
#import "XMLParser.h"

static NSString *modelPath = nil;
static NSManagedObjectContext *context = nil;

static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
    NSString *path = @"evCoreDataLoad";
    path = [path stringByDeletingPathExtension];
    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext()
{
    if (context != nil) {
        return context;
    }

    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
        path = [path stringByDeletingPathExtension];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingString:@"-1.sqlite"]];
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}


static NSManagedObjectContext *managedObjectContextWithPath(NSString *sqlitePath)
{
    
    if (context != nil && modelPath && [modelPath isEqualToString:[sqlitePath stringByStandardizingPath]]) {
        return context;
    }
    
    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        //NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
        
        modelPath = [sqlitePath stringByStandardizingPath];
        NSURL *url = [NSURL fileURLWithPath:modelPath];
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}




static void loadXMLWithSource(NSString *baseURL, NSString *outputBaseDir, NSString *sqlitePath)
{
    NSLog (@"Loading XML from source %@", baseURL);

    NSURL* schemeURL = [[NSURL alloc  ]initWithString: [baseURL stringByAppendingString:@"DataSchema.xml"]];

    NSLog (@"Loading Parser with DataSchema %@", schemeURL);

    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithContentsOfURL:schemeURL];
    
    NSError *error = nil;
    
    NSURL* jsonURL = [NSURL fileURLWithPath: outputBaseDir];
                      
    [[NSFileManager defaultManager] createDirectoryAtURL: jsonURL withIntermediateDirectories: YES attributes: nil error: &error];
                      
    xmlParser *parser = [[xmlParser alloc] initXMLParser];
    parser.schemeMode = DEF_MODE_SCHEME;
    
    [nsXmlParser setDelegate:parser];
    BOOL success = [nsXmlParser parse];
    
    if (success)
        {
        NSLog (@"Dataschema parsed");
            
        NSManagedObjectContext *context = managedObjectContextWithPath(sqlitePath);
        
        NSArray *dataArray = [[NSArray alloc] initWithArray:[parser getResult]];
        
//        NSLog(@"data : %@", dataArray);
        for (NSDictionary *dic in dataArray)
        {
            NSString *data = [dic objectForKey:@"name"];
            [parser reset];
            parser.schemeMode = DEF_MODE_DATABASE;
            
            NSString *dataPath = [NSString stringWithFormat:@"%@%@.xml", baseURL, data];
            NSURL* dataURL = [[NSURL alloc  ]initWithString:dataPath ];
            
            NSLog(@"Getting %@", dataURL);
            
            nsXmlParser = [[NSXMLParser alloc] initWithContentsOfURL:dataURL];
            [nsXmlParser setDelegate:parser];
            
            NSString *jsonPath = [outputBaseDir stringByAppendingFormat:@"/%@.json", data];
            
            error = nil;
                        
            if ([nsXmlParser parse])
                {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[parser getResult]
                                                                   options:NSJSONWritingPrettyPrinted 
                                                                     error:&error];
                    
//                NSLog (@"Json string %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
                    
                // Write the Json out to a file                                    
                [jsonData writeToFile:jsonPath
                              options:NSDataWritingAtomic
                                    error:&error];
                    
                if (error != nil)
                    {
                    NSLog(@"Could not write Json outpt file : %@", error);
                    continue;
                    }
                }
            else 
                {
                NSLog(@"XML Parsing Error : %@", [nsXmlParser parserError]);
                continue;
            }
            nsXmlParser = nil;
            error = nil;
            
            NSArray* entityData = [NSJSONSerialization 
                                   JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath]
                                   options:kNilOptions
                                   error:&error];
            
            if (error != nil)
            {
                NSLog(@"JSON Parsing Error : %@", [error localizedDescription]);
                continue;
            }
            
            [entityData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                id object = [NSEntityDescription 
                                    insertNewObjectForEntityForName:[dic objectForKey:@"tag"] 
                                    inManagedObjectContext:context];
                
                if ([object respondsToSelector:@selector(fromJSONObject:)])
                {
                    [object performSelector:@selector(fromJSONObject:) withObject:obj];
                }
                
            }];
            
            error = nil;
            
            if (![context save:&error]) {
                NSLog(@"Error while saving context %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
                exit(1);
            }
        }
        } else {
            NSLog (@"Fail!");
        }

}


//static void loadJSONtoSqlite(NSString *jsonDir, NSString *sqlitePath)
//{
    
//}

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        // Create the managed object context
        
#define RELEASE_MODE
#ifdef RELEASE_MODE
        NSString *configPath;
        if (argc < 1)
            {
            printf("Usage:eCoreDataLoad <config file>");
            printf("Using default - evconfig.xml");
            configPath = @"evconfig.xml";                          
            }
        else {
            configPath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
            }
        
        NSString *symLink = [[NSFileManager defaultManager] destinationOfSymbolicLinkAtPath:configPath error:nil];
        
        if (symLink != nil)
            configPath = symLink;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:configPath])
            {
            NSLog(@"config file <%@> doesn't exist!", configPath);
            return -1;
            }
#else
        NSString *configPath = @"/config.xml";
#endif
        
        
        NSString *processPath = [[[[NSProcessInfo processInfo] arguments] objectAtIndex:0] stringByDeletingLastPathComponent];
        
        NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:configPath]];
        
        xmlParser *parser = [[xmlParser alloc] initXMLParser];
        parser.schemeMode = DEF_MODE_CONFIG;
        
        [nsXmlParser setDelegate:parser];
        if (![nsXmlParser parse])
        {
            NSLog(@"Config Parsing Error : %@", [nsXmlParser parserError]);
            return -1;
        }
        
        NSArray *array = [parser getResult];
        NSString *baseURL = [parser urlField];
        
        NSString *workPath = [NSHomeDirectory() stringByAppendingPathComponent:@"evCoreData"];
        
        // delete the json file directory if it exists - one way to clear it all!
        if ([[NSFileManager defaultManager] fileExistsAtPath:workPath])
             [[NSFileManager defaultManager] removeItemAtPath:workPath error:nil];
        
        NSLog(@"Urlfield : %@", [parser urlField]);
        
        for (NSDictionary *dataset in array)
        {
            NSString *basePath = [workPath stringByAppendingPathComponent:[dataset objectForKey:@"name"]];
            NSString *jsonPath = [basePath stringByAppendingPathComponent:@"json"];
                
            NSLog (@"Loading at %@", basePath);
            NSLog (@"Json store %@", jsonPath);
                
            NSString *sqlitePath = [processPath stringByAppendingFormat:@"/%@.sqlite", [dataset objectForKey:@"name"]];
                
            // delete the output sqlite file if it exists
            if ([[NSFileManager defaultManager] fileExistsAtPath:sqlitePath])
                [[NSFileManager defaultManager] removeItemAtPath:sqlitePath error:nil];
                
            loadXMLWithSource([baseURL stringByAppendingFormat:@"/%@/", [dataset objectForKey:@"source"]],
                              jsonPath, 
                              sqlitePath);
        }

    }     
    return 0;
}

