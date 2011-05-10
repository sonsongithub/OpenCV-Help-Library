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

#import "OpenCVHelpLibrary.h"

int compareIplImage(IplImage *image1, IplImage *image2, int tolerance) {
	// check both image types
	if (image1->width != image2->width) {
		printf("Width not matched.\n");
		return 0;
	}
	if (image1->height != image2->height) {
		printf("Height not matched.\n");
		return 0;
	}
	if (image1->nChannels != image2->nChannels) {
		printf("Image channels not matched.\n");
		return 0;
	}
	if (image1->depth != image2->depth) {
		printf("Image depth type not matched.\n");
		return 0;
	}
	if (image1->nChannels != 1 && image1->nChannels !=3) {
		printf("Not supported number of channels.\n");
		return 0;
	}
	
	// compare two pixel arrays
	if (image1->nChannels == 1) {
		for (int y = 0; y < image1->height; y++) {
			for (int x = 0; x < image1->width; x++) {
				unsigned char b1 = (unsigned char)*(image1->imageData + y * image1->widthStep + x);
				unsigned char b2 = (unsigned char)*(image2->imageData + y * image2->widthStep + x);
				if (abs(b1 - b2) > tolerance) {
					return 0;	
				}
				
			}
		}
	}
	
	if (image1->nChannels == 3) {
		for (int y = 0; y < image1->height; y++) {
			for (int x = 0; x < image1->width; x++) {
				for (int k = 0; k < 3; k++) {
					unsigned char b1 = (unsigned char)*(image1->imageData + y * image1->widthStep + 3 * x + k);
					unsigned char b2 = (unsigned char)*(image2->imageData + y * image2->widthStep + 3 * x + k);
					if (abs(b1 - b2) > tolerance) {
						return 0;	
					}
				}
			}
		}
	}
	return 1;
}

void dumpIplImage(IplImage *image) {
	// make test pattern
	
	if (image->depth != IPL_DEPTH_8U) {
		printf("Not supported depth type.\n");
		return;
	}
	
	if (image->nChannels == 1) {
		for (int y = 0; y < image->height; y++) {
			for (int x = 0; x < image->width; x++) {
				printf("%02x ", (unsigned char)image->imageData[y * image->widthStep + x + 0]);
			}
			printf("\n");
		}
	}
	if (image->nChannels == 3) {
		for (int y = 0; y < image->height; y++) {
			for (int x = 0; x < image->width; x++) {
				printf("%02x%02x%02x ", (unsigned char)image->imageData[y * image->widthStep + 3 * x + 0], (unsigned char)image->imageData[y * image->widthStep + 3 * x + 1], (unsigned char)image->imageData[y * image->widthStep + 3 * x + 2]);
			}
			printf("\n");
		}
	}

}

void testInCaseSourceIsGrayBuffer() {
	printf("\n");
	printf("Test for pixel arrays(Gray scale) -> IplImage -> CGImage(UIImage) -> IplImage.\n");
	
	// original pixel data
	int originalWidth = 32;
	int originalHeight = 32;
	unsigned char* original = (unsigned char*)malloc(sizeof(unsigned char) * originalWidth * originalHeight);
	
	// make test pattern
	for (int y = 0; y < originalHeight; y++) {
		for (int x = 0; x < originalWidth; x++) {
			if (y <= originalHeight / 2 && x <= originalWidth / 2) {
				original[y * originalWidth + x] = 0;
			}
			if (y <= originalHeight / 2 && x > originalWidth / 2) {
				original[y * originalWidth + x] = 85;
			}
			if (y > originalHeight / 2 && x <= originalWidth / 2) {
				original[y * originalWidth + x] = 170;
			}
			if (y > originalHeight / 2 && x > originalWidth / 2) {
				original[y * originalWidth + x] = 255;
			}
		}
	}
	
	// Convert to IplImage(Gray)
	IplImage* originalSourceImage = cvCreateImage(cvSize(originalWidth, originalHeight), IPL_DEPTH_8U, 1);
	for (int y = 0; y < originalHeight; y++) {
		unsigned char *source = original + y * originalWidth;
		unsigned char *destination = (unsigned char*)originalSourceImage->imageData + y * originalSourceImage->widthStep;
		memcpy(destination, source, sizeof(unsigned char) * originalWidth);
	}
	
	// Convert to CGImageRef from IplImage
	CGImageRef p = CGCreateImageWithIplImage(originalSourceImage);
	
	// Convert to IplImage(RGB) from CGImageRef
	IplImage *duplicatedFromCGImage = CGCreateIplImageWithCGImage(p);
	
	// confirm
	printf("->Pixel arrays(Gray scale) -> IplImage -> CGImage -> IplImage.\n");
	if (compareIplImage(duplicatedFromCGImage, originalSourceImage, 1)) {
		printf("->OK\n");
	}
	else {
		printf("->Faild\n");
	}
	
	// Convert to UIImage from IplImage
	UIImage *uiimage = [UIImage imageWithIplImage:originalSourceImage];
	
	// Convert to IplImage(RGB) from CGImageRef
	IplImage *duplicatedFromUIImage =[uiimage createIplImage];
	
	// confirm
	printf("->Pixel arrays(Gray scale) -> IplImage -> UIImage -> IplImage.\n");
	if (compareIplImage(duplicatedFromUIImage, originalSourceImage, 1)) {
		printf("->OK\n");
	}
	else {
		printf("->Faild\n");
	}
	
	// release all instances
	CGImageRelease(p);
	cvReleaseImage(&duplicatedFromCGImage);
	cvReleaseImage(&duplicatedFromUIImage);
	cvReleaseImage(&originalSourceImage);
}

void testInCaseSourceIsRGBBuffer() {
	printf("\n");
	printf("Test for pixel arrays(RGB) -> IplImage -> CGImage(UIImage) -> IplImage.\n");
	
	// original pixel data
	int originalWidth = 32;
	int originalHeight = 32;
	unsigned char* original = (unsigned char*)malloc(sizeof(unsigned char) * originalWidth * originalHeight * 3);
	
	// make test pattern
	for (int x = 0; x < originalWidth; x++) {
		for (int y = 0; y < originalHeight; y++) {
			if (y <= originalHeight / 2 && x <= originalWidth / 2) {
				original[y * originalWidth * 3 + x * 3 + 0] = 255;
				original[y * originalWidth * 3 + x * 3 + 1] = 0;
				original[y * originalWidth * 3 + x * 3 + 2] = 0;
			}
			else if (y <= originalHeight / 2 && x > originalWidth / 2) {
				original[y * originalWidth * 3 + x * 3 + 0] = 0;
				original[y * originalWidth * 3 + x * 3 + 1] = 255;
				original[y * originalWidth * 3 + x * 3 + 2] = 0;
			}
			else if (y > originalHeight / 2 && x <= originalWidth / 2) {
				original[y * originalWidth * 3 + x * 3 + 0] = 0;
				original[y * originalWidth * 3 + x * 3 + 1] = 0;
				original[y * originalWidth * 3 + x * 3 + 2] = 255;
			}
			else if (y > originalHeight / 2 && x > originalWidth / 2) {
				original[y * originalWidth * 3 + x * 3 + 0] = 255;
				original[y * originalWidth * 3 + x * 3 + 1] = 255;
				original[y * originalWidth * 3 + x * 3 + 2] = 255;
			}
		}
	}
	
	// Convert to IplImage(RGB)
	IplImage* originalSourceImage = cvCreateImage(cvSize(originalWidth, originalHeight), IPL_DEPTH_8U, 3);
	for (int y = 0; y < originalHeight; y++) {
		unsigned char *source = original + y * originalWidth * 3;
		unsigned char *destination = (unsigned char*)originalSourceImage->imageData + y * originalSourceImage->widthStep;
		memcpy(destination, source, sizeof(unsigned char) * originalWidth * 3);
	}
	
	// Convert to CGImageRef from IplImage
	CGImageRef p = CGCreateImageWithIplImage(originalSourceImage);
	
	// Convert to IplImage(RGB) from CGImageRef
	IplImage *duplicatedFromCGImage = CGCreateIplImageWithCGImage(p);
	
	// confirm
	printf("->Pixel arrays(RGB) -> IplImage -> CGImage -> IplImage.\n");
	if (compareIplImage(duplicatedFromCGImage, originalSourceImage, 1)) {
		printf("->OK\n");
	}
	else {
		printf("->Faild\n");
	}
	
	// Convert to UIImage from IplImage
	UIImage *uiimage = [UIImage imageWithIplImage:originalSourceImage];
	
	// Convert to IplImage(RGB) from CGImageRef
	IplImage *duplicatedFromUIImage =[uiimage createIplImage];
	
	// confirm
	printf("->Pixel arrays(RGB) -> IplImage -> UIImage -> IplImage.\n");
	if (compareIplImage(duplicatedFromUIImage, originalSourceImage, 1)) {
		printf("->OK\n");
	}
	else {
		printf("->Faild\n");
	}
	
	// release all instances
	CGImageRelease(p);
	cvReleaseImage(&duplicatedFromCGImage);
	cvReleaseImage(&duplicatedFromUIImage);
	cvReleaseImage(&originalSourceImage);
}

void testLoadImage() {
	IplImage *original = cvLoadImage([[[NSBundle mainBundle] pathForResource:@"testImageGrayScale.jpg" ofType:nil] UTF8String], CV_LOAD_IMAGE_ANYCOLOR);
}

void test() {
	printf("OpenCV Help Library Test\n\n");
	
	printf("---------->test\n");
	printf("- (IplImage*)createIplImage;\n");
	printf("+ (UIImage*)imageWithIplImage:(IplImage*)inputImage;\n");
	printf("IplImage* CGCreateIplImageWithCGImage(CGImageRef inputImageRef);\n");
	printf("CGImageRef CGCreateImageWithIplImage(IplImage* inputImage);\n");
	
	testInCaseSourceIsGrayBuffer();
	testInCaseSourceIsRGBBuffer();
	
	printf("\n---------->cvLoadImage wrapper test\n");
	testLoadImage();
}