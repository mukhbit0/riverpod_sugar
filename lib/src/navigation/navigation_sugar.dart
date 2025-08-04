import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Navigation extensions that make routing with state management incredibly simple
/// Inspired by the same philosophy as our Sugar extensions - concise and intuitive

/// Extension on WidgetRef to provide navigation sugar methods
extension NavigationSugar on WidgetRef {
  /// Push a new page with automatic state access
  /// Usage: `ref.pushPage(UserProfilePage());`
  Future<T?> pushPage<T>(Widget page) {
    final context = _getContext();
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push a page and wait for result
  /// Usage: `final result = await ref.pushPageWithResult<String>(EditPage());`
  Future<T?> pushPageWithResult<T>(Widget page) {
    return pushPage<T>(page);
  }

  /// Push a page with custom transition
  /// Usage: `ref.pushPageWithTransition(SettingsPage(), SlideTransition(...));`
  Future<T?> pushPageWithTransition<T>(
    Widget page,
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) transitionBuilder,
  ) {
    final context = _getContext();
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: transitionBuilder,
      ),
    );
  }

  /// Push and replace current page
  /// Usage: `ref.pushReplacement(LoginPage());`
  Future<T?> pushReplacement<T, TO>(Widget page, {TO? result}) {
    final context = _getContext();
    return Navigator.of(context).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  /// Push and clear all previous pages
  /// Usage: `ref.pushAndClearAll(HomePage());`
  Future<T?> pushAndClearAll<T>(Widget page) {
    final context = _getContext();
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Pop current page
  /// Usage: `ref.pop();` or `ref.pop(result);`
  void pop<T>([T? result]) {
    final context = _getContext();
    Navigator.of(context).pop<T>(result);
  }

  /// Pop with data to previous page
  /// Usage: `ref.popWithData('Success');`
  void popWithData<T>(T data) {
    pop<T>(data);
  }

  /// Pop until specific page
  /// Usage: `ref.popUntil((route) => route.isFirst);`
  void popUntil(bool Function(Route<dynamic>) predicate) {
    final context = _getContext();
    Navigator.of(context).popUntil(predicate);
  }

  /// Pop to root page
  /// Usage: `ref.popToRoot();`
  void popToRoot() {
    popUntil((route) => route.isFirst);
  }

  /// Check if can pop
  /// Usage: `if (ref.canPop()) ref.pop();`
  bool canPop() {
    final context = _getContext();
    return Navigator.of(context).canPop();
  }

  /// Get current route name
  /// Usage: `final currentRoute = ref.currentRouteName;`
  String? get currentRouteName {
    final context = _getContext();
    return ModalRoute.of(context)?.settings.name;
  }

  /// Show modal bottom sheet with provider access
  /// Usage: `ref.showBottomSheet(SettingsSheet());`
  Future<T?> showBottomSheet<T>(
    Widget sheet, {
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    final context = _getContext();
    return showModalBottomSheet<T>(
      context: context,
      builder: (_) => sheet,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
    );
  }

  /// Show dialog with provider access
  /// Usage: `ref.showCustomDialog(ConfirmDialog());`
  Future<T?> showCustomDialog<T>(
    Widget dialog, {
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    final context = _getContext();
    return showDialog<T>(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
    );
  }

  /// Show snack bar with provider access
  /// Usage: `ref.showSnackBar('Success!');`
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final context = _getContext();
    final snackBar = SnackBar(
      content: Text(
        message,
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
      duration: duration,
      action: action,
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Helper method to get BuildContext from the current widget
  /// This is safe because WidgetRef is only available during build/lifecycle methods
  BuildContext _getContext() {
    // In a real implementation, we need to store the context
    // For now, we'll use a different approach with a global navigator key
    final navigatorKey = _NavigationHelper.navigatorKey;
    final context = navigatorKey.currentContext;
    if (context == null) {
      throw StateError(
        'Navigation context not available. Make sure to set SugarNavigation.navigatorKey '
        'in your MaterialApp and that navigation is called from within a widget tree.',
      );
    }
    return context;
  }
}

/// Helper class to manage global navigator key
class _NavigationHelper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

/// Static helper for setting up navigation
class SugarNavigation {
  /// Global navigator key - set this in your MaterialApp
  /// Usage: `MaterialApp(navigatorKey: SugarNavigation.navigatorKey, ...)`
  static GlobalKey<NavigatorState> get navigatorKey =>
      _NavigationHelper.navigatorKey;

  /// Get current context from navigator
  static BuildContext? get currentContext => navigatorKey.currentContext;
}

/// Extension on Widget to make it easily pushable
extension PushableWidget on Widget {
  /// Push this widget as a page
  /// Usage: `UserProfilePage().push(ref);`
  Future<T?> push<T>(WidgetRef ref) => ref.pushPage<T>(this);

  /// Push this widget and replace current page
  /// Usage: `LoginPage().pushReplacement(ref);`
  Future<T?> pushReplacement<T, TO>(WidgetRef ref, {TO? result}) =>
      ref.pushReplacement<T, TO>(this, result: result);

  /// Push this widget and clear all previous pages
  /// Usage: `HomePage().pushAndClearAll(ref);`
  Future<T?> pushAndClearAll<T>(WidgetRef ref) => ref.pushAndClearAll<T>(this);

  /// Show this widget as a modal bottom sheet
  /// Usage: `SettingsSheet().showAsBottomSheet(ref);`
  Future<T?> showAsBottomSheet<T>(
    WidgetRef ref, {
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) =>
      ref.showBottomSheet<T>(
        this,
        isScrollControlled: isScrollControlled,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
      );

  /// Show this widget as a dialog
  /// Usage: `ConfirmDialog().showAsDialog(ref);`
  Future<T?> showAsDialog<T>(
    WidgetRef ref, {
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) =>
      ref.showCustomDialog<T>(
        this,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
      );
}

/// Preset navigation transitions
class NavigationTransitions {
  /// Slide from right transition
  static Widget slideFromRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Slide from bottom transition
  static Widget slideFromBottom(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Fade transition
  static Widget fade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Scale transition
  static Widget scale(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}
