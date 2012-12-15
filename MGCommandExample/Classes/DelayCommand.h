#import <Foundation/Foundation.h>
#import "MGAsyncCommand.h"

@class ViewController;

@interface DelayCommand : NSObject <MGAsyncCommand>
{
	NSTimeInterval _delayInSeconds;
}

@property (nonatomic, strong) CommandCallback callback;

- (id)initWithDelayInSeconds:(NSTimeInterval)aDelayInSeconds;

@end