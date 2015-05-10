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
    NSArray *highestPaidPlayersByYearList;
    CGFloat maxCapCharge;
    CGFloat minCapCharge;
    CGFloat capChargeRange;
    int year;
}
@property JBBarChartView *barChartView;
@property ChartsHeaderFooterView *header;
@property UILabel *playerLabel;
@property UIView *footer;
@end

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    year = 2015;
    //get data
    NSString *sql = [NSString stringWithFormat: @"select c.*, p.*, t.* from yearly_contract c inner join player p on c.player = p.id inner join team t on c.team = t.id where c.year = %i order by c.cap_charge desc limit 10", year];
    DbHandler *handler = [DbHandler getInstance];
    highestPaidPlayersByYearList = [[NSArray alloc]initWithArray:[handler query:sql withCallback:[    Contract getContractResolver ]]];
    
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
    self.barChartView.frame = CGRectMake(20.0f, 40.0f, self.view.frame.size.width-40.0f, self.view.frame.size.height-100.0f);
    self.barChartView.backgroundColor = [UIColor redColor];
    [self.barChartView setMaximumValue: (maxCapCharge + 1000000.0f)];
    [self.barChartView setMinimumValue:0.0f];
    [self.view addSubview:self.barChartView];
    
    //Header / Footer
    self.header = [[ChartsHeaderFooterView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.barChartView.frame.size.width, 40.0f) title:@"2015" backgroundColor:[UIColor greenColor]];
    [self.header.graphSelectYearButton addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.barChartView setHeaderView:self.header];
    
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
    self.header.graphSelectYearButton.frame = CGRectMake(0.0f, 0.0f, self.barChartView.frame.size.width, 40.0f);
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

#pragma mark - gestures

-(void)wasSwiped:(UISwipeGestureRecognizer *)sender{
    UISwipeGestureRecognizerDirection direction = sender.direction;
    
    if(direction == UISwipeGestureRecognizerDirectionRight){
        year--;
    }
    else{
        year++;
    }
    
    NSString *sql = [NSString stringWithFormat: @"select c.*, p.*, t.* from yearly_contract c inner join player p on c.player = p.id inner join team t on c.team = t.id where c.year = %i order by c.cap_charge desc limit 10", year];
    DbHandler *handler = [DbHandler getInstance];
    highestPaidPlayersByYearList = [[NSArray alloc]initWithArray:[handler query:sql withCallback:[    Contract getContractResolver ]]];
    
    maxCapCharge = [[[highestPaidPlayersByYearList objectAtIndexedSubscript:0]capCharge]floatValue];
    minCapCharge = [[[highestPaidPlayersByYearList objectAtIndexedSubscript:[highestPaidPlayersByYearList count]-1]capCharge]floatValue];
    capChargeRange = maxCapCharge - minCapCharge;
    
    self.header.buttonLabel.text = [NSString stringWithFormat:@"%i", year];
    
    [self.barChartView reloadData];
}

@end
