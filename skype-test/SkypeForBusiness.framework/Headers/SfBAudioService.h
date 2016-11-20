//+----------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// Module name: SfBAudioService.h
//----------------------------------------------------------------

#import <SkypeForBusiness/SfBConversationService.h>

NS_ASSUME_NONNULL_BEGIN

/** This interface controls the local audio that this endpoint sends into
 * the conversation. The results of some operations on this interface may
 * be visible in changes to the ParticipantAudio belonging to the
 * conversation's selfParticipant.
 */
@interface SfBAudioService : SfBConversationService

@property (readonly) BOOL isOnHold;

/** Holds or resumes the local endpoint's audio - and video - communications.
 *
 * @param hold Holds if true, resumes otherwise.
 */
- (BOOL)setHold:(BOOL)hold error:(NSError **)error;
@property (readonly) BOOL canSetHold;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
