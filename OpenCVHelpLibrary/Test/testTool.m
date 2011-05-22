//
//  testTool.m
//  OpenCVHelpLibrary
//
//  Created by sonson on 11/05/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "testTool.h"

void dumpPixelArray(unsigned char *pixel, int width, int height, int bytesPerPixel, DUMP_PIXEL_FORMAT type) {
	// make test pattern
	if (type == DUMP_PIXEL_HEX) {
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				for (int i = 0; i < bytesPerPixel; i++) {
					printf("%02x", pixel[y * width * bytesPerPixel + x * bytesPerPixel + i]);
				}
				printf(" ");
			}
			printf("\n");
		}
	}
	else {
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width/2; x++) {
				for (int i = 0; i < bytesPerPixel; i++) {
					printf("%03d", pixel[y * width * bytesPerPixel + x * bytesPerPixel + i]);
				}
				printf(" ");
			}
			printf("\n");
		}
	}
}

int compareBuffers(unsigned char* b1, unsigned char *b2, int length, int tolerance) {
	for (int i = 0; i < length; i++) {
		if (abs(*(b1 + i) - *(b2 + i)) > tolerance) {
			printf("diff = %d (%02X) (%02X)\n", *(b1 + i) - *(b2 + i), *(b1 + i), *(b2 + i));
			return 0;	
		}
	}
	return 1;
}

int compareBuffersWithXandY(unsigned char* b1, unsigned char *b2, int width, int height, int bytesPerPixel, int tolerance) {
	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			for (int i = 0; i < bytesPerPixel; i++) {
				int offset = (y * width + x) * bytesPerPixel + i;
				unsigned char v1 = *(b1 + offset);
				unsigned char v2 = *(b2 + offset);
				if (abs(v1 - v2) > tolerance) {
					printf("%d,%d(%d)....%02x vs %02x\n", x, y, i, v1, v2);	
					return 0;
				}
			}
		}
	}
	return 1;
}

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
