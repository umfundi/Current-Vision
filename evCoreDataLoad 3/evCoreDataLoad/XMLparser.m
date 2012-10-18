//
//  XMLparser.m
//  evCoreDataLoad
//
//  Created by Ian Molesworth on 24/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "XMLparser.h"
#import "User.h"
#import "Customer.h"

@implementation xmlParser
@synthesize schemeMode;
@synthesize urlField;

- (void) reset
{
    [resArray removeAllObjects];
    
    currentElement = nil;
    parseElement = NO;
    currentElementValue = nil;
    elementLevel = 0;
    self.schemeMode = DEF_MODE_DATABASE;
}

- (xmlParser *) initXMLParser {
    self = [super init];
    
    resArray = [[NSMutableArray alloc] init];
    elementLevel = 0;
    parseElement = NO;
    currentElement = nil;
    currentElementValue = nil;
    
    return self;
}

- (NSArray *) getResult
{
    return resArray;
}



- (void)parserDidStartDocument:(NSXMLParser *)parser {
//    NSLog(@"parser started document");
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
//    NSLog(@"parser ended document");

}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    //NSLog(@"element found – creating a new instance of Item:%@", elementName);
    elementLevel ++;
    if (self.schemeMode == DEF_MODE_SCHEME && [attributeDict objectForKey:kDEF_ITEM_TAG])
    {
       // NSLog(@"tag element found – creating a new instance of Tag...");
        
        [resArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:elementName,@"name", 
                             [attributeDict objectForKey:kDEF_ITEM_TAG],@"tag", nil]];
        
        return;
    }
    
    if (self.schemeMode == DEF_MODE_CONFIG)
    {
        if([elementName isEqualToString:@"url"])
        {
            currentElementValue = [[NSMutableString alloc] init];
        }
        else if (elementLevel == 3) 
        { // start of an element
            //NSLog(@"element found – creating a new instance of Item");
            parseElement = TRUE;
            
            currentElement = [[NSMutableDictionary alloc] init];
            
        } 
        else if (parseElement) // start of an attribute
        {
            currentElementValue = [[NSMutableString alloc] init];
        } 
        
    }
    else if (self.schemeMode == DEF_MODE_DATABASE)
    {
        if (elementLevel == 2) { // start of an element
            //NSLog(@"element found – creating a new instance of Item");
            parseElement = TRUE;
            
            currentElement = [[NSMutableDictionary alloc] init];
            
        } 
        else if (parseElement) // start of an attribute
        {
            currentElementValue = [[NSMutableString alloc] init];
        }

    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    //if (!parseElement || self.schemeMode == DEF_MODE_SCHEME)
    //    return;
    
    if (currentElementValue) {
        
        // append value to the ad hoc string
        [currentElementValue appendString:string];
    }
    //NSLog(@"Processing value for : %@", string);
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    elementLevel --;
    if (self.schemeMode == DEF_MODE_SCHEME)
        return;
    
    
    if (self.schemeMode == DEF_MODE_DATABASE)
    {
        if (elementLevel == 1 &&  currentElement) { // end of an element
            
            [resArray addObject:currentElement];
            currentElement = nil;
            parseElement = NO;
            
        } 
        else if (parseElement && currentElement && currentElementValue) // end of an attribute
        {
            [currentElement setObject:currentElementValue forKey:elementName];
        }
    }
    else 
    {
        if ([elementName isEqualToString:@"url"])
        {
            self.urlField = currentElementValue;
        }
        else if (elementLevel == 2 && currentElement) 
        { // end of an element
            
            [resArray addObject:currentElement];
            currentElement = nil;
            parseElement = NO;
            
        } 
        else if (parseElement && currentElement && currentElementValue) // end of an attribute
        {
            [currentElement setObject:currentElementValue forKey:elementName];
        }
    }
    
    //NSLog(@"Element end %@",elementName);
    
    currentElementValue = nil;
}
    
@end