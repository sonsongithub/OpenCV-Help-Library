//
//  OpenCVHelpLibraryViewController.m
//  OpenCVHelpLibrary
//
//  Created by sonson on 11/05/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenCVHelpLibraryViewController.h"

#import "OpenCVHelpLibrary.h"

@implementation OpenCVHelpLibraryViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIImage *testImageGray = [UIImage imageNamed:@"testImageGrayScale.jpg"];
	UIImage *testImageRGB = [UIImage imageNamed:@"testImageRGB.jpg"];
	
	IplImage *testIplImageGray = [testImageGray createIplImage];
	IplImage *testIplImageRGB = [testImageRGB createIplImage];
	
	UIImage *testImageGrayDuplicated = [UIImage imageWithIplImage:testIplImageGray];
	UIImage *testImageRGBDuplicated = [UIImage imageWithIplImage:testIplImageRGB];

	[leftOutputImageView setImage:testImageGrayDuplicated];
	[rightOutputImageView setImage:testImageRGBDuplicated];
}

- (void)dealloc {
    [super dealloc];
}

@end
