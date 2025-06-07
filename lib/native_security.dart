import 'dart:io';

import 'package:encryption_json/native_security_wrapper.dart';
import 'package:encryption_json/sec_abs.dart';
import 'package:flutter/material.dart';

/// A class that extends SecAbs to provide native security mode functionality.
///
/// This class is responsible for initializing and managing native security mode
/// in a Flutter app. It checks if the app is running in a native environment and
/// performs necessary actions to ensure secure operation.
///
/// The native security mode is designed to provide an additional layer of security
/// for the app when running on native platforms. It uses platform-specific
/// security features to protect the app and its data from unauthorized access.
///
/// The class provides two main methods: `initNativeSecurityMode` and `redirect`.
/// The `initNativeSecurityMode` method is used to initialize the native security
/// mode when the app is running in a native environment. It checks if the widget
/// is mounted and then calls the `handleInit` method to perform the necessary
/// initialization steps.
///
/// The `redirect` method is used to redirect the app to a new page after the
/// native security mode has been initialized. It checks if the widget is still
/// mounted and then pushes a new route to the navigator to display the
/// `NativeSecurityPage`.
///
/// The class also uses the `BuildContext` object to access the current build
/// context and the `mounted` property to check if the widget is mounted.
///
/// The native security mode is only enabled when the app is running on a native
/// platform, such as Android or Windows. On other platforms, such as iOS or
/// macOS, the native security mode is not enabled.
///
/// The class uses the `Future.delayed` function to introduce a short delay
/// between the initialization of the native security mode and the redirection
/// to the new page. This delay is used to ensure that the native security mode
/// has been fully initialized before the app is redirected.
///
/// The class also uses the `debugPrint` function to print debug messages to the
/// console. These messages are used to indicate the status of the native security
/// mode and any errors that may occur during initialization.
///
/// The class is designed to be used in conjunction with the `SecAbs` class,
/// which provides the base functionality for security mode management.
///
/// To use this class, simply create an instance of the `NativeSecurity` class
/// and call the `initNativeSecurityMode` method to initialize the native
/// security mode. The `redirect` method will be called automatically after the
/// native security mode has been initialized.

class NativeSecurity extends SecAbs {
  /// Initializes the native security mode if the app is running in a native
  /// environment.
  ///
  /// If the app is not running in a native environment, this function does
  /// nothing.
  ///
  /// The parameter [ctxt] is a BuildContext object.
  ///
  /// The parameter [mounted] is a boolean indicating if the widget is mounted.
  ///
  /// The function waits for a short period of time and then checks if the
  /// widget is still mounted. If the widget is still mounted, the function
  /// calls [handleInit] and if [handleInit] returns true, the function calls
  /// [redirect] with the given BuildContext.
  ///
  /// If the widget is not mounted, the function just prints a debug message
  /// with the status of the widget.
  ///
  /// This function is used to initialize the native security mode when the
  /// app is running in a native environment.
  void initNativeSecurityMode(BuildContext ctxt, bool mounted) async {
    await super.init();
    Future.delayed(
      Duration(milliseconds: 100),
      () async => {
        if (ctxt.mounted)
          await super.handleInit()
              ? redirect(ctxt)
              : debugPrint(
                "NativeSecurity init failed with status: ${ctxt.mounted}",
              ),
      },
    );
  }

  /// Redirects the app to a new page after the native security mode has been initialized.
  ///
  /// This method is called automatically by the `initNativeSecurityMode` method
  /// after the native security mode has been initialized.
  ///
  /// The method checks if the widget is still mounted and then pushes a new route
  /// to the navigator to display the `NativeSecurityPage`.
  ///
  /// The `NativeSecurityPage` is a platform-specific page that provides additional
  /// security features for the app.
  ///
  /// The method uses the `Navigator` class to push a new route to the navigator.
  ///
  /// The `Navigator` class is used to manage the navigation stack of the app.
  ///
  /// The method also uses the `MaterialPageRoute` class to create a new route.
  ///
  /// The `MaterialPageRoute` class is used to create a new route with a material
  /// design transition.
  ///
  /// The method uses the `NativeSecurityPage` class to create a new page.
  ///
  /// The `NativeSecurityPage` class is a platform-specific page that provides
  /// additional security features for the app.
  ///
  /// The method uses the `uuid` parameter to pass a unique identifier to the
  /// `NativeSecurityPage`.
  ///
  /// The `uuid` parameter is used to identify the app and its security mode.
  ///
  /// The method uses the `ctxt` parameter to access the current build context.
  ///
  /// The `ctxt` parameter is used to access the current build context and the
  /// navigator.
  ///
  /// The method uses the `mounted` property to check if the widget is mounted.
  ///
  /// The `mounted` property is used to check if the widget is mounted and
  /// visible.
  ///
  /// The method uses the `Future.delayed` function to introduce a short delay
  /// before redirecting to the new page.
  ///
  /// The `Future.delayed` function is used to introduce a short delay before
  /// redirecting to the new page.
  ///
  /// The delay is used to ensure that the native security mode has been fully
  /// initialized before the app is redirected.
  ///
  /// The method uses the `Platform.isIOS` and `Platform.isMacOS` properties to
  /// check if the app is running on an iOS or macOS platform.
  ///
  /// The `Platform.isIOS` and `Platform.isMacOS` properties are used to check if
  /// the app is running on an iOS or macOS platform.
  ///
  /// If the app is running on an iOS or macOS platform, the method does not
  /// redirect to the new page.
  ///
  /// Instead, the method returns without doing anything.
  ///
  /// This is because the native security mode is not enabled on iOS and macOS
  /// platforms.
  ///
  /// The method is designed to be used in conjunction with the `initNativeSecurityMode`
  /// method.
  ///
  /// To use this method, simply call the `initNativeSecurityMode` method to
  /// initialize the native security mode.
  ///
  /// The `redirect` method will be called automatically after the native security
  /// mode has been initialized.
  ///
  /// The method is asynchronous and returns a `Future` object.
  ///
  /// The `Future` object is used to represent the result of the asynchronous
  /// operation.
  ///
  /// The method does not return any value.
  ///
  /// Instead, it redirects the app to a new page.

  redirect(BuildContext ctxt) {
    //WidgetsBinding.instance.exitApplication(AppExitType.required, 1);

    if (ctxt.mounted) {
      // Navigator.of(ctxt).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => NativeSecurityPage(uuid: SecAbs.k ?? ""),
      //   ),
      //   (Route<dynamic> route) => false, // removes all previous routes
      // );
      if (!(Platform.isIOS || Platform.isMacOS)) {
        showTakeover(ctxt, SecAbs.k);
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   Navigator.of(ctxt).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (context) => NativeSecurityWrapper(uuid: SecAbs.k),
        //     ),
        //     (route) => route.isCurrent,
        //   );
        // });
      }
    }
  }
}

OverlayEntry? _overlayEntry;

void showTakeover(BuildContext context, String uuid) {
  if (_overlayEntry != null) return;

  _overlayEntry = OverlayEntry(
    builder: (context) => NativeSecurityWrapper(uuid: uuid),
  );

  final overlay = Overlay.of(context, rootOverlay: true);
  if (overlay != null) {
    overlay.insert(_overlayEntry!);
  }
}
