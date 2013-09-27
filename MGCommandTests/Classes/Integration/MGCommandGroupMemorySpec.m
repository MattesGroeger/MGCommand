#import "Kiwi.h"
#import "TestableMGCommandGroup.h"
#import "MGCommandTestDelegate.h"

SPEC_BEGIN(MGCommandGroupMemorySpec)
        describe(@"MGCommandGroup", ^{
            context(@"with weak reference to the MGCommandGroup", ^{
                context(@"when execute on group is called", ^{
                    context(@"without commands", ^{
                        it(@"should dealloc after execution", ^{
                            @autoreleasepool {
                                MGCommandTestDelegate *delegate = [[MGCommandTestDelegate alloc] init];

                                [[delegate should] receive: @selector(deallocCalled)];

                                [delegate executeEmptyMGCommandGroup];
                            }
                        });
                    });

                    context(@"with synchronous command", ^{
                        it(@"should dealloc after execution", ^{
                            @autoreleasepool {
                                MGCommandTestDelegate *delegate = [[MGCommandTestDelegate alloc] init];

                                [[delegate should] receive: @selector(commandExecuted)];
                                [[delegate should] receive: @selector(deallocCalled)];

                                [delegate executeSynchronousMGCommandGroup];
                            }
                        });
                    });

                    context(@"with asynchronous command", ^{
                        it(@"should dealloc after execution", ^{
                            @autoreleasepool {
                                MGCommandTestDelegate *delegate = [[MGCommandTestDelegate alloc] init];

                                [[delegate shouldEventually] receive: @selector(commandExecuted)];
                                [[delegate shouldEventually] receive: @selector(deallocCalled)];

                                [delegate executeAsynchronousMGCommandGroup];
                            }
                        });

                        it(@"should call the completeHandler on completion", ^{
                            MGCommandTestDelegate *delegate = [[MGCommandTestDelegate alloc] init];

                            [[delegate shouldEventually] receive: @selector(asyncCommandsCompleted)];

                            [delegate executeAsynchronousMGCommandGroup];
                        });
                    });


                });
            });
        });

        SPEC_END