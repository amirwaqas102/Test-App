import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/custom_colors.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  int selectedWeek = 2;
  int totalWeeks = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.black,
      appBar: AppBar(
        backgroundColor: CustomColors.black,
        elevation: 0,
        title: Text(
          'Training Calendar',
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Save',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Divider(height: 2, color: Colors.blue),
          const SizedBox(height: 20),
          _buildWeekHeader(),
          const Divider(height: 1, color: Colors.white10),
          Expanded(child: _buildWeekList()),
        ],
      ),
    );
  }

  Widget _buildWeekHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.black38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _showWeekPicker,
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 18, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text('Week $selectedWeek/$totalWeeks',
                        style: GoogleFonts.rubik(
                            color: Colors.white70, fontSize: 15)),
                    const Icon(Icons.keyboard_arrow_down,
                        color: Colors.white70, size: 18),
                  ],
                ),
              ),
              Text('Total: 60min',
                  style: GoogleFonts.rubik(
                      color: Colors.white70, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _getWeekDateRange(selectedWeek),
            style: GoogleFonts.rubik(
              color: Colors.white38,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekList() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayNumbers = [8, 9, 10, 11, 12, 13, 14];

    final weekWorkouts = {
      1: {
        'Mon': {'title': 'Arm Blaster', 'type': 'Arms Workout', 'color': CustomColors.green},
        'Thu': {'title': 'Leg Day Blitz', 'type': 'Leg Workout', 'color': CustomColors.blue},
      },
      2: {
        'Wed': {'title': 'Muscle Builder', 'type': 'Full Body Workout', 'color': Colors.redAccent},
        'Sat': {'title': 'Arm Blaster', 'type': 'Arms Workout', 'color': CustomColors.green},
      },
      3: {
        'Tue': {'title': 'Muscle Builder', 'type': 'Chest & Core', 'color': CustomColors.circleOrange},
        'Fri': {'title': 'Leg Day Blitz', 'type': 'Leg Workout', 'color': CustomColors.blue},
      },
      4: {
        'Mon': {'title': 'Cardio Rush', 'type': 'HIIT', 'color': CustomColors.circlePurple},
        'Thu': {'title': 'Arm Blaster', 'type': 'Arms Workout', 'color': CustomColors.green},
      }
    };

    // show current and next week
    final nextWeek = (selectedWeek < totalWeeks) ? selectedWeek + 1 : selectedWeek;
    final weeksToShow = [selectedWeek, nextWeek];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: weeksToShow.length,
      itemBuilder: (context, wIndex) {
        final week = weeksToShow[wIndex];
        final workouts = weekWorkouts[week] ?? {};

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'WEEK $week',
                style: GoogleFonts.rubik(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Column(
              children: List.generate(days.length, (i) {
                final day = days[i];
                final dateNum = dayNumbers[i];
                final hasWorkout = workouts.containsKey(day);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(day,
                                style: GoogleFonts.rubik(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            Text('$dateNum',
                                style: GoogleFonts.rubik(
                                    color: Colors.white38,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: hasWorkout
                            ? _buildWorkoutCard(
                          workouts[day]!['title']! as String,
                          workouts[day]!['type']! as String,
                          workouts[day]!['color'] as Color,
                        )
                            : const Divider(
                            color: Colors.white12, height: 20, thickness: 1),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }


  Widget _buildWorkoutCard(String title, String type, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            ),
          ),
          Expanded(
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      type,
                      style: GoogleFonts.rubik(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  title,
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              trailing: Text(
                '25m - 30m',
                style: GoogleFonts.rubik(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWeekPicker() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalWeeks, (i) {
          final weekNum = i + 1;
          final isSelected = weekNum == selectedWeek;
          return ListTile(
            title: Text('Week $weekNum',
                style: GoogleFonts.rubik(
                    color: isSelected ? CustomColors.circleGreen : Colors.white70,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400)),
            onTap: () => Navigator.pop(context, weekNum),
          );
        }),
      ),
    );

    if (selected != null && selected != selectedWeek) {
      setState(() => selectedWeek = selected);
    }
  }

  String _getWeekDateRange(int week) {
    switch (week) {
      case 1:
        return 'December 1 - 7';
      case 2:
        return 'December 8 - 14';
      case 3:
        return 'December 15 - 21';
      case 4:
        return 'December 22 - 28';
      default:
        return 'December';
    }
  }
}