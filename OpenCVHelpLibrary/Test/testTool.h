//
//  testTool.h
//  OpenCVHelpLibrary
//
//  Created by sonson on 11/05/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenCVHelpLibrary.h"

int compareIplImage(IplImage *image1, IplImage *image2, int tolerance);
void dumpIplImage(IplImage *image);