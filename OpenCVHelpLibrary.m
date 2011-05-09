/*
 * OpenCV Help Library
 * OpenCVHelpLibrary.m
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

#import "OpenCVHelpLibrary.h"

#import "QuartzHelpLibrary.h"
#import <opencv/cv.h>

@implementation UIImage(OpenCV)

- (IplImage*)createIplImage {
	return NULL;
}

+ (UIImage*)imageWithIplImage:(IplImage*)inputImage {
	CGImageRef source = CGCreateImageWithIplImage(inputImage);
	
	UIImage *output = [UIImage imageWithCGImage:source];
	CGImageRelease(source);
	return output;
}

@end

IplImage* CGCreateIplImageWithGrayScaleCGImage(CGImageRef imageRef) {
	return NULL;
}

IplImage* CGCreateIplImageWithGrayAlphaScaleCGImage(CGImageRef imageRef) {
	return NULL;
}

IplImage* CGCreateIplImageWithRGBScaleCGImage(CGImageRef imageRef) {
	return NULL;
}

IplImage* CGCreateIplImageWithRGBAScaleCGImage(CGImageRef imageRef) {
	return NULL;
}

IplImage* CGCreateIplImageWithCGImage(CGImageRef imageRef) {
	size_t bitsPerPixel_imageRef = CGImageGetBitsPerPixel(imageRef);
	// size_t bytesPerRow_imageRef = CGImageGetBytesPerRow(imageRef);
	size_t bytesPerPixel = bitsPerPixel_imageRef / 8;
	CGImageAlphaInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGImageAlphaInfo bitmapAlphaInfo = bitmapInfo & kCGBitmapAlphaInfoMask;
	bitmapInfo = bitmapInfo & kCGBitmapByteOrderMask;
	CGBitmapInfo byteOrderInfo = (bitmapInfo & kCGBitmapByteOrderMask);
	
	if (bytesPerPixel != 1 && bytesPerPixel != 2 && bytesPerPixel != 3 && bytesPerPixel != 4) {
		printf("unsupported image file\n");
		return NULL;
	}
	
	if (bitmapInfo == kCGBitmapFloatComponents) {
		printf("unsupported image file\n");
		return NULL;
	}
	
	// RGBA, ARGB
	if (bytesPerPixel == 4) {
		return CGCreateIplImageWithRGBAScaleCGImage(imageRef);
	}
	
	// RGB
	if (bytesPerPixel == 3) {
		return CGCreateIplImageWithRGBScaleCGImage(imageRef);
	}
	
	// Gray + alpha
	if (bytesPerPixel == 2) {
		return CGCreateIplImageWithGrayAlphaScaleCGImage(imageRef);
	}
	
	// Gray
	if (bytesPerPixel == 1) {
		return CGCreateIplImageWithGrayScaleCGImage(imageRef);
	}
	
	return NULL;
}

CGImageRef CGCreateImageWithIplImage(IplImage* inputImage) {
	if (inputImage->depth != IPL_DEPTH_8U) {
		printf("Not supported depth type.\n");
		return NULL;
	}
	
	if (inputImage->nChannels == 1) {
		CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
		CGContextRef context = CGBitmapContextCreate(inputImage->imageData, inputImage->width, inputImage->height, 8, inputImage->widthStep, grayColorSpace, kCGImageAlphaNone);
		CGImageRef image = CGBitmapContextCreateImage(context);
		CGColorSpaceRelease(grayColorSpace);
		return image;
	}
	if (inputImage->nChannels == 3) {
		CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
		
		unsigned char *rgbPixel = (unsigned char*)malloc(sizeof(unsigned char) * inputImage->width * inputImage->height * 4);
		
		for (int y = 0; y < inputImage->height; y++) {
			for (int x = 0; x < inputImage->width; x++) {
				rgbPixel[y * inputImage->width * 4 + 4 * x + 0] = inputImage->imageData[y * inputImage->width * 3 + 3 * x + 0];
				rgbPixel[y * inputImage->width * 4 + 4 * x + 1] = inputImage->imageData[y * inputImage->width * 3 + 3 * x + 1];
				rgbPixel[y * inputImage->width * 4 + 4 * x + 2] = inputImage->imageData[y * inputImage->width * 3 + 3 * x + 2];
			}
		}
		
		CGContextRef context = CGBitmapContextCreate(rgbPixel, inputImage->width, inputImage->height, 8, inputImage->width * 4, rgbColorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big);
		CGImageRef image = CGBitmapContextCreateImage(context);
		CGColorSpaceRelease(rgbColorSpace);
		free(rgbPixel);
		return image;
	}
	else {
		printf("Not supported depth type.\n");
		return NULL;
	}	
	return NULL;
}