// SGridMovableCompositeElement.h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SGridMovableElement.h"

@interface SGridMovableCompositeElement : NSObject <SGridMovableElement> {
    NSMutableArray *subElements;
}

- (void) assertSubElementsNotNil;

@end
