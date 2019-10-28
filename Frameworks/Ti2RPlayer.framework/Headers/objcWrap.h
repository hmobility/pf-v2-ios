//
//  objcWrap.h
//  Ti2RPlayer
//
//  Created by Tisquare on 2018. 11. 7..
//  Copyright © 2018년  All rights reserved.
//

#ifndef Ti2MeRPlayer_objcWrap_h
#define Ti2MeRPlayer_objcWrap_h

#import <AVFoundation/AVFoundation.h>

typedef enum _states {
    MEDIA_PLAYER_STATE_ERROR        = 0,
    MEDIA_PLAYER_IDLE               = 1 << 0,
    MEDIA_PLAYER_INITIALIZED        = 1 << 1,
    MEDIA_PLAYER_PREPARING          = 1 << 2,
    MEDIA_PLAYER_PREPARED           = 1 << 3,
    MEDIA_PLAYER_STARTED            = 1 << 4,
    MEDIA_PLAYER_PAUSED             = 1 << 5,
    MEDIA_PLAYER_STOPPED            = 1 << 6,
    MEDIA_PLAYER_PLAYBACK_COMPLETE  = 1 << 7
}player_state;

/*****************************************************************
 * protocol VTDecoderDelegate
 *****************************************************************/
@protocol VTDecoderDelegate <NSObject>
@required
- (void)didAssembleSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@optional
- (void) didPrepareForAAGLLayer:(CVPixelBufferRef)pb;
@end

@protocol PlayerListener <NSObject>
@required
- (void) OnPrepared:(void*) mp user:(void *) user;
- (void) OnCompletion:(void*) mp user:(void *) user;
- (void) OnSeekComplete:(void*) mp user:(void *) user;
//percent : buffering start(0 %) , buffering end(100 %)
- (void) OnBufferingUpdate:(void*) mp user:(void *)user percent:(int32_t) percent;
- (void) OnVideoSizeChanged:(void*) mp user:(void*) user width :(int32_t) width height:(int32_t) height ;
- (int32_t) OnError:(void*)mp user:(void*)user arg1:(int32_t)arg1 arg2:(int32_t)arg2;
@end

@interface Ti2RPlayer : NSObject

/**
 * 디버그 로그를 출력합니다.
 * @param on
 *         true  : print on
 *         false : print on
 */
-(void)         setDebugOn:(bool)on;

/**
 * Player의 핸들을 만듭니다.(미디어 플레이에 대한 접근은 핸들을 통해서 합니다.
 * @return handle mediaplayer 핸들
 */
-(void*)          Player_create;

/**
 * Player의 핸들을 삭제합니다.(할당 자원 해제)
 * @param handle mediaplayer 핸들
 */
-(void)           Player_release:(void*) handle;

/**
 * Player의 핸들을 삭제합니다.(할당 자원 해제)
 * @param handle mediaplayer 핸들
 */
- (CALayer*)      Player_getDisplayLayerWith:(void*)handle;

/**
 * 재생할 CCTV 비디오 RTSP Url을 지정한다.
 * @param handle mediaplayer 핸들
 * @param url    RTSP url
 * @return
 *         0     :설정 성공
 *         그외   :설정 실패
 */

-(int)        Player_setDataSource:(void*)handle url: (const char *)url;

/**
 * Player의 리스너를 설정한다.
 * @param handle mediaplayer 핸들
 * @param listener mycallback listener
 * @param user   콜백 호출시 반환 받을 파라메터 ex)Ti2Rplayer의 인스턴스를 입력한다.
 * @return
 *         0   :설정 성공
 *         그외 :설정 실패
 */
-(int)        Player_setListener:(void*)handle listener:(void*)listener user:(void*) user;

/**
 * Player 플레이어를 준비한다.(동기)
 * @param handle mediaplayer 핸들
 * @return
 *         0   :설정 성공
 *         그외 :설정 실패
 */
-(int)        Player_prepare:(void*)handle;

/**
 * Player를 준비한다.(비동기)
 * @param handle mediaplayer 핸들
 * @return
 *         0   :설정 성공
 *         그외 :설정 실패
 */
-(int)        Player_prepareAsync:(void*)handle;

/**
 * Player를 시작한다.
 * @param handle mediaplayer 핸들
 * @return
 *         0   :설정 성공
 *         그외 :설정 실패
 */
-(int)        Player_start:(void*) handle;

/**
 * Player 를 일시 정지합니다.
 * @param handle mediaplayer 핸들
 * @return
 *         0   : 설정 성공
 *         그외 : 설정 실패
 */
-(int)        Player_pause:(void*) handle;

/**
 * Player 를 정지합니다.
 * @param handle mediaplayer 핸들
 * @return
 *         0   : 설정 성공
 *         그외 : 설정 실패
 */
-(int)        Player_stop:(void*) handle;

/**
 * Player 가 동작중인지 확인 합니다.
 * @param handle mediaplayer 핸들
 * @return
 *         true   : 미디어플레이(Started 상태)
 *         false  : 미디어플레이 중지 상태
 */
-(bool)       Player_isPlaying:(void*)handle;

/**
 * Player 가 msec 만큼 이동합니다.(playback)
 * @param handle mediaplayer 핸들
 * @param msec 시작싯점부터 옵셋시간(millisecond)
 * @return
 *         0   : 설정 성공
 *         그외 : 설정 실패
 */
-(int)        Player_seekTo:(void*) handle msec:(int32_t) msec;

/**
 * Player 가 출력하는 시간을 가져옵니다.(playback)
 * @param handle mediaplayer 핸들
 * @return msec 시작 싯점부터 옵셋 시간(millisecond)
 *         0   : 설정 성공
 *         그외 : 설정 실패
 */
-(int)        Player_getCurrentPosition:(void*) handle msec:(int32_t*)msec;

/**
 * Player의 미디어 재생 시간을 가져옵니다.(playback)
 * @param handle mediaplayer 핸들
 * @return msec 재생 시간(millisecond)
 *         0   : 설정 성공
 *         그외 : 설정 실패
 */
-(int)        Player_getDuration:(void*) handle msec: (int32_t*)msec;

/**
 * Player의 미디어 재생 시간을 가져옵니다.(playback)
 * @param handle mediaplayer 핸들
 * @param loop 반복 재생 여부 설정
 *         true : 반복재생
 *         false: 반복재생 안됨
 * @return
 *         0   : 설정 성공
 *         그외 : 설정 실패
 */
-(int)        Player_setLooping:(void*) handle loop: (bool) loop;

/**
 * Player가 반복 재생 중 인지 확인 합니다.(playback)
 * @param handle mediaplayer 핸들
 * @return
 *         true : 반복재생
 *         false: 반복재생 안됨
 */

-(bool)       Player_isLooping:(void*) handle;

/**
 * Player의 상태를 반환합니다.
 * @param handle mediaplayer 핸들
 * @return state Player 상태 반환
 * MEDIA_PLAYER_STATE_ERROR        = 0,
 * MEDIA_PLAYER_IDLE               = 1 << 0,
 * MEDIA_PLAYER_INITIALIZED        = 1 << 1,
 * MEDIA_PLAYER_PREPARING          = 1 << 2,
 * MEDIA_PLAYER_PREPARED           = 1 << 3,
 * MEDIA_PLAYER_STARTED            = 1 << 4,
 * MEDIA_PLAYER_PAUSED             = 1 << 5,
 * MEDIA_PLAYER_STOPPED            = 1 << 6,
 * MEDIA_PLAYER_PLAYBACK_COMPLETE  = 1 << 7
 */
-(player_state)       Player_getState:(void*) handle;
@end

#endif /* Ti2MeRPlayer_objcWrap_h */

