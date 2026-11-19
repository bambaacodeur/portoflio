import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'theme.dart';

const double kMaxContentWidth = 1200;

bool isMobileWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width < 768;

bool reduceMotion(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

/// Renders [builder]'s control as a real link: on the web it is an `<a>`,
/// so it can be middle-clicked, copied, and is announced as a link.
/// Web pages open in a new tab; mailto/tel stay in place.
class ExternalLink extends StatelessWidget {
  const ExternalLink({super.key, required this.url, required this.builder});

  final String url;
  final Widget Function(BuildContext context, VoidCallback? open) builder;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(url),
      target: url.startsWith('http') ? LinkTarget.blank : LinkTarget.self,
      builder: (context, follow) => builder(context, follow),
    );
  }
}

/// Fades and lifts its child the first time it scrolls into view.
/// Starts partially visible so content never hides behind the animation,
/// and renders instantly when the user asks for reduced motion.
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  static int _ids = 0;
  final Key _key = ValueKey('reveal-${_ids++}');
  bool _shown = false;

  void _onVisibility(VisibilityInfo info) {
    if (_shown || info.visibleFraction < 0.08) return;
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return widget.child;
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: _onVisibility,
      child: AnimatedOpacity(
        opacity: _shown ? 1 : 0.25,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutExpo,
        child: AnimatedSlide(
          offset: _shown ? Offset.zero : const Offset(0, 0.04),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutExpo,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Full-width band with centred, width-capped content and a section title.
class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.alt = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool alt;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = isMobileWidth(context);
    return Container(
      width: double.infinity,
      color: alt ? p.backgroundAlt : p.background,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 48,
        vertical: mobile ? 56 : 96,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: Column(
            children: [
              Semantics(
                header: true,
                headingLevel: 2,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: mobile ? 30 : 38,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    height: 1.15,
                    color: p.ink,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: p.muted),
              ),
              SizedBox(height: mobile ? 32 : 48),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  const TagChip(this.label, {super.key, this.size = 12});
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: p.primaryTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w500,
          color: p.primaryInk,
        ),
      ),
    );
  }
}

class TagWrap extends StatelessWidget {
  const TagWrap(this.tags, {super.key});
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final t in tags) TagChip(t)],
    );
  }
}

class BulletList extends StatelessWidget {
  const BulletList(this.items, {super.key, this.fontSize = 15});
  final List<String> items;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: fontSize * 0.62, right: 12),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: p.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: fontSize,
                      height: 1.6,
                      color: p.body,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Grid whose rows grow to fit their tallest card, so nothing is clipped
/// when copy is long or the user enlarges text.
class EqualHeightGrid extends StatelessWidget {
  const EqualHeightGrid({
    super.key,
    required this.columns,
    required this.children,
    this.gap = 24,
  });

  final int columns;
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final cells = <Widget>[];
      for (var c = 0; c < columns; c++) {
        if (c > 0) cells.add(SizedBox(width: gap));
        final idx = i + c;
        cells.add(Expanded(
          child: idx < children.length ? children[idx] : const SizedBox(),
        ));
      }
      if (rows.isNotEmpty) rows.add(SizedBox(height: gap));
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: cells,
        ),
      ));
    }
    return Column(children: rows);
  }
}

/// Rounded surface with a soft, offset shadow.
class Panel extends StatelessWidget {
  const Panel({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: padding,
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
        boxShadow: [
          BoxShadow(
            color: p.shadow,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
