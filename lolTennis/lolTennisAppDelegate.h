//
//  lolTennisAppDelegate.h
//  lolTennis
//
//  Created by Administrator on 8/5/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"
//@class lolTennisViewController;

@interface lolTennisAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	SplashViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

//@property (nonatomic, retain) IBOutlet lolTennisViewController *viewController;
@property (nonatomic, retain) IBOutlet SplashViewController *viewController;

@end
