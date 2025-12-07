import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/models/dash_model.dart';
import 'package:volty/src/app_globals.dart';
import '../../services/apis/dash_api.dart';
import 'dash_states.dart';

class DashCubit extends Cubit<DashStates> {
  DashCubit() : super(DashInitial());
  static DashCubit get(context) => BlocProvider.of(context);
  Future<void> fetchDashboard() async {
    await DashApi().fetchDashboard().then((r) {
      if (r == null || r.toString().startsWith('error')) {
        emit(DashError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        AppGlobals.dashModel = DashModel.fromJson(r);
        emit(DashSuccess(msg: r['message']));
      } else {
        emit(DashError(msg: r['message']));
      }
    });
  }

  refreshState() {
    emit(DashInitial());
  }
}
