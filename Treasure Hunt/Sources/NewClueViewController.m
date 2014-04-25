
#import "NewClueViewController.h"
#import "UIImage+ImageEffects.h"

@interface NewClueViewController ()
@property (nonatomic, weak) IBOutlet UIView *contentView;
@end

@implementation NewClueViewController
{
	UIImageView *_imageView;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.textView.text = @"";

	#if CUSTOM_APPEARANCE
	UIImage *buttonImage = [[UIImage imageNamed:@"BarButtonItem-Portrait"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)];

	[self.cancelButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.cancelButton setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
	self.cancelButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
	self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];

	[self.submitButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.submitButton setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
	self.submitButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
	self.submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	
	self.textView.textColor = DarkTextColor;
	self.contentView.backgroundColor = [UIColor clearColor];

	_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClueSheet"]];
	[self.view insertSubview:_imageView atIndex:0];
	#endif
    self.contentView.layer.cornerRadius = 6.0f;
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView insertSubview:_imageView atIndex:0];
    self.contentView.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.textView becomeFirstResponder];
    if ([self.view respondsToSelector:@selector(setTintAdjustmentMode:)]) {
        self.view.window.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    }
    [self updateImageView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.view.window.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		self.contentView.frame = CGRectMake((self.view.bounds.size.width - 240.0f)/2.0f, -10.0f, 240.0f, 155.0f);

		#if CUSTOM_APPEARANCE
		_imageView.frame = CGRectMake((self.view.bounds.size.width - 280.0f)/2.0f, -20.0f, 280.0f, 205.0f);
		#endif
	} else {
		self.contentView.frame = CGRectMake((self.view.bounds.size.width - 240.0f)/2.0f, 40.0f, 240.0f, 180.0f);

		#if CUSTOM_APPEARANCE
		_imageView.frame = CGRectMake((self.view.bounds.size.width - 280.0f)/2.0f, 30.0f, 280.0f, 205.0f);
		#endif
	}
}

- (void)updateImageView
{
    UIView *snapshotView = [self.parentViewController.view resizableSnapshotViewFromRect:self.contentView.frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    
    //
    UIGraphicsBeginImageContextWithOptions(self.contentView.bounds.size, YES, 0.0f);
    BOOL result = [snapshotView drawViewHierarchyInRect:self.contentView.bounds afterScreenUpdates:YES];
    UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (result) {
        UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
        UIImage *blurredImage = [snapShotImage applyBlurWithRadius:4 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
        _imageView.image = blurredImage;
    }
    
}

@end
