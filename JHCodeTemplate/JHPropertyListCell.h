//
//  JHPropertyListCell.h
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/6/7.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JHCodeTemplatePropertyModel.h"

@interface JHPropertyListCell : NSTableCellView

@property (nonatomic, assign) BOOL forPropertyName;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) JHCodeTemplatePropertyModel *propertyModel;
@end
