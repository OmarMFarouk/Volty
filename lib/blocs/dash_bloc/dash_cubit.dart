import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/models/dash_model.dart';
import 'package:volty/src/app_globals.dart';
import '../../models/auth_model.dart';
import '../../services/apis/dash_api.dart';
import '../../src/app_shared.dart';
import 'dash_states.dart';

class DashCubit extends Cubit<DashStates> {
  var hNameCont = TextEditingController();
  var hCountryCont = TextEditingController();
  var hCityCont = TextEditingController();
  var hAddressCont = TextEditingController();
  DashCubit() : super(DashInitial());
  static DashCubit get(context) => BlocProvider.of(context);
  Future<void> fetchDashboard() async {
    await DashApi().fetchDashboard().then((r) {
      if (r == null || r.toString().startsWith('error')) {
        emit(DashError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        AppGlobals.dashModel = DashModel.fromJson(r);
        refreshState();
      } else {
        emit(DashError(msg: r['message']));
      }
    });
  }

  Future<void> manageHousehold({String houseId = '0'}) async {
    emit(DashLoading());
    Household household = Household(
      id: houseId,
      name: hNameCont.text.trim(),
      rawAddress:
          "${hAddressCont.text.trim()}§§${hCityCont.text.trim()}§§${hCountryCont.text.trim()}",
    );
    await DashApi().manageHousehold(household).then((r) {
      if (r == null || r.toString().startsWith('error')) {
        emit(DashError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        clearConts();
        emit(DashSuccess(msg: r['message']));
        emit(DashRefresh());
      } else {
        emit(DashError(msg: r['message']));
      }
    });
    emit(DashLoaded());
  }

  Future<void> switchHousehold({required String houseId}) async {
    emit(DashLoading());

    await DashApi().switchHousehold(houseId).then((r) async {
      if (r == null || r.toString().startsWith('error')) {
        emit(DashError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        await AppShared.saveToken(r['user_token']);

        emit(DashSuccess(msg: r['message']));
        Future.delayed(Duration(seconds: 3), () => emit(DashRefresh()));
      } else {
        emit(DashError(msg: r['message']));
      }
    });
    emit(DashLoaded());
  }

  clearConts() async {
    hNameCont.clear();
    hCountryCont.clear();
    hCityCont.clear();
    hAddressCont.clear();
  }

  refreshState() {
    emit(DashInitial());
  }
}
