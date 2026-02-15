import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/models/analytics_model.dart';
import 'package:volty/src/app_globals.dart';
import '../../services/apis/analytics_api.dart';
import 'states.dart';

class AnalyticsCubit extends Cubit<AnalyticsStates> {
  AnalyticsCubit() : super(AnalyticsInitial());

  static AnalyticsCubit get(context) => BlocProvider.of(context);

  String selectedPeriod = 'month';
  DateTime selectedDate = DateTime.now();
  AnalyticsModel? analyticsModel;

  Future<void> fetchAnalytics({String? period, DateTime? date}) async {
    emit(AnalyticsLoading());
    selectedPeriod = period ?? selectedPeriod;
    selectedDate = date ?? selectedDate;

    await AnalyticsApi()
        .fethcAnalytics(
          period: selectedPeriod,
          date: selectedDate.toIso8601String().split('T')[0],
        )
        .then((r) {
          if (r == null || r.toString().startsWith('error')) {
            emit(AnalyticsError(msg: 'تحقق من الإتصال بالإنترنت'));
            print("analytics error");
          } else if (r['success'] == true) {
            analyticsModel = AnalyticsModel.fromJson(r);
            AppGlobals.analyticsModel = analyticsModel;
            emit(AnalyticsSuccess(msg: r['message']));
          } else {
            emit(AnalyticsError(msg: r['message']));

            print("analytics error");
          }
        });
    print("analytics ending");
  }

  void changePeriod(String period) {
    selectedPeriod = period;
    fetchAnalytics(period: period);
  }

  void changeDate(DateTime date) {
    selectedDate = date;
    fetchAnalytics(date: date);
  }

  void refreshState() {
    emit(AnalyticsInitial());
  }
}
