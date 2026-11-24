// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/switchtheme_bloc.dart';

void main() {
  test('theme bloc starts in light mode and switches to dark mode', () async {
    final bloc = SwitchthemeBloc();
    expect(bloc.state, const SwitchthemeInitial(themeValue: true));

    bloc.add(SwitchDarkThemeEvent());
    await bloc.stream.first;
    expect(bloc.state, const SwitchthemeState(themeValue: false));

    await bloc.close();
  });
}
