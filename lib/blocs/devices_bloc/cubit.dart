import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/enums/devices_types_enum.dart';
import 'package:volty/services/apis/Devices_api.dart';
import 'package:volty/src/app_globals.dart';
import '../../models/device_model.dart';
import 'states.dart';

class DevicesCubit extends Cubit<DevicesStates> {
  DevicesCubit() : super(DevicesInitial());
  static DevicesCubit get(context) => BlocProvider.of(context);
  TextEditingController nameCont = TextEditingController();
  TextEditingController kwhCont = TextEditingController();
  DeviceTypes selectedType = DeviceTypes.other;
  Future<void> fetchDevices() async {
    AppGlobals.devicesModel = null;
    emit(DevicesLoading());
    await DevicesApi().fetchDevices().then((r) {
      if (r == null || r.toString().startsWith('error')) {
        emit(DevicesError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        AppGlobals.devicesModel = DevicesModel.fromJson(r);
        emit(DevicesInitial());
      } else {
        emit(DevicesError(msg: r['message']));
      }
    });
    emit(DevicesLoaded());
  }

  Future<void> manageDevice({int deviceId = 0, required int roomId}) async {
    emit(DevicesLoading());
    Device device = Device(
      id: deviceId,
      name: nameCont.text.trim(),
      whValue: double.tryParse(kwhCont.text) ?? 0,
      roomId: roomId,
      type: selectedType.en,
    );
    await DevicesApi().manageDevices(device).then((r) {
      if (r == null || r.toString().startsWith('error')) {
        emit(DevicesError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        fetchDevices();
        clear();
        emit(DevicesSuccess(msg: r['message']));
      } else {
        emit(DevicesError(msg: r['message']));
      }
    });
    emit(DevicesLoaded());
  }

  Future<void> toggleDevice({required int deviceId}) async {
    emit(DevicesLoading());
    await DevicesApi().toggleDevice(deviceId).then((r) async {
      if (r == null || r.toString().startsWith('error')) {
        emit(DevicesError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        await fetchDevices();
        emit(DevicesSuccess(msg: r['message']));
      } else {
        emit(DevicesError(msg: r['message']));
      }
    });
    emit(DevicesLoaded());
  }

  Future<void> manageRoom({int roomId = 0}) async {
    emit(DevicesLoading());
    RoomModel room = RoomModel(id: roomId, name: nameCont.text.trim());
    await DevicesApi().manageRooms(room).then((r) {
      if (r == null || r.toString().startsWith('error')) {
        emit(DevicesError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        emit(DevicesSuccess(msg: r['message']));
        fetchDevices();
        clear();
      } else {
        emit(DevicesError(msg: r['message']));
      }
    });
    emit(DevicesLoaded());
  }

  Future<void> deleteRoom({required int roomId}) async {
    emit(DevicesLoading());
    await DevicesApi().deleteRoom(roomId).then((r) {
      if (r == null || r.toString().startsWith('error')) {
        emit(DevicesError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        fetchDevices();
        emit(DevicesSuccess(msg: r['message']));
      } else {
        emit(DevicesError(msg: r['message']));
      }
    });
    emit(DevicesLoaded());
  }

  Future<void> deleteDevice({required int deviceId}) async {
    emit(DevicesLoading());
    await DevicesApi().deleteDevice(deviceId).then((r) {
      if (r == null || r.toString().startsWith('error')) {
        emit(DevicesError(msg: 'تحقق من الإتصال بالإنترنت'));
      } else if (r['success'] == true) {
        fetchDevices();
        emit(DevicesSuccess(msg: r['message']));
      } else {
        emit(DevicesError(msg: r['message']));
      }
    });
    emit(DevicesLoaded());
  }

  refreshState() {
    emit(DevicesInitial());
  }

  clear() {
    nameCont.clear();
    kwhCont.clear();
    selectedType = DeviceTypes.other;
  }
}
