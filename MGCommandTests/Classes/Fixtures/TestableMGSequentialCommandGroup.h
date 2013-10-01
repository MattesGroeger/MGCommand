#import <Foundation/Foundation.h>
#import "MGSequentialCommandGroup.h"

@class MGCommandTestDelegate;

@interface TestableMGSequentialCommandGroup : MGSequentialCommandGroup

- (id)initWithDelegate: (MGCommandTestDelegate *)delegate;

@end