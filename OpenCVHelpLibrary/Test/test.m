/*
 * OpenCV Help Library
 * test.m
 *
 * Copyright (c) Yuichi YOSHIDA, 11/05/08
 * All rights reserved.
 * 
 * BSD License
 *
 * Redistribution and use in source and binary forms, with or without modification, are 
 * permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright notice, this list of
 *  conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this list
 *  of conditions and the following disclaimer in the documentation and/or other materia
 * ls provided with the distribution.
 * - Neither the name of the "Yuichi Yoshida" nor the names of its contributors may be u
 * sed to endorse or promote products derived from this software without specific prior 
 * written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY E
 * XPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES O
 * F MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SH
 * ALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENT
 * AL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROC
 * UREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS I
 * NTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRI
 * CT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF T
 * HE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "test.h"

#import "testTool.h"

void makeTestPixelData(unsigned char**pixel, int width, int height, int bytesPerPixel) {
	unsigned char* p = (unsigned char*)malloc(sizeof(unsigned char) * width * height * bytesPerPixel);
	// make test pattern
	if (bytesPerPixel == 1) {
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				if (y <= height / 2 && x <= width / 2) {
					p[y * width + x] = 0;
				}
				if (y <= height / 2 && x > width / 2) {
					p[y * width + x] = 85;
				}
				if (y > height / 2 && x <= width / 2) {
					p[y * width + x] = 170;
				}
				if (y > height / 2 && x > width / 2) {
					p[y * width + x] = 255;
				}
			}
		}
	}
	else if (bytesPerPixel == 3) {
		for (int x = 0; x < width; x++) {
			for (int y = 0; y < height; y++) {
				if (y <= height / 2 && x <= width / 2) {
					p[y * width * 3 + x * 3 + 0] = 255;
					p[y * width * 3 + x * 3 + 1] = 0;
					p[y * width * 3 + x * 3 + 2] = 0;
				}
				else if (y <= height / 2 && x > width / 2) {
					p[y * width * 3 + x * 3 + 0] = 0;
					p[y * width * 3 + x * 3 + 1] = 255;
					p[y * width * 3 + x * 3 + 2] = 0;
				}
				else if (y > height / 2 && x <= width / 2) {
					p[y * width * 3 + x * 3 + 0] = 0;
					p[y * width * 3 + x * 3 + 1] = 0;
					p[y * width * 3 + x * 3 + 2] = 255;
				}
				else if (y > height / 2 && x > width / 2) {
					p[y * width * 3 + x * 3 + 0] = 255;
					p[y * width * 3 + x * 3 + 1] = 255;
					p[y * width * 3 + x * 3 + 2] = 255;
				}
			}
		}
	}
	else {
		
	}
	*pixel = p;
}

void testLoadImage() {
	IplImage *original = cvLoadImage([[[NSBundle mainBundle] pathForResource:@"testImage_Gray_JPG24.jpg" ofType:nil] UTF8String], CV_LOAD_IMAGE_ANYCOLOR);
	printf("testLoadImage OK\n");
}

void testIplImageConvert(int bytesPerPixel) {
	// Original pixel data
	int width = 32;
	int height = 32;
	int tolerance = 2;
	unsigned char* original = NULL;
	
	// Make image data
	makeTestPixelData(&original, width, height, bytesPerPixel);
	
	// Copy pixel array to IplImage(RGB)
	IplImage* originalSourceImage = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, bytesPerPixel);
	for (int y = 0; y < height; y++) {
		unsigned char *source = original + y * width * bytesPerPixel;
		unsigned char *destination = (unsigned char*)originalSourceImage->imageData + y * originalSourceImage->widthStep;
		memcpy(destination, source, sizeof(unsigned char) * width * 3);
	}
	
	// Convert to CGImageRef from IplImage
	CGImageRef p = CGCreateImageWithIplImage(originalSourceImage);
	
	// Convert to IplImage(RGB) from CGImageRef
	IplImage *duplicatedFromCGImage = CGCreateIplImageWithCGImage(p);
	
	// Test
	assert(compareIplImage(duplicatedFromCGImage, originalSourceImage, tolerance));
	
	// release
	free(original);
	CGImageRelease(p);
	cvReleaseImage(&duplicatedFromCGImage);
	cvReleaseImage(&originalSourceImage);
	
	printf("testIplImageConvert bytesPerPixel=%d OK\n", bytesPerPixel);
}

void test() {
	printf("OpenCV Help Library Test\n\n");
	
	testIplImageConvert(1);
	testIplImageConvert(3);
}