//
//  ChartsViewController.m
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/9/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import "ChartsViewController.h"

const float LOWER_BOUND_BLUE = 50.0f;
const float UPPER_BOUND_BLUE = 215.0f;

@interface ChartsViewController ()
{
    UIButton *topTen;
    UIButton *topTwenty;
    UIButton *topThirty;
    
    NSArray *highestPaidPlayersByYearList;
    CGFloat maxCapCharge;
    CGFloat minCapCharge;
    CGFloat capChargeRange;
    int year;
    int limit;
}
@property JBBarChartView *barChartView;
//@property ChartsHeaderFooterView *header;
@property UIView *header;
@property UILabel *playerLabel;
@property UIView *footer;
@property UIView *xAxis;
@end

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    year = 2015;
    limit = 10;
    //get data
    NSString *sql = [NSString stringWithFormat: @"select c.*, p.*, t.* from yearly_contract c inner join player p on c.player = p.id inner join team t on c.team = t.id where c.year = %i order by c.cap_charge desc limit 10", year];
    DbHandler *handler = [DbHandler getInstance];
    highestPaidPlayersByYearList = [[NSArray alloc]initWithArray:[handler query:sql withCallback:[Contract getContractResolver ]]];
    
    maxCapCharge = [[[highestPaidPlayersByYearList objectAtIndexedSubscript:0]capCharge]floatValue];
    minCapCharge = [[[highestPaidPlayersByYearList objectAtIndexedSubscript:[highestPaidPlayersByYearList count]-1]capCharge]floatValue];
    capChargeRange = maxCapCharge - minCapCharge;
    
    //initialize chart
    [self prepareChart];
}

-(void)prepareChart{
    //generate chart
    self.barChartView = [[JBBarChartView alloc] init];
    self.barChartView.dataSource = self;
    self.barChartView.delegate = self;
    self.barChartView.frame = CGRectMake(60.0f, 40.0f, self.view.frame.size.width-60.0f, self.view.frame.size.height-100.0f);
    self.barChartView.backgroundColor = [UIColor clearColor];
    [self.barChartView setMaximumValue: maxCapCharge];
    [self.barChartView setMinimumValue:0.0f];
    [self.view addSubview:self.barChartView];
    
    //Header / Footer
//    self.header = [[ChartsHeaderFooterView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.barChartView.frame.size.width, 40.0f) title:@"2015" backgroundColor:[UIColor greenColor]];
//    [self.header.graphSelectYearButton addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    
    self.header = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.barChartView.frame.size.width, 40.0f)];
    
    //create header buttons
    topTen = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, self.barChartView.frame.size.width/3.0f, 40.0f)];
    [topTen setTitle:@"Top 10" forState:UIControlStateNormal];
    [topTen setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [topTen setTitleColor:[UIColor colorWithWhite:0.5f alpha:0.9f] forState:UIControlStateHighlighted];
    [topTen setTitleColor:[UIColor colorWithWhite:0.5f alpha:1.0f] forState:UIControlStateSelected];
    [topTen addTarget:self action:@selector(topTenFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    topTwenty = [[UIButton alloc]initWithFrame:CGRectMake(self.barChartView.frame.size.width/3.0f, 0.0, self.barChartView.frame.size.width/3.0f, 40.0f)];
    [topTwenty setTitle:@"Top 20" forState:UIControlStateNormal];
    [topTwenty setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [topTwenty setTitleColor:[UIColor colorWithWhite:0.5f alpha:0.9f] forState:UIControlStateHighlighted];
    [topTwenty setTitleColor:[UIColor colorWithWhite:0.5f alpha:1.0f] forState:UIControlStateSelected];
    [topTwenty addTarget:self action:@selector(topTwentyFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    topThirty = [[UIButton alloc]initWithFrame:CGRectMake(self.barChartView.frame.size.width/3.0f * 2.0f, 0.0, self.barChartView.frame.size.width/3.0f, 40.0f)];
    [topThirty setTitle:@"Top 30" forState:UIControlStateNormal];
    [topThirty setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [topThirty setTitleColor:[UIColor colorWithWhite:0.5f alpha:0.9f] forState:UIControlStateHighlighted];
    [topThirty setTitleColor:[UIColor colorWithWhite:0.5f alpha:1.0f] forState:UIControlStateSelected];
    [topThirty addTarget:self action:@selector(topThirtyFilter:) forControlEvents:UIControlEventTouchUpInside];

    [self.header addSubview:topTen];
    [self.header addSubview:topTwenty];
    [self.header addSubview:topThirty];
    
    [self.barChartView setHeaderView:self.header];
    //end create header buttons
    
    self.footer = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.barChartView.bounds.size.width, 100.0f)];
    [self.footer setBackgroundColor:[UIColor whiteColor]];
    self.playerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.footer.frame.size.width, 50.0f)];
    self.playerLabel.textColor = [UIColor blackColor];
    self.playerLabel.text = @"";
    self.playerLabel.textAlignment = NSTextAlignmentCenter;
    [self.playerLabel layoutIfNeeded];
    [self.playerLabel setFont:scFontHeaderSubtitle];
    [self.footer addSubview:self.playerLabel];
    [self.barChartView setFooterView:self.footer];
    
    [self addXAxis];
    
    //load table
    [self.barChartView reloadData];
    
    //add swipe gesture recognizers
    _swipeGestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(wasSwiped:)];
    [_swipeGestureRight setDirection: UISwipeGestureRecognizerDirectionRight];
    _swipeGestureRight.numberOfTouchesRequired = 1;
    _swipeGestureRight.delegate = self;
    
    _swipeGestureLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(wasSwiped:)];
    [_swipeGestureLeft setDirection: UISwipeGestureRecognizerDirectionLeft];
    _swipeGestureLeft.numberOfTouchesRequired = 1;
    _swipeGestureLeft.delegate = self;
    
    [self.view addGestureRecognizer:_swipeGestureRight];
    [self.view addGestureRecognizer:_swipeGestureLeft];
}

-(void)addXAxis{
    [[self.xAxis subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.xAxis = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 40.0f + self.header.frame.size.height, 60.0f, self.view.frame.size.height - 100.0f - self.header.frame.size.height - self.footer.frame.size.height)];
    [self.xAxis setBackgroundColor:[UIColor clearColor]];
    long increments = [[NSNumber numberWithFloat: maxCapCharge / 4.0f]integerValue];
    float heightGaps = self.xAxis.frame.size.height / 4.0f;
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, self.xAxis.frame.size.height - ([[NSNumber numberWithInt:i]floatValue] * heightGaps) - 10.0f, self.xAxis.frame.size.width, 20.0f)];
        NSString *labelValue = [StringFormatters formatCurrency:[NSNumber numberWithLong:increments * [[NSNumber numberWithInt:i]longValue]]];
        label.text = labelValue;
        label.font = [UIFont fontWithName:@"Arial" size:10.0f];
        label.textColor = [UIColor colorWithRed:1.0f green:174.0f/255.0f blue:0.0f alpha:1.0f];
        label.textAlignment = NSTextAlignmentRight;

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(60.0f, self.xAxis.frame.size.height - ([[NSNumber numberWithInt:i]floatValue] * heightGaps), self.barChartView.frame.size.width, 1.0f)];
        [line setBackgroundColor:[UIColor colorWithRed:1.0f green:174.0f/255.0f blue:0.0f alpha:0.8f]];
        
        [self.xAxis addSubview:label];
        [self.xAxis addSubview:line];
    }
    [self.view addSubview:self.xAxis];
}

-(void)topTenFilter:(UIButton *)sender{
    limit = 10;
    [topTen setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [topTwenty setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [topThirty setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [self reloadData];
}

-(void)topTwentyFilter:(UIButton *)sender{
    limit = 20;
    [topTen setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [topTwenty setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [topThirty setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [self reloadData];
}

-(void)topThirtyFilter:(UIButton *)sender{
    limit = 30;
    [topTen setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [topTwenty setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [topThirty setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self reloadData];
}

-(void)reloadData{
    NSString *sql = [NSString stringWithFormat: @"select c.*, p.*, t.* from yearly_contract c inner join player p on c.player = p.id inner join team t on c.team = t.id where c.year = %i order by c.cap_charge desc limit %i", year, limit];
    DbHandler *handler = [DbHandler getInstance];
    highestPaidPlayersByYearList = [[NSArray alloc]initWithArray:[handler query:sql withCallback:[Contract getContractResolver ]]];
    
    maxCapCharge = [[[highestPaidPlayersByYearList objectAtIndexedSubscript:0]capCharge]floatValue];
    minCapCharge = [[[highestPaidPlayersByYearList objectAtIndexedSubscript:[highestPaidPlayersByYearList count]-1]capCharge]floatValue];
    capChargeRange = maxCapCharge - minCapCharge;
    
    //initialize chart
    [self.barChartView reloadData];
}

-(void)selectDate:(UIButton *)sender{
    [self performSegueWithIdentifier:@"graphYearSegue" sender:sender];
}

-(void)handleTranslation:(GraphOrientation)orientation height:(float)h width:(float)w{
    if(orientation == PORTRAIT_MODE){
        self.barChartView.frame = CGRectMake(20.0f, 40.0f, w-40.0f, h-100.0f);
        self.footer.frame = CGRectMake(0.0f, 0.0f, self.barChartView.bounds.size.width, 100.0f);
    }
    else{
        self.barChartView.frame = CGRectMake(20.0f, 20.0f, w-40.0f, h-70.0f);
        self.footer.frame = CGRectMake(0.0f, 0.0f, self.barChartView.bounds.size.width, 50.0f);
    }

    self.playerLabel.frame = CGRectMake(0.0f, 0.0f, self.footer.frame.size.width, 50.0f);
    //[self addXAxis];
    [self.barChartView reloadData];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if(size.height > size.width){
        [self handleTranslation:PORTRAIT_MODE height:size.height width:size.width];
    }
    else{
        [self handleTranslation:LANDSCAPE_MODE height:size.height width:size.width];
    }
}

-(NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView{
    return [highestPaidPlayersByYearList count];
}

-(UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index{
    CGFloat currentCapCharge = [[[highestPaidPlayersByYearList objectAtIndexedSubscript:index]capCharge]floatValue];
    CGFloat pct = (currentCapCharge - minCapCharge) / (capChargeRange);
    CGFloat blueValue = (UPPER_BOUND_BLUE - LOWER_BOUND_BLUE) * pct + LOWER_BOUND_BLUE;
    return [UIColor colorWithRed:0.0f green:0.0f blue:blueValue/255.0f alpha:1.0f];
}

-(CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index{
    NSNumber *capCharge = [[highestPaidPlayersByYearList objectAtIndexedSubscript:index]capCharge];
    CGFloat capChargeFloat = [capCharge floatValue];
    return capChargeFloat;
}

-(void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index{
    Contract *contract = [highestPaidPlayersByYearList objectAtIndexedSubscript:index];
    NSString *capCharge = [StringFormatters formatCurrency:[contract capCharge]];
    self.playerLabel.text  = [NSString stringWithFormat:@"%@: %@", [[contract player]name], capCharge];
}

-(CGFloat)barPaddingForBarChartView:(JBBarChartView *)barChartView{
    return 1.0f;
}

#pragma mark - gestures

-(void)wasDoubleTapped:(UITapGestureRecognizer *)sender{
    NSLog(@"double tap");
}

-(void)wasSwiped:(UISwipeGestureRecognizer *)sender{
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setDuration:0.25];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];

    UISwipeGestureRecognizerDirection direction = sender.direction;
    
    if(direction == UISwipeGestureRecognizerDirectionRight){
        [animation setSubtype:kCATransitionFromRight];
        year--;
    }
    else{
        [animation setSubtype:kCATransitionFromLeft];
        year++;
    }
    
    NSString *sql = [NSString stringWithFormat: @"select c.*, p.*, t.* from yearly_contract c inner join player p on c.player = p.id inner join team t on c.team = t.id where c.year = %i order by c.cap_charge desc limit %i", year, limit];
    DbHandler *handler = [DbHandler getInstance];
    highestPaidPlayersByYearList = [[NSArray alloc]initWithArray:[handler query:sql withCallback:[    Contract getContractResolver ]]];
    
    maxCapCharge = [[[highestPaidPlayersByYearList objectAtIndexedSubscript:0]capCharge]floatValue];
    minCapCharge = [[[highestPaidPlayersByYearList objectAtIndexedSubscript:[highestPaidPlayersByYearList count]-1]capCharge]floatValue];
    capChargeRange = maxCapCharge - minCapCharge;
    
    self.barChartView.maximumValue = maxCapCharge;
    [self addXAxis];
    
    [self.view.layer addAnimation:animation forKey:kCATransition];
    [self.barChartView reloadData];
}

@end
