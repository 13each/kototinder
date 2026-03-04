import 'dart:math' as math;

import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _steps = const [
    _OnboardingStep(
      title: 'Swipe and rate cats',
      description:
          'Swipe left or right, or tap like/dislike buttons to move to the next cat.',
      icon: Icons.swipe_rounded,
    ),
    _OnboardingStep(
      title: 'Open breed details',
      description:
          'Tap the cat photo to see a detailed screen with the same image and breed information.',
      icon: Icons.info_outline_rounded,
    ),
    _OnboardingStep(
      title: 'Browse all breeds',
      description:
          'Switch tabs to open the breeds list and explore detailed characteristics for each breed.',
      icon: Icons.list_alt_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _nextOrFinish() async {
    if (_currentPage == _steps.length - 1) {
      widget.onFinished();
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Welcome', style: textTheme.headlineMedium),
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onFinished,
                    child: const Text('Skip'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, _) {
                    final page = _pageController.hasClients
                        ? (_pageController.page ?? _currentPage.toDouble())
                        : _currentPage.toDouble();
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFFE8673C,
                            ).withValues(alpha: 0.17),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(math.sin(page * math.pi) * 42, 0),
                          child: Transform.rotate(
                            angle: math.sin(page * math.pi) * 0.3,
                            child: const Icon(
                              Icons.pets_rounded,
                              size: 98,
                              color: Color(0xFF1D2938),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _steps.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final step = _steps[index];
                    return _OnboardingCard(step: step);
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(
                  _steps.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.only(right: 8),
                    width: _currentPage == index ? 30 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFFE8673C)
                          : const Color(0xFFD6C8B9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextOrFinish,
                  child: Text(
                    _currentPage == _steps.length - 1 ? 'Get started' : 'Next',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({required this.step});

  final _OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(step.icon, size: 40, color: const Color(0xFFE8673C)),
            const SizedBox(height: 20),
            Text(
              step.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              step.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
