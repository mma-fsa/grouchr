//
//  ImageViewerViewController.m
//  Grouchr
//
//  Created by Mike on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageViewerViewController.h"

@implementation ImageViewerViewController
@synthesize imageURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"View Image";
    
    [self.view setBackgroundColor: [UIColor lightGrayColor]];
    
    if (imageURL != nil) {
        image = [UIImage imageWithData: [NSData dataWithContentsOfURL: imageURL]];
        viewer = [[UIImageView alloc] initWithImage: image];
        [viewer sizeToFit];

        scroller = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 90.0)];
        scroller.contentSize = viewer.frame.size;
        
        float minZoom1 = ((float)(scroller.frame.size.height)) / ((float)(viewer.frame.size.height));
        float minZoom2 = ((float)(scroller.frame.size.width)) / ((float)(viewer.frame.size.width));
        scroller.minimumZoomScale = (minZoom1 < minZoom2)? minZoom1 : minZoom2;
        scroller.maximumZoomScale = 1.5;
        scroller.delegate = self;
        scroller.clipsToBounds = YES;
        scroller.zoomScale = (minZoom1 < minZoom2)? minZoom2 : minZoom1;;
        [scroller addSubview: viewer];
        
        self.view.autoresizesSubviews = YES;
        [self.view addSubview: scroller];
    }
    else {
        [[[UIAlertView alloc] 
          initWithTitle: @"Error" message:@"No image data was found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return viewer;
}

@end
