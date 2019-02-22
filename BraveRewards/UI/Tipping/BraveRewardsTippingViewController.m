/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsTippingViewController.h"
#import "BATTippingSelectionView.h"
#import "BATTippingOverviewView.h"
#import "BATBasicAnimationController.h"

// Temp:
#import "UIImage+Convenience.h"

@interface BraveRewardsTippingViewController () <UIViewControllerTransitioningDelegate, BATBasicAnimationControllerDelgate>
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) BATTippingOverviewView *overviewView;
@property (nonatomic) BATTippingSelectionView *tippingView;
@end

@implementation BraveRewardsTippingViewController

- (instancetype)init
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.transitioningDelegate = self;
    
    self.backgroundView = [[UIView alloc] init]; {
      self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
      self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.scrollView = [[UIScrollView alloc] init]; {
      self.scrollView.alwaysBounceVertical = YES;
      self.scrollView.showsVerticalScrollIndicator = NO;
      self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.overviewView = [[BATTippingOverviewView alloc] init];
    self.overviewView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tippingView = [[BATTippingSelectionView alloc] init]; {
      self.tippingView.layer.shadowRadius = 8.0;
      self.tippingView.layer.shadowOffset = CGSizeMake(0, -2);
      self.tippingView.layer.shadowOpacity = 0.35;
      self.tippingView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // FIXME: Remove fake data
    self.tippingView.walletBalanceCryptoLabel.text = @"BAT";
    self.tippingView.walletBalanceValueLabel.text = @"30";
    
    NSMutableArray<BATTippingAmount *> *amountOptions = [[NSMutableArray alloc] init];
    for (NSString *value in @[ @"1", @"5", @"10" ]) {
      BATTippingAmount *amount = [BATTippingAmount amountWithValue:value
                                                            crypto:@"BAT"
                                                       cryptoImage:[UIImage bat_imageNamed:@"bat"]
                                                       dollarValue:@"0.00 USD"];
      [amountOptions addObject:amount];
    }
    self.tippingView.amountOptions = amountOptions;
    self.tippingView.selectedAmountIndex = 1;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  [self.view addSubview:self.backgroundView];
  [self.view addSubview:self.scrollView];
  [self.scrollView addSubview:self.overviewView];
  [self.view addSubview:self.tippingView];
  
  [NSLayoutConstraint activateConstraints:@[
    [self.backgroundView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [self.backgroundView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.backgroundView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                            
    [self.tippingView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [self.tippingView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.tippingView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    
    [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [self.scrollView.contentLayoutGuide.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
    
    [self.overviewView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor constant:20.0],
    [self.overviewView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10.0],
    [self.overviewView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10.0],
    [self.overviewView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor constant:-10.0]
  ]];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  [self.tippingView layoutIfNeeded];
  self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.tippingView.bounds.size.height, 0);
}

#pragma mark -

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
    return UIInterfaceOrientationMaskPortrait;
  }
  return UIInterfaceOrientationMaskAll;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
  return [[BATBasicAnimationController alloc] initWithDirection:BATAnimationDirectionPresenting delegate:self];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
  return [[BATBasicAnimationController alloc] initWithDirection:BATAnimationDirectionDismissing delegate:self];
}

#pragma mark - BATBasicAnimationControllerDelgate

- (void)animatePresentation:(id<UIViewControllerContextTransitioning>)context
{
  [context.containerView addSubview:self.view];
  [context completeTransition:YES];
}

- (void)animateDismissal:(id<UIViewControllerContextTransitioning>)context
{
  [self.view removeFromSuperview];
  [context completeTransition:YES];
}

@end
