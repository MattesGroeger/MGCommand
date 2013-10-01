#import "RetainGuardDelegate.h"
#import "TestableRetainClass.h"
#import "MGCommandGroup.h"


@implementation RetainGuardDelegate

- (void)createObject
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"

	[[TestableRetainClass alloc] initWithDelegate: self];

#pragma clang diagnostic pop
}

- (void)createObjectAndRetain
{
	TestableRetainClass *instance = [[TestableRetainClass alloc] initWithDelegate: self];

	MGCommandRetain(instance);
}

- (void)createObjectAndRetainAndRelease
{
	TestableRetainClass *instance = [[TestableRetainClass alloc] initWithDelegate: self];

	MGCommandRetain(instance);
	MGCommandRelease(instance);
}

- (void)instanceReleased
{

}

@end