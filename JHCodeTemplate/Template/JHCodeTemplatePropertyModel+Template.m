//
//  JHCodeTemplatePropertyModel+Template.m
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "JHCodeTemplatePropertyModel+Template.h"

#import "NSString+JHCodeTemplate.h"

@implementation JHCodeTemplatePropertyModel (Template)

- (NSString *)codeStringForPropertyDeclare
{
    NSString *template = @"@property (nonatomic, strong) <$propertyClass$> *<$propertyName$>;";
    
    NSString *codeString =  [template composedStringWithElementArray:self.elementArray];
    
    return codeString;
}

#pragma mark - addSubView
- (NSString *)codeStringForAddSubviewWithSuperView:(NSString *)superView
{
    NSString *template = [NSString stringWithFormat:@"[%@ addSubview:self.<$propertyName$>];", superView];
    
    
    NSString *codeString =  [template composedStringWithElementArray:self.elementArray];
    
    return codeString;
}

- (NSString *)codeStringForAddSubview
{
    return [self codeStringForAddSubviewWithSuperView:@"self"];
}

- (NSString *)codeStringForAddSubviewToCell
{
    return [self codeStringForAddSubviewWithSuperView:@"self.contentView"];
}

- (NSString *)codeStringForAddSubviewForVC
{
    return [self codeStringForAddSubviewWithSuperView:@"self.view"];
}


#pragma mark - setupConstraints
- (NSString *)codeStringForSetupConstraints
{
    NSString *template = @"[self.<$propertyName$> mas_makeConstraints:^(MASConstraintMaker *make) {\n\n}];\n";
    
    NSString *codeString =  [template composedStringWithElementArray:self.elementArray];
    
    return codeString;
}

#pragma mark - Actions
- (NSString *)codeStringForActions
{
    if ([[self basicUIClassNameString] isEqualToString:@"UIButton"]) {
        
        NSString *template = @"- (void)<$propertyName$>Action:(id)sender\n{\nif (self.userData.<$propertyName$>Block) {\nself.userData.<$propertyName$>Block(self.userData);\n}\n}\n";
        
        NSString *codeString =  [template composedStringWithElementArray:self.elementArray];

        return codeString;
    } else {
        return nil;
    }
}

- (NSString *)codeStringForActionsBlockDeclare
{
    if ([[self basicUIClassNameString] isEqualToString:@"UIButton"]) {
        
        NSString *template = @"@property (nonatomic, copy) JHSingleSelectionBlock <$propertyName$>Block;\n";
        
        NSString *codeString =  [template composedStringWithElementArray:self.elementArray];

        return codeString;
    } else {
        return nil;
    }
}

#pragma mark - LazyInit
- (NSString *)codeStringForLazyInit
{
    NSString *template = [NSString stringWithFormat:@"- (<$propertyClass$> *)<$propertyName$>\n{\nif (!_<$propertyName$>) {\n%@\n}\nreturn _<$propertyName$>;\n}\n",[self codeStringForLazyInitDetail]];
    
    NSString *codeString =  [template composedStringWithElementArray:self.elementArray];
    
    return codeString;
}

- (NSString *)codeStringForLazyInitDetail
{
    // 优先手动适配
    SEL selector = NSSelectorFromString([self lazyInitDetailMethodStringAdapter]);
    
    if ([self respondsToSelector:selector]) {
        // 匹配到对应方法
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:selector];
#pragma clang diagnostic pop
        
    }
    
    // 二次“智能”适配
    selector = NSSelectorFromString([self lazyInitDetailMethodStringAdapterAuto]);
    
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:selector];
#pragma clang diagnostic pop
    }
    
    // 不支持的类会作为UIView处理
    return [self codeStringForLazyInitDetailClass_UIView];
    
}

// 手动映射
- (NSString *)lazyInitDetailMethodStringAdapter
{
    NSString *classStr = self.propertyClass;
    
    NSDictionary *adapterDict = @{@"XMNetworkImageView":@"UIImageView"};
    
    NSString *value = [adapterDict objectForKey:classStr];
    if (value) {
        classStr = value;
    }
    
    
    NSString *result = [NSString stringWithFormat:@"codeStringForLazyInitDetailClass_%@", classStr];
    
    return result;
}

// 智能识别控件类型的懒加载代码
- (NSString *)lazyInitDetailMethodStringAdapterAuto
{
    NSString * classStr = [self basicUIClassNameString];
    
    NSString *result = [NSString stringWithFormat:@"codeStringForLazyInitDetailClass_%@", classStr];
    
    return result;
}

// 智能识别基本控件类型
- (NSString *)basicUIClassNameString
{
    NSString *classStr = self.propertyClass;
    
    if ([classStr.lowercaseString hasSuffix:@"button"]) {
        classStr = @"UIButton";
    }
    
    if ([classStr.lowercaseString hasSuffix:@"label"] || [classStr hasSuffix:@"lable"]) {
        classStr = @"UILabel";
    }
    
    if ([classStr.lowercaseString hasSuffix:@"view"]) {
        classStr = @"UIView";
    }
    // 优先imageView，覆盖view判断
    if ([classStr.lowercaseString hasSuffix:@"imageView"]) {
        classStr = @"UIImageView";
    }
    
    if ([classStr.lowercaseString hasSuffix:@"button"]) {
        classStr = @"UIButton";
    }
    return classStr;
}

//

- (NSString *)codeStringForLazyInitDetailClassNormal
{
    NSString *template = @"_<$propertyName$> = [<$propertyClass$> new];";
    
    NSString *codeString =  [template composedStringWithElementArray:self.elementArray];
    
    return codeString;
}


- (NSString *)codeStringForLazyInitDetailClass_UIView
{
    NSString *template = @"_<$propertyName$> = [[<$propertyClass$> alloc] init];";
    
    NSString *codeString =  [template composedStringWithElementArray:self.elementArray];
    
    return codeString;
}

- (NSString *)codeStringForLazyInitDetailClass_UILabel
{
    NSString *template = @"_<$propertyName$> = [[<$propertyClass$> alloc] init];\n_<$propertyName$>.textColor = SST_COLOR_333333;\n_<$propertyName$>.font = Font_14;";
    
    NSString *codeString =  [template composedStringWithElementArray:self.elementArray];
    
    return codeString;
}

- (NSString *)codeStringForLazyInitDetailClass_UIImageView
{
    NSString *template = @"_<$propertyName$> = [[<$propertyClass$> alloc] init];\n_<$propertyName$>.contentMode = UIViewContentModeScaleAspectFill;";
    
    NSString *codeString =  [template composedStringWithElementArray:self.elementArray];
    
    return codeString;
}

- (NSString *)codeStringForLazyInitDetailClass_UIButton
{
    NSString *template = @"_<$propertyName$> = [<$propertyClass$> buttonWithType:UIButtonTypeCustom];\n[_<$propertyName$> addTarget:self action:@selector(<$propertyName$>Action:) forControlEvents:UIControlEventTouchUpInside];";
    
    NSString *codeString =  [template composedStringWithElementArray:self.elementArray];
    
    return codeString;
}

#pragma mark -
- (NSArray *)elementArray
{
    NSArray *array = @[
                       [JHCodeTemplateElementModel elementModelWithContent:self.propertyName identifier:@"propertyName"],
                       [JHCodeTemplateElementModel elementModelWithContent:self.propertyClass identifier:@"propertyClass"],
                       ];
    
    return array;
}

@end
