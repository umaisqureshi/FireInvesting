import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:MOT/models/user/user_model.dart';
import 'package:MOT/respository/register/repository.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  final  _registerRepository = RegisterRepository();
  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState( RegisterEvent event ) async* {
    if (event is FetchRegisterResults) {
      yield RegisterLoading();
      yield* _fetchRegister(event.singleUserModel);
    }
  }

  Stream<RegisterState> _fetchRegister(SingleUserModel singleUserModel) async* {
    try {
        final user = await _registerRepository.fetchRegister(singleUserModel: singleUserModel);
        yield RegisterLoaded(userModel: user);
    } catch (e) {
      yield RegisterError(message: 'There was an error loading $e');
    }
  }
}
