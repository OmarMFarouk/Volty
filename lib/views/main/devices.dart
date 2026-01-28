import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/blocs/devices_bloc/cubit.dart';
import 'package:volty/blocs/devices_bloc/states.dart';
import 'package:volty/components/general/my_loading_indicator.dart';
import 'package:volty/components/general/snackbar.dart';
import 'package:volty/models/device_model.dart';
import 'package:volty/src/app_globals.dart';

import '../../components/general/refresh.dart';
import '../../enums/devices_types_enum.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  bool _showAIInsights = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DevicesCubit, DevicesStates>(
      listener: (context, state) {
        if (state is DevicesError) {
          MySnackBar.show(context: context, isAlert: true, text: state.msg);
        }
        if (state is DevicesSuccess) {
          MySnackBar.show(context: context, isAlert: false, text: state.msg);
        }
        if (state is DevicesLoaded) {
          Navigator.pop(context);
        }
        if (state is DevicesLoading) {
          MyLoadingIndicator.showLoader(context);
        }
      },
      builder: (context, state) {
        final rooms =
            AppGlobals.devicesModel?.rooms?.whereType<RoomModel>().toList() ??
            [];

        if (AppGlobals.devicesModel == null) {
          return Center(
            child: CircularProgressIndicator(color: const Color(0xFFB8FF57)),
          );
        }

        if (state is DevicesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ في تحميل البيانات',
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<DevicesCubit>().fetchDevices(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8FF57),
                  ),
                  child: Text(
                    'إعادة المحاولة',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        }
        return CustomRefresh(
          onRefresh: () async =>
              await context.read<DevicesCubit>().fetchDevices(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 25),
                  if (_showAIInsights && rooms.isNotEmpty) ...[
                    _buildAIInsightBanner(rooms),
                    const SizedBox(height: 20),
                  ],
                  if (rooms.isEmpty) ...[
                    _buildEmptyState(),
                  ] else ...[
                    ...rooms.map(
                      (room) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildRoomSection(room),
                      ),
                    ),
                  ],
                  _buildAddRoomButton(),
                  SizedBox(height: kToolbarHeight * 1.5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأجهزة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'إدارة جميع الأجهزة الذكية',
          style: TextStyle(color: Colors.grey[400], fontSize: 15),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              'الغرف',
              AppGlobals.devicesModel!.roomsCount.toString(),
              Icons.room_rounded,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'الأجهزة',
              '${AppGlobals.devicesModel!.devicesCount}/${AppGlobals.devicesModel!.activeCount}',
              Icons.devices_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2538),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2D3548)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFB8FF57).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFB8FF57), size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.home_work_outlined, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 20),
            Text(
              'لا توجد غرف حتى الآن',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ابدأ بإضافة غرفة جديدة',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsightBanner(List<RoomModel> rooms) {
    // Find the device with highest usage
    Device? highestUsageDevice;
    double highestUsage = 0;
    String? roomName;

    for (var room in rooms) {
      for (Device device in room.devices?.whereType<Device>() ?? []) {
        if (device.isOn && device.monthConsumption! > highestUsage) {
          highestUsage = device.monthConsumption!;
          highestUsageDevice = device;
          roomName = room.name;
        }
      }
    }

    if (highestUsageDevice == null) return SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF).withOpacity(0.2),
            const Color(0xFF5B54E8).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.psychology_rounded,
              color: const Color(0xFF6C63FF),
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رؤية ذكية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${highestUsageDevice.name} في $roomName يستهلك $highestUsage% - يُنصح بمراجعة الاستخدام',
                  style: TextStyle(color: Colors.grey[300], fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _showAIInsights = false;
              });
            },
            icon: Icon(Icons.close, color: Colors.grey[400], size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomSection(RoomModel room) {
    final devices = room.devices?.whereType<Device>().toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2538),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2D3548)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.room_rounded,
                color: const Color(0xFFB8FF57),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                room.name ?? 'غرفة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8FF57).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${room.activeCount}/${room.totalCount}',
                  style: TextStyle(
                    color: const Color(0xFFB8FF57),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[400], size: 20),
                color: const Color(0xFF1E2538),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditRoomDialog(room);
                  } else if (value == 'delete') {
                    _showDeleteRoomDialog(room);
                  } else if (value == 'add_device') {
                    _showAddDeviceDialog(room);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'add_device',
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 20,
                          color: const Color(0xFFB8FF57),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'إضافة جهاز',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20, color: Colors.grey[400]),
                        SizedBox(width: 8),
                        Text(
                          'تعديل الغرفة',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('حذف الغرفة', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (devices.isEmpty)
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2538),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2D3548)),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.devices_other, size: 40, color: Colors.grey[600]),
                  const SizedBox(height: 12),
                  Text(
                    'لا توجد أجهزة في هذه الغرفة',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _showAddDeviceDialog(room),
                    icon: Icon(Icons.add, size: 18),
                    label: Text('إضافة جهاز'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFB8FF57),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...devices.map(
            (device) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildDeviceCard(device, room),
            ),
          ),
      ],
    );
  }

  Widget _buildDeviceCard(Device device, RoomModel room) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: device.isOn
              ? const Color(0xFFB8FF57).withOpacity(0.3)
              : const Color(0xFF2D3548),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: device.isOn
                      ? const Color(0xFFB8FF57).withOpacity(0.15)
                      : const Color(0xFF2D3548),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  device.icon,
                  color: device.isOn ? const Color(0xFFB8FF57) : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name ?? "N/A",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.bolt, color: Colors.grey[400], size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${device.kwhValue?.toStringAsFixed(2) ?? '0.0'} ك.و',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                        if (device.isOn) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getUsageColor(
                                device.monthConsumption?.toInt() ?? 0,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${device.deviceLoad.toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: _getUsageColor(
                                  device.monthConsumption?.toInt() ?? 0,
                                ),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Switch(
                value: device.isOn,
                onChanged: (value) {
                  context.read<DevicesCubit>().toggleDevice(
                    deviceId: device.id!,
                  );
                },
                activeColor: const Color(0xFFB8FF57),
                activeTrackColor: const Color(0xFFB8FF57).withOpacity(0.3),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _showDeviceSettingsDialog(device, room),
                  icon: Icon(Icons.settings, size: 18),
                  label: Text('إعدادات'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[300],
                    backgroundColor: const Color(0xFF2D3548),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddRoomButton() {
    return InkWell(
      onTap: () => _showAddRoomDialog(),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2538),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFB8FF57).withOpacity(0.3),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: const Color(0xFFB8FF57)),
            const SizedBox(width: 10),
            Text(
              'إضافة غرفة جديدة',
              style: TextStyle(
                color: const Color(0xFFB8FF57),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getUsageColor(int usage) {
    if (usage >= 80) return const Color(0xFFFF6B6B);
    if (usage >= 50) return const Color(0xFFFFB84D);
    return const Color(0xFF4ECDC4);
  }

  // Dialog Methods
  void _showAddRoomDialog() {
    var cubit = context.read<DevicesCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2538),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('إضافة غرفة جديدة', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: cubit.nameCont,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'اسم الغرفة',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF2D3548)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFFB8FF57)),
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (cubit.nameCont.text.isNotEmpty) {
                cubit.manageRoom();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB8FF57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'إضافة',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditRoomDialog(RoomModel room) {
    final cubit = context.read<DevicesCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2538),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('تعديل الغرفة', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: cubit.nameCont,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'اسم الغرفة',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF2D3548)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFFB8FF57)),
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (cubit.nameCont.text.isNotEmpty) {
                context.read<DevicesCubit>().manageRoom(roomId: room.id!);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB8FF57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'حفظ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteRoomDialog(RoomModel room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2538),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('حذف الغرفة', style: TextStyle(color: Colors.white)),
        content: Text(
          'هل أنت متأكد من حذف "${room.name}"؟\nسيتم حذف جميع الأجهزة في هذه الغرفة.',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DevicesCubit>().deleteRoom(roomId: room.id!);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'حذف',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDeviceDialog(RoomModel room) {
    var cubit = context.read<DevicesCubit>();
    cubit.clear();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E2538),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('إضافة جهاز جديد', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<DeviceTypes>(
                  value: cubit.selectedType,
                  decoration: InputDecoration(
                    labelText: 'نوع الجهاز',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color(0xFF2D3548)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color(0xFFB8FF57)),
                    ),
                  ),
                  dropdownColor: const Color(0xFF1E2538),
                  style: TextStyle(color: Colors.white),
                  items: DeviceTypes.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(
                            type.icon,
                            size: 20,
                            color: const Color(0xFFB8FF57),
                          ),
                          SizedBox(width: 10),
                          Text(type.ar),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      cubit.selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: cubit.nameCont,
                  decoration: InputDecoration(
                    labelText: 'اسم الجهاز (اختياري)',
                    hintText: 'اترك فارغاً لاستخدام الاسم الافتراضي',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color(0xFF2D3548)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color(0xFFB8FF57)),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: cubit.kwhCont,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,3}$'),
                    ),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'استهلاك الطاقة (كيلوواط)',
                    hintText: '2.5',

                    labelStyle: TextStyle(color: Colors.grey),
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color(0xFF2D3548)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: const Color(0xFFB8FF57)),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final kwh = double.tryParse(cubit.kwhCont.text) ?? 0.0;
                if (kwh > 0) {
                  context.read<DevicesCubit>().manageDevice(roomId: room.id!);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8FF57),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'إضافة',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeviceSettingsDialog(Device device, RoomModel room) {
    var cubit = context.read<DevicesCubit>();
    cubit.nameCont.text = device.name!;
    cubit.kwhCont.text = device.kwhValue.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2538),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('إعدادات الجهاز', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cubit.nameCont,
                decoration: InputDecoration(
                  labelText: 'اسم الجهاز',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: const Color(0xFF2D3548)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: const Color(0xFFB8FF57)),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cubit.kwhCont,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'استهلاك الطاقة (كيلوواط)',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: const Color(0xFF2D3548)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: const Color(0xFFB8FF57)),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Divider(color: const Color(0xFF2D3548)),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('حذف الجهاز', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteDeviceDialog(device, room);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final kwh =
                  double.tryParse(cubit.kwhCont.text) ?? device.kwhValue;
              if (cubit.nameCont.text.isNotEmpty && kwh != null) {
                context.read<DevicesCubit>().manageDevice(
                  deviceId: device.id!,
                  roomId: device.roomId!,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB8FF57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'حفظ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDeviceDialog(Device device, RoomModel room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2538),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('حذف الجهاز', style: TextStyle(color: Colors.white)),
        content: Text(
          'هل أنت متأكد من حذف "${device.name}"؟',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DevicesCubit>().deleteDevice(deviceId: device.id!);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'حذف',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
