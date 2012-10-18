//
//  XMLparser.h
//  evCoreDataLoad
//
//  Created by Ian Molesworth on 24/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef XMLPARSER_DEFINES
#define XMLPARSER_DEFINES
#define DEF_MODE_SCHEME             0x01
#define DEF_MODE_DATABASE           0x02
#define DEF_MODE_CONFIG             0x03
#endif

#define kDEF_ITEM_TAG               @"tag"

@interface xmlParser : NSObject <NSXMLParserDelegate> {
    // an ad hoc string to hold element value
    NSMutableString *currentElementValue;
    NSMutableArray  *resArray;
    NSMutableDictionary  *currentElement;
    
    
    BOOL parseElement;
    
    int  elementLevel;
}
@property (readwrite)   int    schemeMode;
@property (strong, nonatomic) NSString *urlField;

- (void) reset;

- (xmlParser *) initXMLParser;

- (NSArray *)   getResult;

@end