import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    print('---------- onEvent');
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print('---------- onChange');
    print(bloc);
    print(change);
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('---------- onTransition');
    print(bloc);
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  Future<void> onError(
      BlocBase bloc, Object error, StackTrace stackTrace) async {
    print('---------- onError');
    print(bloc);
    print(error);
    print(stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
