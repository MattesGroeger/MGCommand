#import "TestableRetainClass.h"
#import "RetainGuardDelegate.h"


@interface TestableRetainClass ()
@property(nonatomic, weak) RetainGuardDelegate *delegate;
@end

@implementation TestableRetainClass {
}

- (id)initWithDelegate: (RetainGuardDelegate *)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }

    return self;
}

- (void)dealloc {
    [self.delegate instanceReleased];
}


@end