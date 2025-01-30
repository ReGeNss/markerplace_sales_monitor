part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

final class ThemeChanged extends ThemeEvent {
  ThemeChanged(this.themeMode);

  final ThemeMode? themeMode;
}
