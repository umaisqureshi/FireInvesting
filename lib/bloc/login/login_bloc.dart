import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:MOT/models/user/user_model.dart';
import 'package:MOT/respository/login/repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final  _loginRepository = LoginRepository();
  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState( LoginEvent event ) async* {
    if (event is FetchLoginResults) {
      yield LoginLoading();
      yield* _fetchLogin(event.email, event.password);
    }
  }

  Stream<LoginState> _fetchLogin(String email, String password) async* {
    try {
        final user = await _loginRepository.fetchLogin(email: email, password: password);
        yield LoginLoaded(userModel: user);
    } catch (e) {
      yield LoginError(message: 'There was an error loading $e');
    }
  }
}
