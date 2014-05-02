//
//  BarCode.h
//  ColloQR
//
//  Created by Long Vinh Nguyen on 5/2/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface BarCode : NSObject

@property (nonatomic, strong) AVMetadataMachineReadableCodeObject *metadataObject;
@property (nonatomic, strong) UIBezierPath *cornerPath;
@property (nonatomic, strong) UIBezierPath *boundingBoxPath;

@end
