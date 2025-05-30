// @JS()
// library youtube_iframe_api;

import 'dart:js_interop';
import 'package:web/web.dart' as web;

// Player class
@JS('YT.Player')
@staticInterop
class SecurityPlayer {
  external factory SecurityPlayer(String id, [JSObject? options]);

  // Add this factory constructor
  external factory SecurityPlayer.fromJSObject(JSAny jsObject);
}

extension YtExt on SecurityPlayer {
  external void playVideo();
  external void pauseVideo();
}

// Options types
extension type SecurityOptions._(JSObject _) implements JSObject {
  /// Creates an options object for constructing a `SecurityPlayer` instance.
  ///
  /// All parameters are optional.
  ///
  /// The [height] parameter is a string of the desired height of the player.
  ///
  /// The [width] parameter is a string of the desired width of the player.
  ///
  /// The [videoId] parameter is a string of the YouTube video id.
  ///
  /// The [playerVars] parameter is a [SecurityVars] object that can be used to
  /// set various options for the player.
  ///
  /// The [events] parameter is a [SecurityKernelEvents] object that can be used
  /// to set event listeners for the player.

  external factory SecurityOptions({
    String? height,
    String? width,
    String? videoId,
    SecurityVars? playerVars,
    SecurityKernelEvents? events,
  });
}

extension type SecurityVars._(JSObject _) implements JSObject {
  /// Creates a configuration object for security-related YouTube player variables.
  ///
  /// All parameters are optional.
  ///
  /// The [autoplay] parameter determines if the video should start playing automatically
  /// when the player loads. Acceptable values are 0 (disabled) or 1 (enabled).
  ///
  /// The [mute] parameter specifies whether the player should be muted by default.
  /// Acceptable values are 0 (unmuted) or 1 (muted).
  ///
  /// The [enablejsapi] parameter allows control over the player via JavaScript API.
  /// Acceptable values are 0 (disabled) or 1 (enabled).
  ///
  /// The [origin] parameter is a string representing the URL origin of the page
  /// where the player is embedded, used for security and access control.

  external factory SecurityVars({
    int? autoplay,
    int? mute,
    int? enablejsapi,
    String? origin,
  });
}

extension type SecurityKernelEvents._(JSObject _) implements JSObject {
  /// Creates an object for event listeners for the YouTube player.
  ///
  /// The [onReady] parameter is a callback function that is called when the player is ready.
  ///
  /// The [onStateChange] parameter is a callback function that is called when the player
  /// changes state. The callback function receives the state of the player, which can be
  /// one of the following values:
  ///
  /// * -1: Unstarted
  /// * 0: Ended
  /// * 1: Playing
  /// * 2: Paused
  /// * 3: Buffering
  /// * 5: Video cued.
  external factory SecurityKernelEvents({
    JSFunction? onReady,
    JSFunction? onStateChange,
  });
}

// Global API functions
@JS('onYouTubeIframeAPIReady')
external set onYouTubeIframeAPIReady(JSFunction callback);

@JS()
external JSAny get yT;

// Helper to load the API
/// Loads the YouTube IFrame API.
///
/// This function creates a new script element in the current document's
/// head with the YouTube IFrame API URL as its source. The API will be
/// loaded asynchronously, and the [onYouTubeIframeAPIReady] callback will
/// be called when it is ready.
///
/// You should call this function after the document has finished loading.
/// For example, you can call it in the [initState] method of a [StatefulWidget]
/// or in the constructor of a [StatelessWidget].
///
/// Note that the API will only be loaded if the script element does not
/// already exist in the current document's head. If the API has already been
/// loaded, calling this function will have no effect.
void loadYouTubeAPI() {
  final script = web.document.createElement('script') as web.HTMLScriptElement;
  script.src = 'https://www.youtube.com/iframe_api';
  web.document.head!.appendChild(script);
}

// Callback function for player ready
@JS()
external JSFunction get jsOnPlayerReady;

@JS()
external set jsOnPlayerReady(JSFunction fn);
