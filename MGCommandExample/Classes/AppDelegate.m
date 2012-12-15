#import "AppDelegate.h"

#import "ViewController.h"
#import "Objection.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	JSObjectionInjector *injector = [JSObjection createInjector];
	[JSObjection setDefaultInjector:injector];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.viewController = [injector getObject:[ViewController class]];
	self.window.rootViewController = self.viewController;

	[self.window makeKeyAndVisible];

    return YES;
}

@end
