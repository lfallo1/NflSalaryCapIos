//
//  ChartsViewController.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/9/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contract.h"
#import "JBBarChartView.h"
#import "ChartsHeaderFooterView.h"
#import "StringFormatters.h"

typedef enum {PORTRAIT_MODE = 1, LANDSCAPE_MODE} GraphOrientation;

@interface ChartsViewController : UIViewController<JBBarChartViewDataSource, JBBarChartViewDelegate>

@end
