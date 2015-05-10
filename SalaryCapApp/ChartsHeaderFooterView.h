//
//  ChartsHeaderView.h
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/9/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartsHeaderFooterView : UIView
@property (nonatomic, strong) UIButton *graphSelectYearButton;
@property (nonatomic, strong) UILabel *buttonLabel;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)bgColor;
@end
