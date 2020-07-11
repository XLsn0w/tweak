//
//  BZipCompression.h
//  BZipCompression
//
//  Created by Blake Watters on 9/19/13.
//  Copyright (c) 2013 Blake Watters. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

// The domain for errors returned by the BZip library.
extern NSString * const BZipErrorDomain;

typedef NS_ENUM(NSInteger, BZipError) {
    // Underlying BZip2 Library Errors
    BZipErrorSequence                       = -1,   // BZ_SEQUENCE_ERROR
    BZipErrorInvalidParameter               = -2,   // BZ_PARAM_ERROR
    BZipErrorMemoryAllocationFailed         = -3,   // BZ_MEM_ERROR
    BZipErrorDataIntegrity                  = -4,   // BZ_DATA_ERROR
    BZipErrorIncorrectMagicData             = -5,   // BZ_DATA_ERROR_MAGIC
    BZipErrorIOFailure                      = -6,   // BZ_IO_ERROR
    BZipErrorUnexpectedEOF                  = -7,   // BZ_UNEXPECTED_EOF
    BZipErrorOutputBufferFull               = -8,   // BZ_OUTBUFF_FULL
    BZipErrorInvalidConfiguration           = -9,   // BZ_CONFIG_ERROR

    // BZipCompression Errors
    BZipErrorNilInputDataError              = 1000
};

/**
 A sensible default block size (of 7) for compression.
 */
extern NSInteger const BZipDefaultBlockSize;

/**
 A sensible default work factor (of 0) for compression.
 */
extern NSInteger const BZipDefaultWorkFactor;

/**
 The `BZipCompression` class provides a static Objective-C interface for the compression and decompression of data using the BZip2 algorithm.

 This code was adapted from a Stack Overflow posting: http://stackoverflow.com/a/11390277/177284

 Learn details about the BZip2 compression algorithm at http://www.bzip.org/
 */
@interface BZipCompression : NSObject

/**
 Returns a representation of the input data compressed with the BZip2 algorithm using the specified work factor.

 @param data The uncompressed source input data that is to be compressed.
 @param blockSize A value between 1 and 9 inclusize that specifies the block size used for compression. The actual memory used will be 100000 x this number. A value of 9 gives the best compression, but uses the most memory. If unsure, pass `BZipDefaultBlockSize`.
 @param workFactor Specifies how compression behaves when presented with worst case, highly repetitive data. Lower values will result in more aggressive use of a slower fallback compression alogrithm, potentially inflating compression times unnecessarilly. Values range from 0 to 250. Passing `0` instructs the library to use the default value. If unsure, pass `BZipDefaultWorkFactor`.
 @error A pointer to an error object that, upon failure, is set to an `NSError` object indicating the nature of the failure.
 @return A new `NSData` object encapsulating the compressed representation of the input data or `nil` if compression failed.
 */
+ (NSData *)compressedDataWithData:(NSData *)data blockSize:(NSInteger)blockSize workFactor:(NSInteger)workFactor error:(NSError **)error;

/**
 Returns a decompressed representation of the input data, which must be compressed using the BZip2 algorithm.

 @param data The compressed input data that is to be decompressed.
 @error A pointer to an error object that, upon failure, is set to an `NSError` object indicating the nature of the failure.
 @return A new `NSData` object encapsulating the decompressed representation of the input data or `nil` if decompression failed.
 */
+ (NSData *)decompressedDataWithData:(NSData *)data error:(NSError **)error;

@end
