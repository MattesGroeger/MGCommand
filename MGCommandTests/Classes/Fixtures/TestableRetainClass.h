#import <Foundation/Foundation.h>

@class RetainGuardDelegate;


@interface TestableRetainClass : NSObject

- (id)initWithDelegate: (RetainGuardDelegate *)delegate;

@end