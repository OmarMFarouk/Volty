import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:volty/src/app_globals.dart';
import 'package:volty/src/app_string.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 5,
                children: [
                  Text(
                    AppString.welcomeBack.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${AppGlobals.currentUser!.name?.split(' ')[0]}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    '👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[400], size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${AppGlobals.currentHouse!.name} - ${AppGlobals.currentHouse!.houseCity}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8FF57).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wb_sunny,
                          color: const Color(0xFFB8FF57),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '28°',
                          style: TextStyle(
                            color: const Color(0xFFB8FF57),
                            fontSize: 11,
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
        Row(
          children: [
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
                    color: Color(0xFFB8FF57),
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
        ),
      ],
    );
  }
}
