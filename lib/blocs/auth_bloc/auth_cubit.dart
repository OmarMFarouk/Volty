import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/auth_model.dart';
import '../../services/apis/auth_api.dart';
import '../../src/app_secured.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);
  TextEditingController fullNameCont = TextEditingController();
  TextEditingController houseNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController cPasswordCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController countryCont = TextEditingController();
  var loginFormKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool rememberMe = false;
  Future<void> loginUser() async {
    emit(AuthLoading());
    User user = User(password: passwordCont.text, email: emailCont.text.trim());
    try {
      await AuthApi().loginUser(model: user).then((r) {
        emit(AuthLoaded());
        if (r == null || r.toString().contains('error')) {
          emit(AuthError(msg: 'تحقق من الإتصال بالإنترنت'));
        } else if (r['success'] == true) {
          emit(AuthSuccess(msg: r['message']));
          clearAndSave(token: r['user_token']);
        } else {
          emit(AuthError(msg: r['message']));
        }
      });
    } catch (e) {
      emit(AuthError(msg: 'تحقق من الإتصال بالإنترنت'));
    }
  }

  Future<void> resetPassword() async {
    emit(AuthLoading());

    await AuthApi().resetPassword(email: emailCont.text.trim()).then((r) {
      emit(AuthLoaded());
      if (r == null || r.toString().contains('error')) {
        emit(AuthError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        emit(AuthSuccess(msg: r['message'], shouldNavigate: false));
        clearAndSave();
      } else {
        emit(AuthError(msg: r['message']));
      }
    });
  }

  Future<void> createUser() async {
    emit(AuthLoading());
    User user = User(
      password: passwordCont.text,
      email: emailCont.text.trim(),
      name: fullNameCont.text.trim(),
      phone: phoneCont.text.trim(),
    );
    await AuthApi()
        .createOwner(
          model: user,
          houseAddress:
              "${addressCont.text.trim()}§§${cityCont.text.trim()}§§${countryCont.text.trim()}",
          houseName: houseNameCont.text.trim(),
        )
        .then((value) {
          emit(AuthLoaded());
          if (value == null || value.toString().startsWith('error')) {
            emit(AuthError(msg: 'تحقق من الإتصال بالإنترنت'));
          } else if (value['success'] == true) {
            emit(AuthSuccess(msg: value['message']));
            clearAndSave(token: value['user_token']);
          } else {
            emit(AuthError(msg: value['message']));
          }
        });
  }

  clearAndSave({String? token}) async {
    if (token != null) {
      await AppSecured.saveString('user_token', token);
    }
    if (rememberMe) await AppSecured.saveString("user_email", emailCont.text);
    if (!rememberMe) await AppSecured.saveString("user_email", "");

    fullNameCont.clear();
    houseNameCont.clear();
    emailCont.clear();
    cityCont.clear();
    addressCont.clear();
    countryCont.clear();
    phoneCont.clear();
    passwordCont.clear();
    cPasswordCont.clear();
  }

  initCubit() async {
    emailCont.text = await AppSecured.readString('user_email') ?? "";
  }

  refreshState() {
    emit(AuthInitial());
  }
}
