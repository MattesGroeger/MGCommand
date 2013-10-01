#import <Foundation/Foundation.h>


@interface RetainGuardDelegate : NSObject

- (void)createObject;

- (void)createObjectAndRetain;

- (void)createObjectAndRetainAndRelease;

- (void)instanceReleased;

@end