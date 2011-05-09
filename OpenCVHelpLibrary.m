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
	IplImage *output = CGCreateIplImageWithCGImage(self.CGImage);
	return output;
}

+ (UIImage*)imageWithIplImage:(IplImage*)inputImage {
	CGImageRef source = CGCreateImageWithIplImage(inputImage);
	
	UIImage *output = [UIImage imageWithCGImage:source];
	CGImageRelease(source);
	return output;
}

@end

IplImage* CGCreateIplImageWithGrayScaleCGImage(CGImageRef imageRef) {
	
	int inputImageWidth = CGImageGetWidth(imageRef);
	int inputImageHeight = CGImageGetHeight(imageRef);
	
	IplImage* targetImage = cvCreateImage(cvSize(inputImageWidth, inputImageHeight), IPL_DEPTH_8U, 1);
	
	size_t bitsPerPixel_imageRef = CGImageGetBitsPerPixel(imageRef);
	size_t bytesPerRow_imageRef = CGImageGetBytesPerRow(imageRef);
	size_t bytesPerPixel = bitsPerPixel_imageRef / 8;
	CGImageAlphaInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	bitmapInfo = bitmapInfo & kCGBitmapByteOrderMask;
	
	CGDataProviderRef inputImageProvider = CGImageGetDataProvider(imageRef);
	
	CFDataRef data = CGDataProviderCopyData(inputImageProvider);
	
	unsigned char *pixelData = (unsigned char *) CFDataGetBytePtr(data);
	
	for (int y = 0; y < inputImageHeight; y++) {
		for (int x = 0; x < inputImageWidth; x++) {
			int offset = y * bytesPerRow_imageRef + x * bytesPerPixel;
			targetImage->imageData[y * targetImage->widthStep + x] = pixelData[offset];
		}
	}
	
	CFRelease(data);
	
	return targetImage;
}

IplImage* CGCreateIplImageWithGrayAlphaScaleCGImage(CGImageRef imageRef) {
	
	int inputImageWidth = CGImageGetWidth(imageRef);
	int inputImageHeight = CGImageGetHeight(imageRef);
	
	IplImage* targetImage = cvCreateImage(cvSize(inputImageWidth, inputImageHeight), IPL_DEPTH_8U, 1);
	
	size_t bitsPerPixel_imageRef = CGImageGetBitsPerPixel(imageRef);
	size_t bytesPerRow_imageRef = CGImageGetBytesPerRow(imageRef);
	size_t bytesPerPixel = bitsPerPixel_imageRef / 8;
	CGImageAlphaInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGImageAlphaInfo bitmapAlphaInfo = bitmapInfo & kCGBitmapAlphaInfoMask;
	bitmapInfo = bitmapInfo & kCGBitmapByteOrderMask;
	
	CGDataProviderRef inputImageProvider = CGImageGetDataProvider(imageRef);
	
	CFDataRef data = CGDataProviderCopyData(inputImageProvider);
	
	unsigned char *pixelData = (unsigned char *) CFDataGetBytePtr(data);
	
	if (bitmapAlphaInfo == kCGImageAlphaFirst) {
		for (int y = 0; y < inputImageHeight; y++) {
			for (int x = 0; x < inputImageWidth; x++) {
				int offset = y * bytesPerRow_imageRef + x * bytesPerPixel + 1;
				targetImage->imageData[y * targetImage->widthStep + x] = pixelData[offset];
			}
		}
	}
	else if (bitmapAlphaInfo == kCGImageAlphaLast) {
		for (int y = 0; y < inputImageHeight; y++) {
			for (int x = 0; x < inputImageWidth; x++) {
				int offset = y * bytesPerRow_imageRef + x * bytesPerPixel + 0;
				targetImage->imageData[y * targetImage->widthStep + x] = pixelData[offset];
			}
		}
	}
	else if (bitmapAlphaInfo == kCGImageAlphaPremultipliedFirst) {
		for (int y = 0; y < inputImageHeight; y++) {
			for (int x = 0; x < inputImageWidth; x++) {
				int offset = y * bytesPerRow_imageRef + x * bytesPerPixel + 1;
				targetImage->imageData[y * targetImage->widthStep + x] = pixelData[offset];
			}
		}
	}
	else if (bitmapAlphaInfo == kCGImageAlphaPremultipliedLast) {
		for (int y = 0; y < inputImageHeight; y++) {
			for (int x = 0; x < inputImageWidth; x++) {
				int offset = y * bytesPerRow_imageRef + x * bytesPerPixel + 0;
				targetImage->imageData[y * targetImage->widthStep + x] = pixelData[offset];
			}
		}
	}
	
	CFRelease(data);
	
	return targetImage;
}

IplImage* CGCreateIplImageWithRGBScaleCGImage(CGImageRef imageRef) {
	int inputImageWidth = CGImageGetWidth(imageRef);
	int inputImageHeight = CGImageGetHeight(imageRef);
	
	IplImage* targetImage = cvCreateImage(cvSize(inputImageWidth, inputImageHeight), IPL_DEPTH_8U, 3);
	
	size_t bytesPerRow_imageRef = CGImageGetBytesPerRow(imageRef);
	size_t bitsPerPixel_imageRef = CGImageGetBitsPerPixel(imageRef);
	size_t bytesPerPixel = bitsPerPixel_imageRef / 8;
	CGImageAlphaInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGImageAlphaInfo bitmapAlphaInfo = bitmapInfo & kCGBitmapAlphaInfoMask;
	bitmapInfo = bitmapInfo & kCGBitmapByteOrderMask;
	CGBitmapInfo byteOrderInfo = (bitmapInfo & kCGBitmapByteOrderMask);
	
	CGDataProviderRef inputImageProvider = CGImageGetDataProvider(imageRef);
	
	CFDataRef data = CGDataProviderCopyData(inputImageProvider);
	
	unsigned char *pixelData = (unsigned char *) CFDataGetBytePtr(data);
	
	if (bitmapAlphaInfo != kCGImageAlphaNone) 
		return NULL;
	
	if (byteOrderInfo != kCGBitmapByteOrder32Big)
		return NULL;
	
	for (int y = 0; y < inputImageHeight; y++) {
		for (int x = 0; x < inputImageWidth; x++) {
			int offset = y * bytesPerRow_imageRef + x * bytesPerPixel + 0;
			targetImage->imageData[y * targetImage->widthStep + 3 * x + 0] = pixelData[offset + 0];
			targetImage->imageData[y * targetImage->widthStep + 3 * x + 1] = pixelData[offset + 1];
			targetImage->imageData[y * targetImage->widthStep + 3 * x + 2] = pixelData[offset + 2];
		}
	}
	
	return targetImage;
}

IplImage* CGCreateIplImageWithRGBAScaleCGImageBigEndian(CGImageRef imageRef) {
	
	int inputImageWidth = CGImageGetWidth(imageRef);
	int inputImageHeight = CGImageGetHeight(imageRef);
	
	IplImage* targetImage = cvCreateImage(cvSize(inputImageWidth, inputImageHeight), IPL_DEPTH_8U, 3);
	
	size_t bytesPerRow_imageRef = CGImageGetBytesPerRow(imageRef);
	size_t bitsPerPixel_imageRef = CGImageGetBitsPerPixel(imageRef);
	size_t bytesPerPixel = bitsPerPixel_imageRef / 8;
	CGImageAlphaInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGImageAlphaInfo bitmapAlphaInfo = bitmapInfo & kCGBitmapAlphaInfoMask;
	bitmapInfo = bitmapInfo & kCGBitmapByteOrderMask;
	
	CGDataProviderRef inputImageProvider = CGImageGetDataProvider(imageRef);
	
	CFDataRef data = CGDataProviderCopyData(inputImageProvider);
	
	unsigned char *pixelData = (unsigned char *) CFDataGetBytePtr(data);
	
	if (bitmapAlphaInfo == kCGImageAlphaNone) {
		printf("Unexpected alpha type.\n");
		return NULL;
	}
	
	if (bitmapAlphaInfo == kCGImageAlphaFirst || bitmapAlphaInfo == kCGImageAlphaPremultipliedFirst || bitmapAlphaInfo == kCGImageAlphaNoneSkipFirst) {
		for (int y = 0; y < inputImageHeight; y++) {
			for (int x = 0; x < inputImageWidth; x++) {
				int offset = y * bytesPerRow_imageRef + x * bytesPerPixel + 0;
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 0] = pixelData[offset + 1];
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 1] = pixelData[offset + 2];
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 2] = pixelData[offset + 3];
			}
		}
	}
	else if (bitmapAlphaInfo == kCGImageAlphaLast || bitmapAlphaInfo == kCGImageAlphaPremultipliedLast || bitmapAlphaInfo == kCGImageAlphaNoneSkipLast) {
		for (int y = 0; y < inputImageHeight; y++) {
			for (int x = 0; x < inputImageWidth; x++) {
				int offset = y * bytesPerRow_imageRef + x * bytesPerPixel + 0;
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 0] = pixelData[offset + 0];
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 1] = pixelData[offset + 1];
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 2] = pixelData[offset + 2];
			}
		}
	}
	
	return targetImage;
}

IplImage* CGCreateIplImageWithRGBAScaleCGImageLittleEndian(CGImageRef imageRef) {
	
	int inputImageWidth = CGImageGetWidth(imageRef);
	int inputImageHeight = CGImageGetHeight(imageRef);
	
	IplImage* targetImage = cvCreateImage(cvSize(inputImageWidth, inputImageHeight), IPL_DEPTH_8U, 3);
	
	size_t bytesPerRow_imageRef = CGImageGetBytesPerRow(imageRef);
	size_t bitsPerPixel_imageRef = CGImageGetBitsPerPixel(imageRef);
	size_t bytesPerPixel = bitsPerPixel_imageRef / 8;
	CGImageAlphaInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGImageAlphaInfo bitmapAlphaInfo = bitmapInfo & kCGBitmapAlphaInfoMask;
	bitmapInfo = bitmapInfo & kCGBitmapByteOrderMask;
	
	CGDataProviderRef inputImageProvider = CGImageGetDataProvider(imageRef);
	
	CFDataRef data = CGDataProviderCopyData(inputImageProvider);
	
	unsigned char *pixelData = (unsigned char *) CFDataGetBytePtr(data);
	
	if (bitmapAlphaInfo == kCGImageAlphaNone) {
		printf("Unexpected alpha type.\n");
		return NULL;
	}
	
	if (bitmapAlphaInfo == kCGImageAlphaFirst || bitmapAlphaInfo == kCGImageAlphaPremultipliedFirst || bitmapAlphaInfo == kCGImageAlphaNoneSkipFirst) {
		for (int y = 0; y < inputImageHeight; y++) {
			for (int x = 0; x < inputImageWidth; x++) {
				int offset = y * bytesPerRow_imageRef + x * bytesPerPixel + 0;
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 2] = pixelData[offset + 1];
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 1] = pixelData[offset + 2];
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 0] = pixelData[offset + 3];
			}
		}
	}
	else if (bitmapAlphaInfo == kCGImageAlphaLast || bitmapAlphaInfo == kCGImageAlphaPremultipliedLast || bitmapAlphaInfo == kCGImageAlphaNoneSkipLast) {
		for (int y = 0; y < inputImageHeight; y++) {
			for (int x = 0; x < inputImageWidth; x++) {
				int offset = y * bytesPerRow_imageRef + x * bytesPerPixel + 0;
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 2] = pixelData[offset + 0];
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 1] = pixelData[offset + 1];
				targetImage->imageData[y * targetImage->widthStep + 3 * x + 0] = pixelData[offset + 2];
			}
		}
	}
	
	return targetImage;
}

IplImage* CGCreateIplImageWithCGImage(CGImageRef imageRef) {
	size_t bitsPerPixel_imageRef = CGImageGetBitsPerPixel(imageRef);
	size_t bytesPerPixel = bitsPerPixel_imageRef / 8;
	CGImageAlphaInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	bitmapInfo = bitmapInfo & kCGBitmapByteOrderMask;
	CGBitmapInfo byteOrderInfo = (bitmapInfo & kCGBitmapByteOrderMask);
	
	if (bytesPerPixel != 1 && bytesPerPixel != 2 && bytesPerPixel != 3 && bytesPerPixel != 4) {
		printf("Not supported image type.\n");
		return NULL;
	}
	
	if (bitmapInfo == kCGBitmapFloatComponents) {
		printf("Not supported image type.\n");
		return NULL;
	}
	
	// RGBA, ARGB
	if (bytesPerPixel == 4) {
		if (byteOrderInfo == kCGBitmapByteOrder32Big || byteOrderInfo == kCGBitmapByteOrderDefault) {
			return CGCreateIplImageWithRGBAScaleCGImageBigEndian(imageRef);
		}
		else if (byteOrderInfo == kCGBitmapByteOrder32Little || byteOrderInfo == kCGBitmapByteOrder32Host) {
			return CGCreateIplImageWithRGBAScaleCGImageLittleEndian(imageRef);
		}
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
	
	printf("Not supported image type.\n");
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
		printf("Not supported number of channels\n");
		return NULL;
	}	
	return NULL;
}