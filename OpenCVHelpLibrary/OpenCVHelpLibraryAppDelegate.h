//
//  OpenCVHelpLibraryAppDelegate.h
//  OpenCVHelpLibrary
//
//  Created by sonson on 11/05/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpenCVHelpLibraryViewController;

@interface OpenCVHelpLibraryAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet OpenCVHelpLibraryViewController *viewController;

@end
