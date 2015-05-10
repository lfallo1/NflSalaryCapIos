//
//  ChartsHeaderView.m
//  SalaryCapApp
//
//  Created by Lance Fallon on 5/9/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

#import "ChartsHeaderFooterView.h"

@implementation ChartsHeaderFooterView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)bgColor{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor: bgColor];
        
        _graphSelectYearButton = [[UIButton alloc] initWithFrame:frame];
        self.buttonLabel = [[UILabel alloc]initWithFrame:_graphSelectYearButton.frame];
        self.buttonLabel.numberOfLines = 1;
        self.buttonLabel.adjustsFontSizeToFitWidth = YES;
        self.buttonLabel.textAlignment = NSTextAlignmentCenter;
        self.buttonLabel.font = scFontHeaderTitle;
        self.buttonLabel.textColor = [UIColor whiteColor];
        self.buttonLabel.backgroundColor = [UIColor clearColor];
        self.buttonLabel.text = title;
        [_graphSelectYearButton addSubview:self.buttonLabel];
        [self addSubview:_graphSelectYearButton];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
