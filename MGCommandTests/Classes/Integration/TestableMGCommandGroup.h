#import <Foundation/Foundation.h>
#import "MGCommandGroup.h"

@class MGCommandTestDelegate;


@interface TestableMGCommandGroup : MGCommandGroup

- (id)initWithDelegate: (MGCommandTestDelegate *)delegate;
@end