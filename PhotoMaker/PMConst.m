//
//  PMConst.m
//  PhotoMaker
//
//  Created by Nikita on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMConst.h"

NSString *const kPMKeyAdviceUsed = @"ADVICE_USED";

const float kPMCameraAspect = 3.0f/4.0f;
const int kPMMinimumImageSize = 640;
const int kPMMaximumImageSize = 2048;

#pragma mark - Image names

NSString *const kPMImageStartupBackgrounPattern = @"BackGround.png";
NSString *const kPMImageStartupBottomRoll = @"HomeBottomRoll.png";
NSString *const kPMImageFilterExampleImage = @"FilterExampleImage.png";
NSString *const kPMImageFilterSelectionCell = @"FilterMask.png";
NSString *const kPMImageFilterSelectionCellActive = @"FilterMask_Active.png";
NSString *const kPMImageEditorInput = @"Input.png";
NSString *const kPMImageEditorFiltersMenu = @"Filters_Menu.png";
NSString *const kPMImageEditorTabLeftActive = @"FontTabLeft_Active.png";
NSString *const kPMImageEditorTabLeft = @"FontTabLeft.png";
NSString *const kPMImageEditorTabRightActive = @"FontTabRight_Active.png";
NSString *const kPMImageEditorTabRight = @"FontTabRight.png";
NSString *const kPMImageEditorTabActive = @"FontTab_Active.png";
NSString *const kPMImageEditorTab = @"FontTab.png";

CGSize const kPMImageEditorInputCaps = {24, 16};

// Buttons
NSString *const kPMImageButtonBlack = @"BlackBtn.png";
NSString *const kPMImageButtonBlackPressed = @"BlackBtn_Pressed.png";
NSString *const kPMImageButtonBlue = @"BlueBtn.png";
NSString *const kPMImageButtonBluePressed = @"BlueBtn_Pressed.png";

NSString *const kPMImageButtonTransparent = @"CameraBtn.png";
NSString *const kPMImageButtonTransparentPressed = @"CameraBtn_Pressed.png";
NSString *const kPMImageButtonAction = @"ActionBtn.png";
NSString *const kPMImageButtonActionPressed = @"ActionBtn_Pressed.png";
NSString *const kPMImageButtonActionActive = @"ActionBtn_Active.png";

NSString *const kPMImageButtonBlur = @"Camera_Blur.png";
NSString *const kPMImageButtonFlashlight = @"Camera_Flash.png";
NSString *const kPMImageButtonSwitchCamera = @"Camera_ReverseFill.png";

CGSize const kPMDefaultButtonCaps = {23, 20.5};
CGSize const kPMActionButtonCaps = {20, 18};

// Tab bar
NSString *const kPMImageTabLeft = @"FontTabLeft.png";
NSString *const kPMImageTabLeftActive = @"FontTabLeft_Active.png";
NSString *const kPMImageTabMiddle = @"FontTab.png";
NSString *const kPMImageTabMiddleActive = @"FontTab_Active.png";
NSString *const kPMImageTabRight = @"FontTabRight.png";
NSString *const kPMImageTabRightActive = @"FontTabRight_Active.png";

CGSize const kPMTabMiddleCaps = {7, 16};
CGSize const kPMTabLeftCaps = {17, 16};
CGSize const kPMTabRightCaps = {17, 16};

#pragma mark - Font names

NSString *const kPMFontBALLW = @"Ballpark";
NSString *const kPMFontCollegiate = @"CollegiateHeavyOutline";
NSString *const kPMFontCompleteHim = @"Complete in Him";
NSString *const kPMFontHelvetica = @"Helvetica";
NSString *const kPMFontLobster = @"Lobster 1.4";
NSString *const kPMFontTT1018M = @"Freehand521 BT";
