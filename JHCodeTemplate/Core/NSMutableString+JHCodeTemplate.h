//
//  NSMutableString+JHCodeTemplate.h
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (JHCodeTemplate)

- (void)codeAppendMethodBeganWithName:(NSString *)methodName;
- (void)codeAppendMethodEnd;
- (void)codeAppendReturn;

- (void)codeAppendAtEnd;
- (void)codeAppendClassDeclareWithClassName:(NSString *)className superName:(NSString *)superName;
- (void)codeAppendClassImplementationWithClassName:(NSString *)className;
- (void)codeAppendClassExtensionWithClassName:(NSString *)className;

- (void)codeAppendPragmaMark:(NSString *)name;
- (void)codeAppendPragmaMark:(NSString *)name withDash:(BOOL)dash;

- (void)codeAppendImportCommon:(NSString *)name;
- (void)codeAppendImportSpecific:(NSString *)fullStr;

@end
