OpenCV Help Library=======![sample image](http://sonson.jp/wp/wp-content/uploads/2011/05/sample_image_ohl.png)This library helps OpenCV programming on iOS. Currently, it includes a mutual converter UIImage <->IplImage.You can convert them mutually without complicated codes.### Sample code - Covert IplImage and CGImage	// Convert to CGImageRef from IplImage	CGImageRef p = CGCreateImageWithIplImage(originalSourceImage);	// Convert to IplImage(RGB) from CGImageRef	IplImage *duplicatedFromCGImage = CGCreateIplImageWithCGImage(p);### Sample code - Load IplImage	NSString *path = [[NSBundle mainBundle] pathForResource:@"testImage_Gray_PNG24.png" ofType:nil];    IplImage *original = cvLoadImage([path UTF8String], CV_LOAD_IMAGE_COLOR);License======= * BSD license How to use======= * Import OpenCVHelpLibrary.h/m into your project. UIImage OpenCV Help Library Additions Reference=======	+ (UIImage*)imageWithIplImage:(IplImage*)inputImage;###Parameters###inputImageThe image to be converted to UIImage.###Return valueAn autoreleased new bitmap image as UIImage.###DiscussionNone.	- (IplImage*)createIplImage;###Return valueA new IpImage bitmap image. You are responsible for releasing this object by calling cvReleaseImage.###DiscussionOutput image is 24bit color.OpenCV Help Library Reference=======	IplImage* CGCreateIplImageWithCGImage(		CGImageRef imageRef,		int iscolor	);###Parameters###inputImageRefThe image to be converted to IplImage.###iscolorOutput IplImage's color type. You can use only CV\_LOAD\_IMAGE\_GRAYSCALE, CV\_LOAD\_IMAGE\_COLOR or CV\_LOAD\_IMAGE\_ANYCOLOR and MUST NOT USE(NOT SUPPORTED) any combinations of these types. Specific color type of the loaded image: if , the loaded image is forced to be a 3-channel color image; if CV\_LOAD\_IMAGE\_GRAYSCALE, the loaded image is forced to be grayscale; if , the loaded image will be loaded as is (note that in the current implementation the alpha channel, if CV\_LOAD\_IMAGE\_ANYCOLOR, is stripped from the output image, e.g. 4-channel RGBA image will be loaded as RGB).###Return valueA new IpImage bitmap image. You are responsible for releasing this object by calling cvReleaseImage.###DiscussionNone.	CGImageRef CGCreateImageWithIplImage(		IplImage* inputImage	);###Parameters###inputImageThe image to be converted to CGImage.###Return valueA new Quartz bitmap image. You are responsible for releasing this object by calling CGImageRelease.###DiscussionNone.	IplImage* cvLoadImage(const char* filename, int iscolor);###Parameters###filenameThe full or relative pathname of your image file.###iscolorOutput IplImage's color type. You can use only CV\_LOAD\_IMAGE\_GRAYSCALE, CV\_LOAD\_IMAGE\_COLOR or CV\_LOAD\_IMAGE\_ANYCOLOR and MUST NOT USE(NOT SUPPORTED) any combinations of these types. Specific color type of the loaded image: if , the loaded image is forced to be a 3-channel color image; if CV\_LOAD\_IMAGE\_GRAYSCALE, the loaded image is forced to be grayscale; if , the loaded image will be loaded as is (note that in the current implementation the alpha channel, if CV\_LOAD\_IMAGE\_ANYCOLOR, is stripped from the output image, e.g. 4-channel RGBA image will be loaded as RGB).###Return valueA new IpImage bitmap image. You are responsible for releasing this object by calling cvReleaseImage.###DiscussionThis function supports the following file formats only,1. JPEG files - JPEG, JPG, JPE2. Portable Network Graphics - PNGConstants=======	//#define CV_LOAD_IMAGE_UNCHANGED  	-1		// not supported	#define CV_LOAD_IMAGE_GRAYSCALE   	0	#define CV_LOAD_IMAGE_COLOR       	1	//#define CV_LOAD_IMAGE_ANYDEPTH    	2		// not supported	#define CV_LOAD_IMAGE_ANYCOLOR    	4	###CV\_LOAD\_IMAGE\_GRAYSCALE###CV\_LOAD\_IMAGE\_COLOR###CV\_LOAD\_IMAGE\_ANYCOLORBlog======= * [sonson.jp][]Sorry, Japanese only....Dependency======= * [Quartz Help Library][][sonson.jp]: http://sonson.jp[Quartz Help Library]: https://github.com/sonsongithub/Quartz-Help-Library