//
//  JHPropertyListCell.m
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/6/7.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "JHPropertyListCell.h"

@implementation JHPropertyListCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setText:(NSString *)text
{
    if (_text == text) {
        return;
    }
    _text = text;
    
    if (self.forPropertyName) {
        self.propertyModel.propertyName = text;
    } else {
        self.propertyModel.propertyClass = text;
    }
}

@end
