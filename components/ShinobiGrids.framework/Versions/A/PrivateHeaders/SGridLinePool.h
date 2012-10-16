// SGridLinePool.h
#import <Foundation/Foundation.h>
@class SGridLine;

@interface SGridLinePool : NSObject {
@private
    NSMutableArray *subLinePool;
}

+ (SGridLine*) getSubGridLineForVertical:(BOOL) requestVerticalLine;
+ (void) returnSubGridLine: (SGridLine*) lineToReturn;

@end
