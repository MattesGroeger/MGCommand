#import <Foundation/Foundation.h>

@class MGSequentialCommandGroup;


@interface AutoStartViewController : UIViewController
{
@private
	NSUInteger _commandCount;
	MGSequentialCommandGroup *_autoStartQueue;
}

@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) IBOutlet UILabel *enqueuedItemsLabel;
@property (nonatomic) IBOutlet UILabel *outputLabel;

@end