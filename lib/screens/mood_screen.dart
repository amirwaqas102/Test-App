import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/asset_images.dart';
import '../utils/custom_colors.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({Key? key}) : super(key: key);

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen>
    with SingleTickerProviderStateMixin {
  double angle = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Color> moodColors = [
    CustomColors.circleGreen,
    CustomColors.circlePurple,
    CustomColors.circlePink,
    CustomColors.circleOrange,
  ];

  final List<String> moodLabels = ["Calm", "Content", "Peaceful", "Happy"];
  final List<String> moodImages = [
    AssetImages.calm,
    AssetImages.content,
    AssetImages.peaceful,
    AssetImages.happy,
  ];

  int get currentMoodIndex {
    double segment = 2 * math.pi / 4;
    return ((angle + segment / 2) ~/ segment) % 4;
  }

  String get moodLabel => moodLabels[currentMoodIndex];
  String get moodImage => moodImages[currentMoodIndex];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateAngle(Offset localPosition, RenderBox box) {
    final Offset center = box.size.center(Offset.zero);
    final Offset vector = localPosition - center;
    double newAngle = math.atan2(vector.dy, vector.dx);
    if (newAngle < 0) newAngle += 2 * math.pi;
    setState(() => angle = newAngle);
  }

  void _snapToNearestMood() {
    final double segment = 2 * math.pi / 4;
    final double targetAngle = (currentMoodIndex * segment);
    _animation = Tween<double>(begin: angle, end: targetAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() => setState(() => angle = _animation.value));

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    const double outerRadius = 100;
    const double knobRadius = 20;

    return Scaffold(
      backgroundColor: CustomColors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mood",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Start your day",
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "How are you feeling at the moment?",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            Center(
              child: GestureDetector(
                onPanUpdate: (details) {
                  RenderBox box = context.findRenderObject() as RenderBox;
                  Offset localPosition =
                  box.globalToLocal(details.globalPosition);
                  _updateAngle(localPosition, box);
                },
                onPanEnd: (_) => _snapToNearestMood(),
                child: CustomPaint(
                  painter: MoodRingPainter(moodColors),
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: const BoxDecoration(
                            color: CustomColors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              moodImage,
                              height: 80,
                              width: 80,
                            ),
                          ),
                        ),

                        // White draggable knob
                        Transform.translate(
                          offset: Offset(
                            (outerRadius - knobRadius / 8) * math.cos(angle),
                            (outerRadius - knobRadius / 8) * math.sin(angle),
                          ),
                          child: Container(
                            width: knobRadius * 2.5,
                            height: knobRadius * 2.5,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 6,
                                  offset: Offset(2, 2),
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

            const SizedBox(height: 30),

            Center(
              child: Text(
                moodLabel,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: CustomColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodRingPainter extends CustomPainter {
  final List<Color> colors;
  MoodRingPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final gradient = SweepGradient(
      colors: colors + [colors.first],
      startAngle: 0.0,
      endAngle: 2 * math.pi,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: 100),
      0,
      2 * math.pi,
      false,
      paint,
    );

    final dividerPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    for (int i = 0; i < 10; i++) {
      final double dividerAngle = (2 * math.pi / 10) * i;
      final start = Offset(
        size.width / 2 + 85 * math.cos(dividerAngle),
        size.height / 2 + 85 * math.sin(dividerAngle),
      );
      final end = Offset(
        size.width / 2 + 115 * math.cos(dividerAngle),
        size.height / 2 + 115 * math.sin(dividerAngle),
      );
      canvas.drawLine(start, end, dividerPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
