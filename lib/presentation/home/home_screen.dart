import 'package:flutter/material.dart';

import '../widgets/cat_image_view.dart';
import 'cat_detail_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.onSignOut,
  });

  final HomeController controller;
  final Future<void> Function() onSignOut;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  double _posX = 0;
  double _angle = 0;
  final double _maxAngle = 0.25;
  String? _lastDialogError;
  var _isSigningOut = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.controller.currentCat == null) {
      widget.controller.loadCat();
    }
  }

  Future<void> _showErrorDialog(String message) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Loading error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmAndSignOut() async {
    if (_isSigningOut) {
      return;
    }

    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Do you want to sign out of your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sign out'),
            ),
          ],
        );
      },
    );

    if (shouldSignOut != true || !mounted) {
      return;
    }

    setState(() => _isSigningOut = true);
    await widget.onSignOut();
    if (!mounted) {
      return;
    }
    setState(() => _isSigningOut = false);
  }

  Future<void> _triggerLike() async {
    setState(() {
      _posX = 500;
      _angle = _maxAngle;
    });
    await Future<void>.delayed(const Duration(milliseconds: 220));
    await widget.controller.like();
    _resetPosition();
  }

  Future<void> _triggerDislike() async {
    setState(() {
      _posX = -500;
      _angle = -_maxAngle;
    });
    await Future<void>.delayed(const Duration(milliseconds: 220));
    await widget.controller.dislike();
    _resetPosition();
  }

  void _resetPosition() {
    setState(() {
      _posX = 0;
      _angle = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final cat = widget.controller.currentCat;
        final error = widget.controller.errorMessage;

        if (error != null && error != _lastDialogError) {
          _lastDialogError = error;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showErrorDialog(error);
            }
          });
        }

        if (widget.controller.isLoading && cat == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cat == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.signal_wifi_connected_no_internet_4,
                    size: 46,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    error ?? 'Could not load cat right now.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: widget.controller.loadCat,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }

        final opacity = (_posX.abs() / 150).clamp(0.0, 1.0);
        final borderColor = _posX > 0
            ? Colors.green.withValues(alpha: opacity)
            : _posX < 0
            ? Colors.red.withValues(alpha: opacity)
            : Colors.transparent;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Kototinder',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  _CounterBadge(likes: widget.controller.likes),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Sign out',
                    onPressed: _isSigningOut ? null : _confirmAndSignOut,
                    icon: _isSigningOut
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.logout_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CatDetailScreen(cat: cat),
                        ),
                      );
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        _posX += details.delta.dx;
                        _angle = (_posX / 300).clamp(-_maxAngle, _maxAngle);
                      });
                    },
                    onPanEnd: (_) {
                      if (_posX > 120) {
                        _triggerLike();
                        return;
                      }
                      if (_posX < -120) {
                        _triggerDislike();
                        return;
                      }
                      _resetPosition();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      width: MediaQuery.of(context).size.width * 0.88,
                      constraints: const BoxConstraints(maxHeight: 460),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(width: 6, color: borderColor),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3A8A5A44),
                            blurRadius: 28,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      transform: Matrix4.translationValues(_posX, 0, 0)
                        ..rotateZ(_angle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CatImageView(url: cat.url),
                            Positioned(
                              left: 14,
                              right: 14,
                              bottom: 14,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0xD91A2530),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    10,
                                    12,
                                    10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cat.breed?.name ?? 'Unknown breed',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        cat.breed?.origin ??
                                            'Tap to open breed details',
                                        style: const TextStyle(
                                          color: Color(0xFFE2EAEE),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ActionButton(
                    onPressed: _triggerDislike,
                    icon: Icons.close_rounded,
                    background: const Color(0xFFDF4B4B),
                  ),
                  const SizedBox(width: 28),
                  _ActionButton(
                    onPressed: _triggerLike,
                    icon: Icons.favorite_rounded,
                    background: const Color(0xFF0E9F77),
                  ),
                ],
              ),
              if (widget.controller.isLoading) ...[
                const SizedBox(height: 14),
                const LinearProgressIndicator(minHeight: 3),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _CounterBadge extends StatelessWidget {
  const _CounterBadge({required this.likes});

  final int likes;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1D2938),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_rounded,
              color: Color(0xFFFF7D6E),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '$likes',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.background,
  });

  final Future<void> Function() onPressed;
  final IconData icon;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: background.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: background,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(18),
        ),
        onPressed: () {
          onPressed();
        },
        child: Icon(icon, size: 34),
      ),
    );
  }
}
