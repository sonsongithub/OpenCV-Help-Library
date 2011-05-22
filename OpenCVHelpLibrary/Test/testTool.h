//
//  testTool.h
//  OpenCVHelpLibrary
//
//  Created by sonson on 11/05/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenCVHelpLibrary.h"

typedef enum {
	DUMP_PIXEL_HEX = 0,
	DUMP_PIXEL_DEC = 1
}DUMP_PIXEL_FORMAT;

void dumpPixelArray(unsigned char *pixel, int width, int height, int bytesPerPixel, DUMP_PIXEL_FORMAT type);
int compareBuffers(unsigned char* b1, unsigned char *b2, int length, int tolerance);
int compareBuffersWithXandY(unsigned char* b1, unsigned char *b2, int width, int height, int bytesPerPixel, int tolerance);
int compareIplImage(IplImage *image1, IplImage *image2, int tolerance);
void dumpIplImage(IplImage *image);