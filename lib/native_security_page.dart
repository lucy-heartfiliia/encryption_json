import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_all/webview_all.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NativeSecurityPage extends StatefulWidget {
  final String uuid;
  const NativeSecurityPage({super.key, required this.uuid});

  @override
  State<NativeSecurityPage> createState() => _NativeSecurityPageState();
}

class _NativeSecurityPageState extends State<NativeSecurityPage> {
  late InAppWebViewController webViewCOntroller;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Custom HTML content
    final htmlContent = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { font-family: Arial; padding: 20px; }
            .video-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; }
            .video-container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
          </style>
        </head>
        <body>
          <div class="video-container">
            <iframe 
            height="100%" 
            width="100%"
              src="https://www.youtube.com/embed/${widget.uuid}?enablejsapi=1&fs=1&autoplay=1"
              frameborder="0"
              allow="autoplay;"
              allowfullscreen>
            </iframe>
          </div>
        </body>
      </html>
    ''';
    try {
      if (Platform.isLinux) {
        return Webview(
          url:
              "data:text/html;charset=utf-8,${Uri.encodeComponent(htmlContent)}",
        );
      } else if (Platform.isAndroid || Platform.isIOS) {
        return InAppWebView(
          initialData: InAppWebViewInitialData(
            data: htmlContent,
            mimeType: "text/html",
            encoding: "utf-8",
            baseUrl: WebUri("https://www.youtube.com"),
          ),
          onEnterFullscreen: (controller) {
            controller;
          },
          // onWebViewCreated: (controller) {
          //   webViewCOntroller = controller;
          // },
          keepAlive: InAppWebViewKeepAlive(),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            useShouldOverrideUrlLoading: true,
            allowsBackForwardNavigationGestures: true,

            preferredContentMode: UserPreferredContentMode.MOBILE,

            iframeAllowFullscreen: true,
            isElementFullscreenEnabled: true,
            contentInsetAdjustmentBehavior:
                ScrollViewContentInsetAdjustmentBehavior.ALWAYS,
          ),
        );
      } else if (Platform.isMacOS || Platform.isWindows) {
        return InAppWebView(
          initialData: InAppWebViewInitialData(
            data: htmlContent,
            mimeType: "text/html",
            encoding: "utf-8",
            baseUrl: WebUri("https://www.youtube.com"),
          ),

          // onWebViewCreated: (controller) {
          //   webViewCOntroller = controller;
          // },
          keepAlive: InAppWebViewKeepAlive(),
          initialSettings: InAppWebViewSettings(
            mediaPlaybackRequiresUserGesture: false,
            preferredContentMode: UserPreferredContentMode.DESKTOP,
            isInspectable: false,
            iframeAllowFullscreen: true,
            isElementFullscreenEnabled: true,
          ),
        );
      }
    } catch (_) {
      // Completely suppress all errors
    }

    // Fallback implementation
    return const SizedBox(
      child: Text("WebView not available on this platform"),
    );
  }
}
