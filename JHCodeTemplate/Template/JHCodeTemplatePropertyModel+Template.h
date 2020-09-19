//
//  JHCodeTemplatePropertyModel+Template.h
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "JHCodeTemplatePropertyModel.h"

@interface JHCodeTemplatePropertyModel (Template)

- (NSString *)codeStringForPropertyDeclare;

#pragma mark - addSubView
- (NSString *)codeStringForAddSubview;
- (NSString *)codeStringForAddSubviewToCell;
- (NSString *)codeStringForAddSubviewForVC;
- (NSString *)codeStringForAddSubviewWithSuperView:(NSString *)superView;


#pragma mark - setupConstraints
- (NSString *)codeStringForSetupConstraints;


#pragma mark - Actions
- (NSString *)codeStringForActions;
- (NSString *)codeStringForActionsBlockDeclare;

#pragma mark - LazyInit
- (NSString *)codeStringForLazyInit;


@end
