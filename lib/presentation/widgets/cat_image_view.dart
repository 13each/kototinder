import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CatImageView extends StatefulWidget {
  const CatImageView({super.key, required this.url, this.fallbackAsset});

  final String url;
  final String? fallbackAsset;

  @override
  State<CatImageView> createState() => _CatImageViewState();
}

class _CatImageViewState extends State<CatImageView> {
  static const _defaultFallbackAsset = 'assets/images/cat1.jpg';
  static const _cdnPrimary = 'cdn2.thecatapi.com';
  static const _cdnSecondary = 'cdn.thecatapi.com';

  late String _currentUrl;
  var _hostRetryUsed = false;
  var _useFallback = false;

  @override
  void initState() {
    super.initState();
    _currentUrl = _normalize(widget.url);
    _useFallback = _currentUrl.isEmpty;
  }

  @override
  void didUpdateWidget(covariant CatImageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _currentUrl = _normalize(widget.url);
      _hostRetryUsed = false;
      _useFallback = _currentUrl.isEmpty;
    }
  }

  String _normalize(String value) {
    if (value.startsWith('http://')) {
      return value.replaceFirst('http://', 'https://');
    }
    return value;
  }

  void _onNetworkError() {
    final uri = Uri.tryParse(_currentUrl);
    final canSwitchHost =
        uri != null &&
        !_hostRetryUsed &&
        (uri.host == _cdnPrimary || uri.host == _cdnSecondary);

    if (canSwitchHost) {
      final nextHost = uri.host == _cdnPrimary ? _cdnSecondary : _cdnPrimary;
      _hostRetryUsed = true;
      setState(() {
        _currentUrl = uri.replace(host: nextHost, scheme: 'https').toString();
      });
      return;
    }

    setState(() {
      _useFallback = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAssetUrl = widget.url.startsWith('assets/');
    if (isAssetUrl || _useFallback) {
      final assetPath = isAssetUrl
          ? widget.url
          : (widget.fallbackAsset ?? _defaultFallbackAsset);
      return ColoredBox(
        color: const Color(0xFFF2E8DC),
        child: Image.asset(assetPath, fit: BoxFit.cover),
      );
    }

    return Image.network(
      _currentUrl,
      fit: BoxFit.cover,
      headers: const <String, String>{},
      webHtmlElementStrategy: kIsWeb
          ? WebHtmlElementStrategy.prefer
          : WebHtmlElementStrategy.never,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return const ColoredBox(
          color: Color(0xFFF8EAD7),
          child: Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _onNetworkError();
          }
        });
        return const ColoredBox(
          color: Color(0xFFFFEFEF),
          child: Center(child: Icon(Icons.broken_image_outlined, size: 42)),
        );
      },
    );
  }
}
