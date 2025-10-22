import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testapp/utils/custom_colors.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  static const bgCard = Color(0xFF101113);
  static const cardInner = Color(0xFF1A1C1E);
  static const accentTeal = Color(0xFF3EC6C0);
  static const accentGreen = Color(0xFF4AD07A);
  static const mutedText = Color(0xFF9A9A9A);
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopRow(),
                const SizedBox(height: 18),
                Text(  'Today, ${DateFormat('d MMM yyyy').format(DateTime.now())}',
                    style: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 14),
                _buildWeekRow(context),
                const SizedBox(height: 22),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Workout',
                        style: GoogleFonts.rubik(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    Spacer(),
                    const Icon(Icons.wb_sunny_outlined, color: Colors.white70, size: 25),
                    const SizedBox(width: 5),
                    Text('9°',
                        style: GoogleFonts.rubik(color: Colors.white70, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 26),
                _buildWorkoutsCard(),
                const SizedBox(height: 26),
                Text('My Insights',
                    style: GoogleFonts.rubik(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _buildInsightsRow(),
                const SizedBox(height: 20),
                _buildHydrationCard(),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.notifications_none, color: Colors.white70, size: 22),
        const Spacer(),
        Column(
          children: [
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 16, color: Colors.white70),
                const SizedBox(width: 6),
                Text('Week 1/4',
                    style: GoogleFonts.rubik(color: Colors.white70, fontSize: 15)),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 18),
              ],
            ),
          ],
        ),
        const Spacer(),

      ],
    );
  }

  Widget _buildWeekRow(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final days = ['M', 'TU', 'W', 'TH', 'F', 'SA', 'SU'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final dayDate = startOfWeek.add(Duration(days: i));

        final isSelected = dayDate.day == selectedDay.day &&
            dayDate.month == selectedDay.month &&
            dayDate.year == selectedDay.year;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDay = dayDate;
            });
            _showCalendarBottomSheet(context, dayDate);
          },
          child: Column(
            children: [
              Text(
                days[i],
                style: TextStyle(
                  color: isSelected ? CustomColors.green : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black87 : const Color(0xFF111213),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: accentGreen, width: 2.2)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${dayDate.day}',
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    color: isSelected ? accentGreen : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              if (isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                      color: accentGreen, shape: BoxShape.circle),
                )
              else
                const SizedBox(height: 6),
            ],
          ),
        );
      }),
    );
  }

  void _showCalendarBottomSheet(BuildContext context, DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF18181C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        DateTime focusedDay = selectedDay;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  TableCalendar(
                    focusedDay: focusedDay,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2100),
                    currentDay: DateTime.now(),
                    selectedDayPredicate: (day) =>
                        isSameDay(day, selectedDay),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        focusedDay = focused;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Selected: ${DateFormat('EEE, d MMM yyyy').format(selected)}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: GoogleFonts.rubik(
                          color: Colors.white, fontWeight: FontWeight.w600),
                      leftChevronIcon:
                      const Icon(Icons.chevron_left, color: Colors.white70),
                      rightChevronIcon:
                      const Icon(Icons.chevron_right, color: Colors.white70),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: const TextStyle(color: Colors.white60),
                      weekendStyle: const TextStyle(color: Colors.white60),
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: const TextStyle(color: Colors.white),
                      weekendTextStyle: const TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(
                        color: accentGreen.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildWorkoutsCard() {
    return Container(
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.6), offset: const Offset(0, 6), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          // left vertical bar
          Container(
            width: 8,
            height: 84,
            decoration: const BoxDecoration(
              color: accentTeal,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('December 22 - 25m - 30m',
                          style: GoogleFonts.rubik(color: mutedText, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text('Upper Body',
                          style: GoogleFonts.rubik(fontSize: 18, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: cardInner,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_right_alt_rounded, size: 30, color: Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInsightsRow() {
    return Row(
      children: [
        Expanded(
          child: _insightCardCalories(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _insightCardWeight(),
        ),
      ],
    );
  }

  Widget _insightCardCalories() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('550',
                style: GoogleFonts.rubik(fontSize: 34, fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            Text('Calories',
                style: GoogleFonts.rubik(fontSize: 14, color: mutedText)),
          ],
        ),
        const SizedBox(height: 6),
        Text('1950 Remaining', style: GoogleFonts.rubik(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: 550 / 2500,
            minHeight: 8,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(accentTeal),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0', style: GoogleFonts.rubik(color: Colors.white54, fontSize: 12)),
            Text('2500', style: GoogleFonts.rubik(color: Colors.white54, fontSize: 12)),
          ],
        )
      ]),
    );
  }

  Widget _insightCardWeight() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text('75', style: GoogleFonts.rubik(fontSize: 34, fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            Text('kg', style: GoogleFonts.rubik(fontSize: 16, color: Colors.white70)),
          ],
        ),
        const SizedBox(height: 6),
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
            child: Row(
              children: [
                const Icon(Icons.trending_up, size: 12, color: accentGreen),
                const SizedBox(width: 4),
                Text('+1.6kg', style: GoogleFonts.rubik(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Text('Weight', style: GoogleFonts.rubik(color: mutedText))
      ]),
    );
  }

  Widget _buildHydrationCard() {
    return Container(
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('0%',
                      style: GoogleFonts.rubik(
                          fontSize: 36, fontWeight: FontWeight.w700, color: CustomColors.blue)),
                  const SizedBox(height: 6),
                  Text('Hydration', style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Log Now', style: GoogleFonts.rubik(color: Colors.white60)),
                ]),
              ),

              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Positioned.fill(
                        right: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text('2 L',
                                  style: GoogleFonts.rubik(
                                      color: Colors.white60,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text('0 L',
                                  style: GoogleFonts.rubik(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ],
                        ),
                      ),

                      Positioned.fill(
                        right: 30,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            const tickCount = 5;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(tickCount, (i) {
                                return Row(
                                  children: [
                                    const Spacer(),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Colors.white24,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 2,
                                      width: 24,
                                      color: Colors.white24,
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                        ),
                      ),

                      Positioned(
                        bottom: -3,
                        child: Text(
                          '0 ml',
                          style: GoogleFonts.rubik(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),

        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: CustomColors.darkGreen,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: Text('500 ml added to water log', style: GoogleFonts.rubik(color: Colors.white70)),
        )
      ]),
    );
  }
}