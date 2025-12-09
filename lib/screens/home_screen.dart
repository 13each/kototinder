import '../api/api_service.dart';
import '../models/cat_image.dart';
import 'package:flutter/material.dart';
import 'breed_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  CatImage? currentCat;
  int likes = 0;
  bool isLoading = true;
  double posX = 0;
  double angle = 0;
  final double maxAngle = 0.25;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadCat();
  }

  Future<void> loadCat() async {
    setState(() => isLoading = true);
    try {
      final cat = await ApiService.getRandomCat();
      setState(() {
        currentCat = cat;
        posX = 0;
        angle = 0;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Ошибка загрузки кота: $e');
      setState(() => isLoading = false);
    }
  }

  void triggerLike() {
    setState(() {
      posX = 500;
      angle = maxAngle;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => likes++);
      loadCat();
    });
  }

  void triggerDislike() {
    setState(() {
      posX = -500;
      angle = -maxAngle;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      loadCat();
    });
  }

  void resetPosition() {
    setState(() {
      posX = 0;
      angle = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading || currentCat == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final cat = currentCat!;

    final opacity = (posX.abs() / 150).clamp(0.0, 1.0);

    final borderColor = posX > 0
        ? Colors.green.withValues(alpha: opacity)
        : posX < 0
        ? Colors.red.withValues(alpha: opacity)
        : Colors.transparent;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Лайки: $likes', style: const TextStyle(fontSize: 20)),

        const SizedBox(height: 20),

        Center(
          child: GestureDetector(
            onTap: () {
              if (cat.breed != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BreedDetailScreen(breed: cat.breed!),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('У этого котика нет породы')),
                );
              }
            },
            onPanUpdate: (details) {
              setState(() {
                posX += details.delta.dx;
                angle = (posX / 300).clamp(-maxAngle, maxAngle);
              });
            },
            onPanEnd: (details) {
              if (posX > 120) {
                triggerLike();
              } else if (posX < -120) {
                triggerDislike();
              } else {
                resetPosition();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: MediaQuery.of(context).size.width * 0.85,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 6, color: borderColor),
              ),
              transform: Matrix4.translationValues(posX, 0, 0)..rotateZ(angle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: cat.url.startsWith('assets/')
                    ? Image.asset(cat.url, fit: BoxFit.cover)
                    : Image.network(
                        cat.url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text('Ошибка загрузки изображения'),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          cat.breed?.name ?? 'Без породы',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
