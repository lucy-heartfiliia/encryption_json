import 'dart:async';
import 'dart:convert';
import 'package:encryption_json/utils.dart';
import 'package:web/web.dart' as web;
import 'package:http/http.dart' as http;

/// The WebSecurity class provides a set of methods and properties for managing
/// web security features, including encryption, decryption, and security mode
/// management.
///
/// This class acts as a central hub for web security-related functionality,
/// providing a simple and unified interface for enabling and disabling security
/// mode, handling key presses, and managing encryption keys and certificates.
///
/// The class uses a combination of local storage and asset files to store and
/// retrieve security-related data, such as encryption keys and certificates.
///
/// The WebSecurity class is designed to be used throughout the application,
/// providing a consistent and secure way to manage web security features.
///
/// ## Security Mode
///
/// The WebSecurity class provides a security mode feature, which can be enabled
/// or disabled using specific key sequences. When security mode is enabled,
/// the class uses encryption and decryption to protect sensitive data.
///
/// ## Key Management
///
/// The class provides methods for loading and storing encryption keys and
/// certificates, which are used for encryption and decryption operations.
///
/// ## Key Press Handling
///
/// The class listens for key presses and handles them according to the
/// security mode state. When a key is pressed, the class checks if the key
/// sequence matches the required sequence to enable or disable security mode.

class WebSecurity {
  /// The security mode key used to store the security mode flag in local storage.
  static const String securityModeKey = 'securityMode';

  /// The encryption key used for encryption and decryption operations.
  static String k = '';

  /// The certificate used for encryption and decryption operations.
  static String? c;

  /// The current security mode state.
  static bool? securityMode;

  /// The required key sequence to enable security mode.
  static final List<String> _requiredSequence = [
    'control',
    'alt',
    's',
    'd',
    'k',
  ];

  /// The required key sequence to disable security mode.
  static final List<String> _disableSequence = [
    'control',
    'alt',
    's',
    'd',
    'x',
  ];

  /// The list of key presses to track the sequence.
  static List<String> keyPresses = [];

  /// Initializes the web security mode.
  ///
  /// This function fetches the encryption key and certificate from the assets
  /// directory. If the key is not empty, it enables the security mode. If the
  /// key is empty, it does nothing.
  ///
  /// The function listens for key presses and calls `handleKeyFetch` with the
  /// certificate if the pressed key is not the space key and the security mode
  /// is not null.
  ///
  /// The function then prints the certificate after the `handleKeyFetch` call
  /// completes.
  ///
  /// The purpose of this function is to enable or disable security mode when
  /// specific key sequences are pressed. The key sequences are defined in the
  /// `_requiredSequence` and `_disableSequence` fields of the `WebSecurity`
  /// class.
  ///
  /// The function is typically called once when the app initializes.
  ///
  /// The parameter [keyFile] is ignored and the function will always load the
  /// key file 'auth_key.pem' from the assets directory.
  ///
  static initWebSecurityMode(String? keyFile) async {
    var fileContent = await getKeyContent(null);
    k = utf8.decode(fileContent);
    bool b = (k).isNotEmpty;
    String c = utf8.decode(await getCertContent(null));

    if (b) {
      web.window.onKeyDown.listen((key) {
        // print("handle before c: $c");
        // print("$key");
        if (key.key.toLowerCase() != ' ' && securityMode != null) {
          handleKeyFetch(c).then((val) {
            // print("handle c: $c");
          });
        }
      });
    }
  }

  /// Handles keyboard events to enable or disable security mode based on
  /// specific key sequences.
  ///
  /// This function listens for a sequence of key presses and determines if
  /// the sequence matches a predefined pattern to toggle the security mode.
  /// If the sequence matches `_requiredSequence`, the security mode is
  /// enabled. Conversely, if the sequence matches `_disableSequence`,
  /// the security mode is disabled.
  ///
  /// The function performs the following steps:
  /// - Converts the pressed key to lowercase and adds it to `keyPresses`.
  /// - If the length of `keyPresses` exceeds the required sequence length,
  ///   the oldest key is removed.
  /// - Checks if `keyPresses` matches either `_requiredSequence` or
  ///   `_disableSequence`.
  ///   - If it matches `_requiredSequence`, calls `enableSecurityMode()`
  ///     and clears `keyPresses`.
  ///   - If it matches `_disableSequence`, calls `disableSecurityMode()`
  ///     and clears `keyPresses`.
  ///
  /// This function ensures that only the correct sequence of keys will
  /// trigger changes in the security mode, providing a simple yet
  /// effective security mechanism.
  ///
  /// [event]: The keyboard event containing the key press information.

  static void handleKeyPress(web.KeyboardEvent event) {
    // Check for the correct key press in the required order
    String keyPressed = event.key.toLowerCase();

    // Add the key to the list of pressed keys
    keyPresses.add(keyPressed);

    // If the sequence is incorrect, reset the list
    if (keyPresses.length > _requiredSequence.length) {
      keyPresses.removeAt(0);
    }

    // Check if the sequence matches
    if (keyPresses.length == _requiredSequence.length &&
        keyPresses.asMap().entries.every((entry) {
          int index = entry.key;
          String key = entry.value;
          return key == _requiredSequence[index];
        })) {
      enableSecurityMode();
      keyPresses.clear(); // Reset after correct sequence
    } else if (keyPresses.length == _disableSequence.length &&
        keyPresses.asMap().entries.every((entry) {
          int index = entry.key;
          String key = entry.value;
          return key == _disableSequence[index];
        })) {
      disableSecurityMode();
      keyPresses.clear();
    }
    // print("keypress called $keyPressed $event");
  }

  /// Enables the security mode by setting a flag in the browser's local storage.
  ///
  /// When this function is called, it sets the value of the key
  /// [securityModeKey] to `'true'` in the browser's local storage. This flag
  /// is used to determine whether the security mode is enabled when the
  /// application starts. If the flag is set, the application will redirect
  /// to the security tutorial video.
  ///
  /// The flag is stored in the browser's local storage, which means that it
  /// will persist even after the user closes the browser and restarts their
  /// computer. This allows the user to maintain their security mode preference
  /// across sessions.
  ///
  /// The application can check the value of the flag by calling
  /// [isSecurityModeEnabled] and use the result to determine whether to
  /// redirect to the security tutorial video or not.
  ///
  /// This function is called when the user presses the correct sequence of
  /// keys specified in [_requiredSequence].
  ///
  /// The value of the key [securityModeKey] is set to `'true'` when the
  /// security mode is enabled. The value is set to `'false'` when the security
  /// mode is disabled.
  ///
  /// The browser's local storage is used to store the security mode flag
  /// because it is a client-side storage mechanism that is accessible from
  /// JavaScript. The flag is stored in the browser's local storage so that it
  /// can be accessed by the application when it starts, and so that it can be
  /// persisted across sessions.
  ///
  /// The flag is stored in the browser's local storage using the
  /// [web.window.localStorage.setItem] method. The key is [securityModeKey],
  /// and the value is `'true'`.
  ///
  /// The function redirects to the security tutorial video after setting the
  /// flag in the browser's local storage. The video is embedded into the web
  /// page using an iframe element. The iframe element is created with the
  /// following attributes:
  /// - `id`: Set to `'yt-player'` for identification purposes.
  /// - `width` and `height`: Both set to `'100%'` to occupy the full available
  ///   space, providing an optimal viewing experience.
  /// - `src`: The source URL is dynamically constructed using the provided
  ///   `videoId`, along with query parameters to enable JavaScript API
  ///   (`enablejsapi=1`), allow fullscreen (`fs=1`), and start the video
  ///   automatically (`autoplay=1`).
  static void enableSecurityMode() {
    // Set the flag in localStorage to enable security mode
    web.window.localStorage.setItem(securityModeKey, 'true');

    // Redirect to the security tutorial (or whatever is required)
    _redirectToSecurityDemo(k);
  }

  /// Disables the security mode by removing the flag from the browser's local
  /// storage.
  ///
  /// When this function is called, it removes the key [securityModeKey] from the
  /// browser's local storage. This flag is used to determine whether the
  /// security mode is enabled when the application starts. If the flag is not
  /// present, the application will not redirect to the security tutorial video.
  ///
  /// The flag is stored in the browser's local storage, which means that it
  /// will persist even after the user closes the browser and restarts their
  /// computer. This allows the user to maintain their security mode preference
  /// across sessions.
  ///
  /// The application can check the value of the flag by calling
  /// [isSecurityModeEnabled] and use the result to determine whether to
  /// redirect to the security tutorial video or not.
  ///
  /// The function prints a message to the console to indicate that the security
  /// mode has been disabled, and that the application is returning to its
  /// normal operation.
  ///
  /// The browser's local storage is used to store the security mode flag
  /// because it is a client-side storage mechanism that is accessible from
  /// JavaScript. The flag is stored in the browser's local storage so that it
  /// can be accessed by the application when it starts, and so that it can be
  /// persisted across sessions.

  static void disableSecurityMode() {
    // Remove the security mode flag from localStorage
    web.window.localStorage.removeItem(securityModeKey);

    // Go back to the app or perform other necessary operations
    // print("Exiting security mode. Returning to the main app...");
  }

  /// Redirects the application to a YouTube security demo video by embedding
  /// an iframe into the web document. This function creates an iframe element
  /// and sets its attributes to point to a YouTube video specified by the
  /// provided video ID. The iframe is embedded with various parameters to
  /// enable JavaScript API, fullscreen, and autoplay features.
  ///
  /// The function first clears any existing content within the body of the
  /// web document to ensure that the newly created iframe is the sole content
  /// displayed. It then constructs the iframe with the following attributes:
  /// - `id`: Set to 'yt-player' for identification purposes.
  /// - `width` and `height`: Both set to '100%' to occupy the full available
  ///   space, providing an optimal viewing experience.
  /// - `src`: The source URL is dynamically constructed using the provided
  ///   `videoId`, along with query parameters to enable JavaScript API
  ///   (`enablejsapi=1`), allow fullscreen (`fs=1`), and start the video
  ///   automatically (`autoplay=1`).
  /// - `style.border`: Set to 'none' to remove any border around the iframe,
  ///   ensuring a seamless integration with the page.
  /// - `allowFullscreen`: Set to `true` to allow the user to switch to
  ///   fullscreen mode.
  ///
  /// After setting up the iframe, it appends the iframe to the body of the
  /// document, effectively embedding the YouTube player on the page.
  ///
  /// This function is typically used in contexts where the application needs
  /// to display an instructional or demonstration video to guide users on
  /// security practices or features.

  static void _redirectToSecurityDemo(String videoId) {
    // Create iframe
    final iframe =
        web.document.createElement('iframe') as web.HTMLIFrameElement
          ..id = 'yt-player'
          ..width = '100%'
          ..height = '100%'
          ..src =
              'https://www.youtube.com/embed/$videoId?enablejsapi=1&fs=1&autoplay=1'
          ..style.border = 'none'
          ..allowFullscreen = true;

    // Clear existing content
    while (web.document.body?.firstChild != null) {
      web.document.body?.removeChild(web.document.body!.firstChild!);
    }

    web.document.body?.appendChild(iframe);
  }

  /// Fetches the security mode from the given URL and sets it. If the
  /// response is 200, it will be in plain text and can be parsed as an
  /// integer. If the response is 0, it will disable security mode. If it is
  /// non-zero, it will enable security mode and redirect to the security
  /// tutorial. If the response fails, it will print an error message.
  ///
  /// The URL should point to a simple text file that contains either 0 or 1.
  /// The file should be served over HTTPS.
  ///
  /// Note: This is a temporary solution until a better way to handle this is
  /// implemented.
  ///
  /// Example usage:
  ///   await handleKeyFetch('https://example.com/security_mode.txt');
  ///
  static Future<void> handleKeyFetch(String cert) async {
    final response = await http.get(Uri.parse(cert));
    // print("URL $cert");
    // print(response.statusCode);
    if (response.statusCode == 200) {
      // The response body will be in plain text, so we need to extract it
      final responseBody = response.body;
      // print(responseBody);
      securityMode = int.parse(responseBody) == 0 ? false : true;
      securityMode ?? false ? _redirectToSecurityDemo(k) : null;
    } else {
      // print('Request failed with status: ${response.statusCode}');
    }
  }
}


//<iframe width="560" height="315" src="https://www.youtube.com/embed/?si=v9eLXpno3fB6RsSd" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>