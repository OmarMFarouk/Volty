// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:volty/src/app_colors.dart';
// import 'package:volty/src/app_globals.dart';
// import 'package:volty/src/app_string.dart';
// import 'package:volty/components/general/my_field.dart';

// // ============================================================================
// // CONCEPT 1: COMPACT DROPDOWN STYLE
// // Welcome text + temperature on top, house switcher as dropdown below
// // ============================================================================
// class HeaderConcept1 extends StatelessWidget {
//   const HeaderConcept1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Welcome Row
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         AppString.welcomeBack.tr(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(width: 5),
//                       Flexible(
//                         child: Text(
//                           '${AppGlobals.currentUser!.name?.split(' ')[0]}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                       const Text(
//                         '👋',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         color: Colors.grey[400],
//                         size: 14,
//                       ),
//                       const SizedBox(width: 4),
//                       Flexible(
//                         child: Text(
//                           '${AppGlobals.currentHouse!.name} - ${AppGlobals.currentHouse!.houseCity}',
//                           style: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 14,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               AppGlobals.currentHouse?.currentTempIcon,
//                               color: AppColors.primary,
//                               size: 12,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               '${AppGlobals.currentHouse?.currentTemp}°',
//                               style: const TextStyle(
//                                 color: AppColors.primary,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Notification Icon
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E2538),
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: const Color(0xFF2D3548)),
//               ),
//               child: Stack(
//                 children: [
//                   const Icon(
//                     Icons.notifications_outlined,
//                     color: AppColors.primary,
//                     size: 24,
//                   ),
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     child: Container(
//                       width: 8,
//                       height: 8,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFF6B6B),
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: const Color(0xFF1E2538),
//                           width: 1.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
//         // House Switcher Button
//         GestureDetector(
//           onTap: () => _showDropdownSwitcher(context),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: AppColors.secondaryGradient,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primary.withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.home_rounded,
//                     color: AppColors.inputBg,
//                     size: 22,
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         AppGlobals.currentHouse!.name ?? "My House",
//                         style: const TextStyle(
//                           color: AppColors.inputBg,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         AppString.switchHouse.tr(),
//                         style: TextStyle(
//                           color: AppColors.inputBg.withOpacity(0.8),
//                           fontSize: 11,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(
//                   Icons.unfold_more_rounded,
//                   color: AppColors.inputBg,
//                   size: 24,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showDropdownSwitcher(BuildContext context) {
//     final houses = _getSampleHouses();

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFF1E2538),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12, bottom: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[600],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.swap_horiz_rounded,
//                       color: AppColors.primary,
//                       size: 28,
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       AppString.switchHouse.tr(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ...houses.map(
//                 (house) => _buildDropdownHouseItem(
//                   context,
//                   name: house['name'] as String,
//                   city: house['city'] as String,
//                   country: house['country'] as String,
//                   isActive: house['isActive'] as bool,
//                   onTap: () {
//                     Navigator.pop(context);
//                     // TODO: Switch house
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     _showAddHouseDialog(context);
//                   },
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: AppColors.primary,
//                     side: const BorderSide(color: AppColors.primary, width: 2),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.add_circle_outline_rounded, size: 22),
//                       const SizedBox(width: 10),
//                       Text(
//                         AppString.addNewHouse.tr(),
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownHouseItem(
//     BuildContext context, {
//     required String name,
//     required String city,
//     required String country,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isActive
//               ? AppColors.primary.withOpacity(0.15)
//               : const Color(0xFF2D3548),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isActive ? AppColors.primary : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               Icons.home_rounded,
//               color: isActive ? AppColors.primary : Colors.grey[400],
//               size: 24,
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: TextStyle(
//                       color: isActive ? Colors.white : Colors.grey[300],
//                       fontSize: 15,
//                       fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
//                     ),
//                   ),
//                   Text(
//                     '$city, $country',
//                     style: TextStyle(color: Colors.grey[500], fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             if (isActive)
//               const Icon(
//                 Icons.check_circle_rounded,
//                 color: AppColors.primary,
//                 size: 24,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // CONCEPT 2: INTEGRATED CAROUSEL STYLE
// // Welcome text inline with carousel switcher
// // ============================================================================
// class HeaderConcept2 extends StatefulWidget {
//   const HeaderConcept2({super.key});

//   @override
//   State<HeaderConcept2> createState() => _HeaderConcept2State();
// }

// class _HeaderConcept2State extends State<HeaderConcept2> {
//   final PageController _pageController = PageController(viewportFraction: 0.9);
//   int _currentPage = 0;
//   final houses = _getSampleHouses();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Welcome Row with Notification
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   Text(
//                     AppString.welcomeBack.tr(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 5),
//                   Flexible(
//                     child: Text(
//                       '${AppGlobals.currentUser!.name?.split(' ')[0]} 👋',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         AppGlobals.currentHouse?.currentTempIcon,
//                         color: AppColors.primary,
//                         size: 14,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${AppGlobals.currentHouse?.currentTemp}°',
//                         style: const TextStyle(
//                           color: AppColors.primary,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1E2538),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: const Color(0xFF2D3548)),
//                   ),
//                   child: Stack(
//                     children: [
//                       const Icon(
//                         Icons.notifications_outlined,
//                         color: AppColors.primary,
//                         size: 22,
//                       ),
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: Container(
//                           width: 7,
//                           height: 7,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFF6B6B),
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: const Color(0xFF1E2538),
//                               width: 1.5,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
//         // House Carousel
//         SizedBox(
//           height: 130,
//           child: PageView.builder(
//             controller: _pageController,
//             onPageChanged: (index) {
//               if (index < houses.length) {
//                 setState(() => _currentPage = index);
//                 // TODO: Switch to house at index
//               }
//             },
//             itemCount: houses.length + 1,
//             itemBuilder: (context, index) {
//               if (index == houses.length) {
//                 return _buildAddHouseCard(context);
//               }
//               final house = houses[index];
//               final isActive = index == _currentPage;
//               return AnimatedScale(
//                 scale: isActive ? 1.0 : 0.92,
//                 duration: const Duration(milliseconds: 300),
//                 child: _buildHouseCarouselCard(
//                   context,
//                   name: house['name'] as String,
//                   city: house['city'] as String,
//                   country: house['country'] as String,
//                   rooms: house['rooms'] as int,
//                   devices: house['devices'] as int,
//                   isActive: isActive,
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 10),
//         // Dots Indicator
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(
//             houses.length + 1,
//             (index) => AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 3),
//               width: _currentPage == index ? 20 : 6,
//               height: 6,
//               decoration: BoxDecoration(
//                 gradient: _currentPage == index
//                     ? const LinearGradient(colors: AppColors.secondaryGradient)
//                     : null,
//                 color: _currentPage == index ? null : Colors.grey[700],
//                 borderRadius: BorderRadius.circular(3),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHouseCarouselCard(
//     BuildContext context, {
//     required String name,
//     required String city,
//     required String country,
//     required int rooms,
//     required int devices,
//     required bool isActive,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: isActive
//             ? const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: AppColors.secondaryGradient,
//               )
//             : null,
//         color: isActive ? null : const Color(0xFF1E2538),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: isActive ? AppColors.primary : const Color(0xFF2D3548),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: isActive
//                 ? AppColors.primary.withOpacity(0.3)
//                 : Colors.black26,
//             blurRadius: isActive ? 12 : 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: isActive
//                       ? Colors.white.withOpacity(0.2)
//                       : AppColors.primary.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   Icons.home_rounded,
//                   color: isActive ? AppColors.inputBg : AppColors.primary,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: TextStyle(
//                         color: isActive ? AppColors.inputBg : Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Text(
//                       '$city, $country',
//                       style: TextStyle(
//                         color: isActive
//                             ? AppColors.inputBg.withOpacity(0.8)
//                             : Colors.grey[400],
//                         fontSize: 11,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Icon(
//                 Icons.meeting_room_rounded,
//                 size: 14,
//                 color: isActive ? AppColors.inputBg : AppColors.primary,
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 '$rooms ${AppString.rooms.tr()}',
//                 style: TextStyle(
//                   color: isActive ? AppColors.inputBg : Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Icon(
//                 Icons.devices_rounded,
//                 size: 14,
//                 color: isActive ? AppColors.inputBg : AppColors.primary,
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 '$devices ${AppString.devicesTitle.tr()}',
//                 style: TextStyle(
//                   color: isActive ? AppColors.inputBg : Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAddHouseCard(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showAddHouseDialog(context),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E2538),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: AppColors.primary, width: 2),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(colors: AppColors.secondaryGradient),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.add_rounded,
//                 color: AppColors.inputBg,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               AppString.addNewHouse.tr(),
//               style: const TextStyle(
//                 color: AppColors.primary,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // CONCEPT 3: SPLIT LAYOUT STYLE
// // Welcome on left, house switcher + temp + notification on right
// // ============================================================================
// class HeaderConcept3 extends StatelessWidget {
//   const HeaderConcept3({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Left: Welcome Message
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         AppString.welcomeBack.tr(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(width: 5),
//                       const Text(
//                         '👋',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${AppGlobals.currentUser!.name?.split(' ')[0]}',
//                     style: TextStyle(color: Colors.grey[400], fontSize: 15),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Right: Actions
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             AppGlobals.currentHouse?.currentTempIcon,
//                             color: AppColors.primary,
//                             size: 14,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${AppGlobals.currentHouse?.currentTemp}°',
//                             style: const TextStyle(
//                               color: AppColors.primary,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1E2538),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: const Color(0xFF2D3548)),
//                       ),
//                       child: Stack(
//                         children: [
//                           const Icon(
//                             Icons.notifications_outlined,
//                             color: AppColors.primary,
//                             size: 22,
//                           ),
//                           Positioned(
//                             right: 0,
//                             top: 0,
//                             child: Container(
//                               width: 7,
//                               height: 7,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFFF6B6B),
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: const Color(0xFF1E2538),
//                                   width: 1.5,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
//         // House Switcher with Grid Icon
//         GestureDetector(
//           onTap: () => _showGridSwitcher(context),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: AppColors.secondaryGradient,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primary.withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Stack(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: const Icon(
//                         Icons.home_rounded,
//                         color: AppColors.inputBg,
//                         size: 24,
//                       ),
//                     ),
//                     Positioned(
//                       right: -2,
//                       top: -2,
//                       child: Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFFF6B6B),
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: AppColors.primary,
//                             width: 2,
//                           ),
//                         ),
//                         child: const Text(
//                           '3',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 9,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         AppGlobals.currentHouse!.name ?? "My House",
//                         style: const TextStyle(
//                           color: AppColors.inputBg,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 2),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on,
//                             size: 12,
//                             color: AppColors.inputBg.withOpacity(0.8),
//                           ),
//                           const SizedBox(width: 4),
//                           Flexible(
//                             child: Text(
//                               '${AppGlobals.currentHouse!.houseCity}, ${AppGlobals.currentHouse!.houseCountry}',
//                               style: TextStyle(
//                                 color: AppColors.inputBg.withOpacity(0.8),
//                                 fontSize: 11,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(
//                   Icons.grid_view_rounded,
//                   color: AppColors.inputBg,
//                   size: 24,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showGridSwitcher(BuildContext context) {
//     final houses = _getSampleHouses();

//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 500),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1E2538),
//             borderRadius: BorderRadius.circular(30),
//             border: Border.all(color: const Color(0xFF2D3548)),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: AppColors.secondaryGradient,
//                     ),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.home_work_rounded,
//                         color: AppColors.inputBg,
//                         size: 28,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           AppString.myHouses.tr(),
//                           style: const TextStyle(
//                             color: AppColors.inputBg,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(
//                           Icons.close_rounded,
//                           color: AppColors.inputBg,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 12,
//                           mainAxisSpacing: 12,
//                           childAspectRatio: 0.9,
//                         ),
//                     itemCount: houses.length + 1,
//                     itemBuilder: (context, index) {
//                       if (index == houses.length) {
//                         return _buildAddHouseGridCard(context);
//                       }
//                       final house = houses[index];
//                       return _buildHouseGridCard(
//                         context,
//                         name: house['name'] as String,
//                         city: house['city'] as String,
//                         rooms: house['rooms'] as int,
//                         devices: house['devices'] as int,
//                         isActive: house['isActive'] as bool,
//                         onTap: () {
//                           Navigator.pop(context);
//                           // TODO: Switch house
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHouseGridCard(
//     BuildContext context, {
//     required String name,
//     required String city,
//     required int rooms,
//     required int devices,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: isActive
//               ? const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: AppColors.secondaryGradient,
//                 )
//               : null,
//           color: isActive ? null : const Color(0xFF2D3548),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isActive ? AppColors.primary : const Color(0xFF3D4558),
//             width: isActive ? 2 : 1,
//           ),
//           boxShadow: isActive
//               ? [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: isActive
//                         ? Colors.white.withOpacity(0.2)
//                         : AppColors.primary.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.home_rounded,
//                     color: isActive ? AppColors.inputBg : AppColors.primary,
//                     size: 24,
//                   ),
//                 ),
//                 if (isActive)
//                   const Icon(
//                     Icons.check_circle_rounded,
//                     color: AppColors.inputBg,
//                     size: 22,
//                   ),
//               ],
//             ),
//             const Spacer(),
//             Text(
//               name,
//               style: TextStyle(
//                 color: isActive ? AppColors.inputBg : Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               city,
//               style: TextStyle(
//                 color: isActive
//                     ? AppColors.inputBg.withOpacity(0.7)
//                     : Colors.grey[400],
//                 fontSize: 11,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Icon(
//                   Icons.meeting_room_rounded,
//                   size: 14,
//                   color: isActive ? AppColors.inputBg : AppColors.primary,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   rooms.toString(),
//                   style: TextStyle(
//                     color: isActive ? AppColors.inputBg : Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Icon(
//                   Icons.devices_rounded,
//                   size: 14,
//                   color: isActive ? AppColors.inputBg : AppColors.primary,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   devices.toString(),
//                   style: TextStyle(
//                     color: isActive ? AppColors.inputBg : Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddHouseGridCard(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pop(context);
//         _showAddHouseDialog(context);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFF2D3548),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: AppColors.primary, width: 2),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(colors: AppColors.secondaryGradient),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.add_rounded,
//                 color: AppColors.inputBg,
//                 size: 28,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               AppString.addNewHouse.tr(),
//               style: const TextStyle(
//                 color: AppColors.primary,
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // CONCEPT 4: SIDEBAR MENU STYLE
// // Traditional welcome header with menu button that opens sidebar
// // ============================================================================
// class HeaderConcept4 extends StatelessWidget {
//   const HeaderConcept4({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // Menu Button
//         GestureDetector(
//           onTap: () => _showSidebarSwitcher(context),
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: AppColors.secondaryGradient,
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primary.withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.menu_rounded,
//               color: AppColors.inputBg,
//               size: 26,
//             ),
//           ),
//         ),
//         const SizedBox(width: 14),
//         // Welcome Text
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     AppString.welcomeBack.tr(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 5),
//                   Flexible(
//                     child: Text(
//                       '${AppGlobals.currentUser!.name?.split(' ')[0]} 👋',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 spacing: 4,
//                 children: [
//                   Icon(Icons.location_on, color: Colors.grey[400], size: 13),

//                   Flexible(
//                     child: Text(
//                       '${AppGlobals.currentHouse!.name} - ${AppGlobals.currentHouse!.houseCity}',
//                       style: TextStyle(color: Colors.grey[400], fontSize: 13),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 5,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.primary.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           AppGlobals.currentHouse?.currentTempIcon,
//                           color: AppColors.primary,
//                           size: 8,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           '${AppGlobals.currentHouse?.currentTemp}°',
//                           style: const TextStyle(
//                             color: AppColors.primary,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 10),

//         // Notification
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1E2538),
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(color: const Color(0xFF2D3548)),
//           ),
//           child: Stack(
//             children: [
//               const Icon(
//                 Icons.notifications_outlined,
//                 color: AppColors.primary,
//                 size: 24,
//               ),
//               Positioned(
//                 right: 0,
//                 top: 0,
//                 child: Container(
//                   width: 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFF6B6B),
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: const Color(0xFF1E2538),
//                       width: 1.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void _showSidebarSwitcher(BuildContext context) {
//     final houses = _getSampleHouses();

//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: 'Dismiss',
//       barrierColor: Colors.black54,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, animation, secondaryAnimation) => Align(
//         alignment: Alignment.centerLeft,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.85,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF1E2538), Color(0xFF161B2D)],
//               ),
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//             child: SafeArea(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: AppColors.secondaryGradient,
//                       ),
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: const Icon(
//                             Icons.home_work_rounded,
//                             color: AppColors.inputBg,
//                             size: 28,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 AppString.myHouses.tr(),
//                                 style: const TextStyle(
//                                   color: AppColors.inputBg,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 '${houses.length} ${AppString.houses.tr()}',
//                                 style: TextStyle(
//                                   color: AppColors.inputBg.withOpacity(0.8),
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: const Icon(
//                             Icons.close_rounded,
//                             color: AppColors.inputBg,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       padding: const EdgeInsets.all(20),
//                       itemCount: houses.length,
//                       itemBuilder: (context, index) {
//                         final house = houses[index];
//                         return _buildSidebarHouseCard(
//                           context,
//                           name: house['name'] as String,
//                           city: house['city'] as String,
//                           country: house['country'] as String,
//                           rooms: house['rooms'] as int,
//                           devices: house['devices'] as int,
//                           isActive: house['isActive'] as bool,
//                           onTap: () {
//                             Navigator.pop(context);
//                             // TODO: Switch house
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _showAddHouseDialog(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.add_home_rounded,
//                             color: AppColors.inputBg,
//                             size: 24,
//                           ),
//                           const SizedBox(width: 12),
//                           Text(
//                             AppString.addNewHouse.tr(),
//                             style: const TextStyle(
//                               color: AppColors.inputBg,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return SlideTransition(
//           position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
//               .animate(
//                 CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
//               ),
//           child: child,
//         );
//       },
//     );
//   }

//   Widget _buildSidebarHouseCard(
//     BuildContext context, {
//     required String name,
//     required String city,
//     required String country,
//     required int rooms,
//     required int devices,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           gradient: isActive
//               ? const LinearGradient(colors: AppColors.secondaryGradient)
//               : null,
//           color: isActive ? null : const Color(0xFF2D3548),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isActive ? AppColors.primary : const Color(0xFF3D4558),
//             width: isActive ? 2 : 1,
//           ),
//           boxShadow: isActive
//               ? [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: isActive
//                         ? Colors.white.withOpacity(0.2)
//                         : AppColors.primary.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Icon(
//                     Icons.home_rounded,
//                     color: isActive ? AppColors.inputBg : AppColors.primary,
//                     size: 26,
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               name,
//                               style: TextStyle(
//                                 color: isActive
//                                     ? AppColors.inputBg
//                                     : Colors.white,
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           if (isActive)
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 AppString.active.tr(),
//                                 style: const TextStyle(
//                                   color: AppColors.inputBg,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on,
//                             size: 12,
//                             color: isActive
//                                 ? AppColors.inputBg.withOpacity(0.8)
//                                 : Colors.grey[400],
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             '$city, $country',
//                             style: TextStyle(
//                               color: isActive
//                                   ? AppColors.inputBg.withOpacity(0.8)
//                                   : Colors.grey[400],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: isActive
//                     ? Colors.white.withOpacity(0.15)
//                     : const Color(0xFF1E2538),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.meeting_room_rounded,
//                         size: 18,
//                         color: isActive ? AppColors.inputBg : AppColors.primary,
//                       ),
//                       const SizedBox(width: 8),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             rooms.toString(),
//                             style: TextStyle(
//                               color: isActive
//                                   ? AppColors.inputBg
//                                   : Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             AppString.rooms.tr(),
//                             style: TextStyle(
//                               color: isActive
//                                   ? AppColors.inputBg.withOpacity(0.7)
//                                   : Colors.grey[500],
//                               fontSize: 10,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Container(
//                     width: 1,
//                     height: 30,
//                     color: isActive
//                         ? Colors.white.withOpacity(0.3)
//                         : Colors.grey[700],
//                   ),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.devices_rounded,
//                         size: 18,
//                         color: isActive ? AppColors.inputBg : AppColors.primary,
//                       ),
//                       const SizedBox(width: 8),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             devices.toString(),
//                             style: TextStyle(
//                               color: isActive
//                                   ? AppColors.inputBg
//                                   : Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             AppString.devicesTitle.tr(),
//                             style: TextStyle(
//                               color: isActive
//                                   ? AppColors.inputBg.withOpacity(0.7)
//                                   : Colors.grey[500],
//                               fontSize: 10,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // SHARED UTILITIES
// // ============================================================================

// List<Map<String, dynamic>> _getSampleHouses() {
//   return [
//     {
//       'id': '1',
//       'name': 'Home',
//       'city': 'New York',
//       'country': 'USA',
//       'rooms': 5,
//       'devices': 12,
//       'isActive': true,
//     },
//     {
//       'id': '2',
//       'name': 'Beach House',
//       'city': 'Miami',
//       'country': 'USA',
//       'rooms': 3,
//       'devices': 8,
//       'isActive': false,
//     },
//     {
//       'id': '3',
//       'name': 'Mountain Cabin',
//       'city': 'Aspen',
//       'country': 'USA',
//       'rooms': 2,
//       'devices': 5,
//       'isActive': false,
//     },
//   ];
// }

// void _showAddHouseDialog(BuildContext context) {
//   final houseNameCont = TextEditingController();
//   final countryCont = TextEditingController();
//   final cityCont = TextEditingController();
//   final addressCont = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   showDialog(
//     context: context,
//     builder: (context) => StatefulBuilder(
//       builder: (context, setDialogState) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.8,
//             maxWidth: 450,
//           ),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1E2538),
//             borderRadius: BorderRadius.circular(25),
//             border: Border.all(color: const Color(0xFF2D3548)),
//           ),
//           child: Form(
//             key: formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: AppColors.secondaryGradient,
//                     ),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(25),
//                       topRight: Radius.circular(25),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Icon(
//                           Icons.add_home_rounded,
//                           color: AppColors.inputBg,
//                           size: 26,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               AppString.addNewHouse.tr(),
//                               style: const TextStyle(
//                                 color: AppColors.inputBg,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               AppString.houseDetails.tr(),
//                               style: TextStyle(
//                                 color: AppColors.inputBg.withOpacity(0.8),
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(
//                           Icons.close_rounded,
//                           color: AppColors.inputBg,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Flexible(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF2D3548),
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: AppColors.primary.withOpacity(0.3),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.primary.withOpacity(0.15),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Icon(
//                                   Icons.info_outline_rounded,
//                                   color: AppColors.primary,
//                                   size: 22,
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   AppString.houseStepInfo.tr(),
//                                   style: TextStyle(
//                                     color: Colors.grey[300],
//                                     fontSize: 12,
//                                     height: 1.4,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         MyField(
//                           controller: houseNameCont,
//                           hint: AppString.houseName.tr(),
//                           icon: Icons.house_rounded,
//                         ),
//                         const SizedBox(height: 16),
//                         MyField(
//                           controller: countryCont,
//                           hint: AppString.country.tr(),
//                           icon: Icons.public_rounded,
//                         ),
//                         const SizedBox(height: 16),
//                         MyField(
//                           controller: cityCont,
//                           hint: AppString.city.tr(),
//                           icon: Icons.location_city_rounded,
//                         ),
//                         const SizedBox(height: 16),
//                         MyField(
//                           controller: addressCont,
//                           hint: AppString.address.tr(),
//                           icon: Icons.location_on_rounded,
//                           maxLines: 2,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: const BoxDecoration(
//                     border: Border(top: BorderSide(color: Color(0xFF2D3548))),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () => Navigator.pop(context),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.white,
//                             side: const BorderSide(color: Color(0xFF2D3548)),
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                           ),
//                           child: Text(
//                             AppString.cancel.tr(),
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         flex: 2,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (formKey.currentState!.validate()) {
//                               // TODO: Call cubit to create house
//                               Navigator.pop(context);
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primary,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                           ),
//                           child: Text(
//                             AppString.create.tr(),
//                             style: const TextStyle(
//                               color: AppColors.inputBg,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
