//
//  WXController.m
//  SimpleWeather
//
//  Created by 徐杨 on 15/7/1.
//  Copyright (c) 2015年 xuyang. All rights reserved.
//

#import "WXController.h"
#import "WXManager.h"

#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

@interface WXController()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;

@end

@implementation WXController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIImage *background = [UIImage imageNamed:@"bg"];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:background];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
    // Set Frame
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
    CGFloat inset = 20;
    
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    
    CGRect hiloFrame = CGRectMake(inset,
                                  (headerFrame.size.height-hiloHeight),
                                  (headerFrame.size.width-2*inset),
                                  hiloHeight);
    
    CGRect temperatureFrame = CGRectMake(inset,
                                         (headerFrame.size.height-hiloHeight-temperatureHeight),
                                         (headerFrame.size.width-2*inset),
                                         temperatureHeight);
    
    CGRect iconFrame = CGRectMake(inset,
                                  (headerFrame.size.height-hiloHeight-temperatureHeight-iconHeight),
                                  iconHeight,
                                  iconHeight);
    
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.origin.x += iconHeight+10;
    conditionsFrame.size.width = headerFrame.size.width-2*inset-iconHeight;
    
    CGRect cityFrame = CGRectMake(0, 20, headerFrame.size.width, 30);
    
    // Add View
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [header addSubview:temperatureLabel];
    
    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = @"0° / 0°";
    hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [header addSubview:hiloLabel];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:cityFrame];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"Loading...";
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:cityLabel];
    
    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
    conditionsLabel.textColor = [UIColor whiteColor];
    conditionsLabel.text = @"clear";
    [header addSubview:conditionsLabel];
    
    UIImage *iconImage = [UIImage imageNamed:@"weather-clear"];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = iconImage;
    [header addSubview:iconView];
    
    [[RACObserve([WXManager sharedManager], currentCondition)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(WXCondition *newCondition) {
         if (newCondition) {
             temperatureLabel.text = [NSString stringWithFormat:@"%.0f°",newCondition.temperature.floatValue];
             conditionsLabel.text = [newCondition.condition capitalizedString];
             cityLabel.text = [newCondition.locationName capitalizedString];
             
             iconView.image = [UIImage imageNamed:[newCondition imageName]];
         }
     }];
    
    [[WXManager sharedManager] findCurrentLocation];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    //TODO:Setup the cell
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
