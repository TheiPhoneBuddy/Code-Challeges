//
//  TIPBPopUpView.h
//  ComponentKit
//
//  Created by Francis Chan on 1/11/18.
//  Copyright © 2018 TheiPhoneBuddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIPBPopUpView : UIViewController

@property(assign) CGPoint cgpoint;
@property(nonatomic,weak)id delagate;
@property(nonatomic,strong)NSString *callBack;
@property(nonatomic,strong)NSMutableDictionary *resp;

#pragma showView/closeView

+ (void)showView:(NSMutableDictionary *)params;
+ (void)closeView:(NSMutableDictionary *)params;

- (IBAction)close:(id)sender;
@end
