import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/blocs/dash_bloc/dash_cubit.dart';
import 'package:volty/models/auth_model.dart';
import 'package:volty/src/app_colors.dart';
import 'package:volty/src/app_globals.dart';
import 'package:volty/src/app_localization.dart';
import 'package:volty/src/app_string.dart';
import 'package:volty/components/general/my_field.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Menu Button
        GestureDetector(
          onTap: () => _showSidebarSwitcher(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.secondaryGradient,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.menu_rounded,
              color: AppColors.inputBg,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Welcome Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    AppString.welcomeBack.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      '${AppGlobals.currentUser!.name?.split(' ')[0]} 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                spacing: 4,
                children: [
                  Icon(Icons.location_on, color: Colors.grey[400], size: 13),

                  Flexible(
                    child: Text(
                      '${AppGlobals.currentHouse!.name} - ${AppGlobals.currentHouse!.houseCity}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          AppGlobals.currentHouse?.currentTempIcon,
                          color: AppColors.primary,
                          size: 8,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${AppGlobals.currentHouse?.currentTemp}°',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // Notification
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2538),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF2D3548)),
          ),
          child: Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
                size: 24,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1E2538),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSidebarSwitcher(BuildContext context) {
    final houses = _getSampleHouses();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => Align(
        alignment: AppLocalization.isArabic(context)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Material(
          color: AppColors.backGround.withOpacity(0.5),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: AppLocalization.isArabic(context)
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.secondaryGradient,
                      ),
                      borderRadius: AppLocalization.isArabic(context)
                          ? BorderRadius.only(topLeft: Radius.circular(30))
                          : BorderRadius.only(topRight: Radius.circular(30)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.home_work_rounded,
                            color: AppColors.inputBg,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppString.myHouses.tr(),
                                style: const TextStyle(
                                  color: AppColors.inputBg,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${houses.length} ${AppString.houses.tr()}',
                                style: TextStyle(
                                  color: AppColors.inputBg.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.inputBg,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: AppGlobals.allHouses?.length ?? 0,
                      itemBuilder: (context, index) {
                        final house = AppGlobals.allHouses![index];
                        return _buildSidebarHouseCard(
                          context,
                          household: house,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showAddHouseDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_home_rounded,
                            color: AppColors.inputBg,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppString.addNewHouse.tr(),
                            style: const TextStyle(
                              color: AppColors.inputBg,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: Offset(AppLocalization.isArabic(context) ? 1 : -1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        );
      },
    );
  }

  Widget _buildSidebarHouseCard(
    BuildContext context, {
    required Household household,
  }) {
    var cubit = context.read<DashCubit>();
    bool isActive = household.id == AppGlobals.currentHouse?.id;
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        await cubit.switchHousehold(houseId: household.id!);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.secondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : const Color(0xFF3D4558),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    color: isActive ? AppColors.inputBg : AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              household.name ?? "Household Name",
                              style: TextStyle(
                                color: isActive
                                    ? AppColors.inputBg
                                    : Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                AppString.active.tr(),
                                style: const TextStyle(
                                  color: AppColors.inputBg,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          // else
                          //   Container(
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 10,
                          //       vertical: 4,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white.withOpacity(0.2),
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //     child: Icon(
                          //       Icons.edit_rounded,
                          //       size: 10,
                          //       color: AppColors.inputBg,
                          //     ),
                          //   ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: isActive
                                ? AppColors.inputBg.withOpacity(0.8)
                                : Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${household.houseCity}, ${household.houseCountry}',
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.inputBg.withOpacity(0.8)
                                  : Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withOpacity(0.15)
                    : const Color(0xFF1E2538),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.meeting_room_rounded,
                        size: 18,
                        color: isActive ? AppColors.inputBg : AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            household.roomsCount.toString(),
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.inputBg
                                  : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppString.rooms.tr(),
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.inputBg.withOpacity(0.7)
                                  : Colors.grey[500],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: isActive
                        ? Colors.white.withOpacity(0.3)
                        : Colors.grey[700],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.devices_rounded,
                        size: 18,
                        color: isActive ? AppColors.inputBg : AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            household.devicesCount.toString(),
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.inputBg
                                  : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppString.devicesTitle.tr(),
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.inputBg.withOpacity(0.7)
                                  : Colors.grey[500],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> _getSampleHouses() {
  return [
    {
      'id': '1',
      'name': 'Home',
      'city': 'New York',
      'country': 'USA',
      'rooms': 5,
      'devices': 12,
      'isActive': true,
    },
    {
      'id': '2',
      'name': 'Beach House',
      'city': 'Miami',
      'country': 'USA',
      'rooms': 3,
      'devices': 8,
      'isActive': false,
    },
    {
      'id': '3',
      'name': 'Mountain Cabin',
      'city': 'Aspen',
      'country': 'USA',
      'rooms': 2,
      'devices': 5,
      'isActive': false,
    },
  ];
}

void _showAddHouseDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  DashCubit cubit = context.read<DashCubit>();
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: 450,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2538),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFF2D3548)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.secondaryGradient,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.add_home_rounded,
                          color: AppColors.inputBg,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.addNewHouse.tr(),
                              style: const TextStyle(
                                color: AppColors.inputBg,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppString.houseDetails.tr(),
                              style: TextStyle(
                                color: AppColors.inputBg.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.inputBg,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3548),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  AppString.houseStepInfo.tr(),
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        MyField(
                          controller: cubit.hNameCont,
                          hint: AppString.houseName.tr(),
                          icon: Icons.house_rounded,
                        ),
                        const SizedBox(height: 16),
                        MyField(
                          controller: cubit.hCountryCont,
                          hint: AppString.country.tr(),
                          icon: Icons.public_rounded,
                        ),
                        const SizedBox(height: 16),
                        MyField(
                          controller: cubit.hCityCont,
                          hint: AppString.city.tr(),
                          icon: Icons.location_city_rounded,
                        ),
                        const SizedBox(height: 16),
                        MyField(
                          controller: cubit.hAddressCont,
                          hint: AppString.address.tr(),
                          icon: Icons.location_on_rounded,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFF2D3548))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF2D3548)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppString.cancel.tr(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              cubit.manageHousehold(houseId: '0');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppString.create.tr(),
                            style: const TextStyle(
                              color: AppColors.inputBg,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
