import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'content.dart';
import 'theme.dart';
import 'widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadThemeMode();
  // Flutter web draws on a canvas; build the semantics tree up front so
  // screen readers see the page without a hidden "Enable accessibility" click.
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  VisibilityDetectorController.instance.updateInterval =
      const Duration(milliseconds: 80);
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: '$fullName – Fullstack Java Developer',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: mode,
        home: const PortfolioPage(),
      ),
    );
  }
}

enum NavSection { about, skills, experience, education, projects, contact }

extension on NavSection {
  String get label => switch (this) {
        NavSection.about => 'About',
        NavSection.skills => 'Skills',
        NavSection.experience => 'Experience',
        NavSection.education => 'Education',
        NavSection.projects => 'Projects',
        NavSection.contact => 'Contact',
      };

  IconData get icon => switch (this) {
        NavSection.about => Icons.person_outline,
        NavSection.skills => Icons.auto_awesome_outlined,
        NavSection.experience => Icons.work_outline,
        NavSection.education => Icons.school_outlined,
        NavSection.projects => Icons.apps,
        NavSection.contact => Icons.mail_outline,
      };
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scroll = ScrollController();
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  final Map<NavSection, GlobalKey> _keys = {
    for (final s in NavSection.values) s: GlobalKey(),
  };
  bool _showToTop = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final show = _scroll.offset > 400;
      if (show != _showToTop) setState(() => _showToTop = show);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      _intro.value = 1;
    } else if (!_intro.isAnimating && _intro.value == 0) {
      _intro.forward();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _intro.dispose();
    super.dispose();
  }

  Duration get _scrollDuration => reduceMotion(context)
      ? Duration.zero
      : const Duration(milliseconds: 700);

  void _goTo(NavSection section) {
    final ctx = _keys[section]!.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: _scrollDuration,
      curve: Curves.easeOutCubic,
    );
  }

  void _toTop() => _scroll.animateTo(
        0,
        duration: _scrollDuration == Duration.zero
            ? const Duration(milliseconds: 1)
            : _scrollDuration,
        curve: Curves.easeOutCubic,
      );

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      backgroundColor: p.background,
      body: Column(
        children: [
          _Header(onNavigate: _goTo),
          Expanded(
            child: SelectionArea(
              child: SingleChildScrollView(
                controller: _scroll,
                child: Column(
                  children: [
                    _Hero(
                      intro: _intro,
                      onContact: () => _goTo(NavSection.contact),
                    ),
                    KeyedSubtree(
                        key: _keys[NavSection.about],
                        child: const _AboutSection()),
                    KeyedSubtree(
                        key: _keys[NavSection.skills],
                        child: const _SkillsSection()),
                    KeyedSubtree(
                        key: _keys[NavSection.experience],
                        child: const _ExperienceSection()),
                    KeyedSubtree(
                        key: _keys[NavSection.education],
                        child: const _EducationSection()),
                    KeyedSubtree(
                        key: _keys[NavSection.projects],
                        child: const _ProjectsSection()),
                    KeyedSubtree(
                        key: _keys[NavSection.contact],
                        child: const _ContactSection()),
                    _Footer(onNavigate: _goTo),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: _showToTop ? 1 : 0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: FloatingActionButton(
          onPressed: _showToTop ? _toTop : null,
          tooltip: 'Back to top',
          backgroundColor: p.primary,
          foregroundColor: p.background,
          child: const Icon(Icons.keyboard_arrow_up, size: 30),
        ),
      ),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.onNavigate});
  final ValueChanged<NavSection> onNavigate;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = isMobileWidth(context);
    return Material(
      color: p.background,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: p.border)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: mobile ? 12 : 48,
          vertical: mobile ? 6 : 12,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: mobile ? 8 : 0),
                  child: Text(
                    fullName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: p.primary,
                    ),
                  ),
                ),
                const Spacer(),
                const _ThemeToggle(),
                SizedBox(width: mobile ? 0 : 8),
                if (!mobile) ...[
                  for (final s in NavSection.values
                      .where((s) => s != NavSection.contact))
                    TextButton(
                      onPressed: () => onNavigate(s),
                      style: TextButton.styleFrom(
                        foregroundColor: p.body,
                        minimumSize: const Size(48, 44),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      child: Text(s.label, style: const TextStyle(fontSize: 14)),
                    ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () => onNavigate(NavSection.contact),
                    style: FilledButton.styleFrom(
                      backgroundColor: p.primary,
                      foregroundColor: p.background,
                      minimumSize: const Size(48, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                    ),
                    child: const Text('Contact'),
                  ),
                ] else
                  IconButton(
                    tooltip: 'Open menu',
                    icon: Icon(Icons.menu, color: p.ink),
                    iconSize: 28,
                    onPressed: () => _showMenu(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    final p = context.palette;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: p.surface,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in NavSection.values)
              ListTile(
                minTileHeight: 52,
                leading: Icon(s.icon, color: p.primary),
                title: Text(
                  s.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: p.ink,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheet);
                  Future.delayed(
                    const Duration(milliseconds: 250),
                    () => onNavigate(s),
                  );
                },
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final label = isDark ? 'Switch to light mode' : 'Switch to dark mode';
    return Semantics(
      toggled: isDark,
      label: 'Dark mode',
      child: IconButton(
        tooltip: label,
        onPressed: () => toggleThemeMode(context),
        iconSize: 24,
        style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
        icon: AnimatedSwitcher(
          duration: reduceMotion(context)
              ? Duration.zero
              : const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => RotationTransition(
            turns: Tween(begin: 0.75, end: 1.0).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            key: ValueKey(isDark),
            color: p.ink,
          ),
        ),
      ),
    );
  }
}

// ─── Hero ──────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({required this.intro, required this.onContact});
  final AnimationController intro;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = isMobileWidth(context);
    final photo = CurvedAnimation(
      parent: intro,
      curve: const Interval(0, 0.7, curve: Curves.easeOutExpo),
    );
    final text = CurvedAnimation(
      parent: intro,
      curve: const Interval(0.15, 1, curve: Curves.easeOutExpo),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: p.heroGradient),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: mobile ? 64 : 104,
      ),
      child: Column(
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.85, end: 1.0).animate(photo),
            child: FadeTransition(
              opacity: photo,
              child: Container(
                width: mobile ? 120 : 144,
                height: mobile ? 120 : 144,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: p.onHero,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/khadim.jpg',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.55),
                    semanticLabel: 'Portrait of $fullName',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          FadeTransition(
            opacity: text,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.15), end: Offset.zero)
                  .animate(text),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        fullName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: mobile ? 42 : 60,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.2,
                          height: 1.05,
                          color: p.onHero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      headline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: mobile ? 16 : 19,
                        height: 1.5,
                        color: p.onHeroMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SocialRow(color: p.onHero, background: const Color(0x26FFFFFF)),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: onContact,
                      style: FilledButton.styleFrom(
                        backgroundColor: p.onHero,
                        foregroundColor: Palette.light.primaryInk,
                        minimumSize: const Size(48, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text("Let's talk together"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({required this.color, required this.background});
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    Widget button(IconData icon, String tooltip, String url) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: IconButton(
            tooltip: tooltip,
            onPressed: () => openLink(url),
            icon: Icon(icon, color: color),
            style: IconButton.styleFrom(
              backgroundColor: background,
              minimumSize: const Size(48, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        button(Icons.code, 'GitHub', githubUrl),
        button(Icons.mail_outline, 'Email $email', 'mailto:$email'),
        button(Icons.phone_outlined, 'Call $phoneDisplay', phoneUri),
      ],
    );
  }
}

// ─── About ─────────────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = isMobileWidth(context);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'About me',
            style: TextStyle(
              fontSize: mobile ? 30 : 38,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: p.ink,
            ),
          ),
        ),
        const SizedBox(height: 20),
        for (final para in aboutParagraphs) ...[
          Text(
            para,
            style: TextStyle(fontSize: 17, height: 1.7, color: p.body),
          ),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 8),
        _Fact(value: '$yearsOfExperience+', label: 'years of experience'),
      ],
    );

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Image.asset(
          'assets/images/kh-bio.jpeg',
          fit: BoxFit.cover,
          semanticLabel: '$fullName working at his desk',
        ),
      ),
    );

    return Container(
      color: p.background,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 48,
        vertical: mobile ? 56 : 96,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: Reveal(
            child: mobile
                ? Column(children: [text, const SizedBox(height: 32), image])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: text),
                      const SizedBox(width: 64),
                      Expanded(flex: 5, child: image),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: p.primary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 15, color: p.muted)),
      ],
    );
  }
}

// ─── Skills ────────────────────────────────────────────────────────────────

class _SkillsSection extends StatelessWidget {
  const _SkillsSection();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 768 ? 1 : 2;
    return Section(
      alt: true,
      title: 'Skills',
      subtitle: 'Technologies and tools I work with',
      child: EqualHeightGrid(
        columns: columns,
        children: [
          for (final (i, g) in skillGroups.indexed)
            Reveal(
              delay: Duration(milliseconds: (i % columns) * 80),
              child: Panel(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: p.primaryTint,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ExcludeSemantics(
                            child: Icon(g.icon, color: p.primaryInk),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            g.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: p.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final s in g.skills) TagChip(s, size: 13),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Experience ────────────────────────────────────────────────────────────

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection();

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Professional experience',
      subtitle: 'My professional journey',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: Column(
          children: [
            for (final (i, e) in experiences.indexed) ...[
              if (i > 0) const SizedBox(height: 24),
              Reveal(child: _ExperienceCard(e)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard(this.e);
  final Experience e;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = isMobileWidth(context);
    return Panel(
      padding: EdgeInsets.all(mobile ? 20 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            e.period,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: p.primary,
            ),
          ),
          const SizedBox(height: 8),
          Semantics(
            header: true,
            child: Text(
              e.role,
              style: TextStyle(
                fontSize: mobile ? 20 : 22,
                fontWeight: FontWeight.w700,
                height: 1.25,
                color: p.ink,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            e.company,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: p.muted,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.summary,
                  style: TextStyle(fontSize: 15, height: 1.65, color: p.body),
                ),
                if (e.bullets.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  BulletList(e.bullets),
                ],
              ],
            ),
          ),
          if (e.highlights.isNotEmpty) ...[
            const SizedBox(height: 12),
            _Highlights(e.highlights),
          ],
          const SizedBox(height: 18),
          TagWrap(e.tags),
        ],
      ),
    );
  }
}

class _Highlights extends StatelessWidget {
  const _Highlights(this.items);
  final List<Highlight> items;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Material(
        color: p.backgroundAlt,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: p.primary,
          collapsedIconColor: p.primary,
          title: Text(
            'Key projects (${items.length})',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: p.primaryInk,
            ),
          ),
          children: [
            for (final (i, h) in items.indexed) ...[
              if (i > 0) Divider(color: p.border, height: 32),
              _HighlightBody(h),
            ],
          ],
        ),
      ),
    );
  }
}

class _HighlightBody extends StatelessWidget {
  const _HighlightBody(this.h);
  final Highlight h;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    TextStyle label() => TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: p.ink,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          h.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.35,
            color: p.ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(h.period, style: TextStyle(fontSize: 13, color: p.muted)),
        const SizedBox(height: 10),
        Text(h.context,
            style: TextStyle(fontSize: 14.5, height: 1.65, color: p.body)),
        const SizedBox(height: 14),
        Text('Role', style: label()),
        const SizedBox(height: 8),
        BulletList(h.responsibilities, fontSize: 14.5),
        const SizedBox(height: 6),
        Text('Results', style: label()),
        const SizedBox(height: 8),
        BulletList(h.results, fontSize: 14.5),
        const SizedBox(height: 6),
        Text('Stack', style: label()),
        const SizedBox(height: 6),
        Text(h.stack,
            style: TextStyle(fontSize: 14, height: 1.6, color: p.muted)),
      ],
    );
  }
}

// ─── Education ─────────────────────────────────────────────────────────────

class _EducationSection extends StatelessWidget {
  const _EducationSection();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = isMobileWidth(context);
    return Section(
      alt: true,
      title: 'Education',
      subtitle: 'My academic background',
      child: EqualHeightGrid(
        columns: mobile ? 1 : 2,
        children: [
          for (final ed in education)
            Reveal(
              child: Panel(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExcludeSemantics(
                      child: Icon(ed.icon, size: 36, color: p.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      ed.degree,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: p.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ed.school,
                      style: TextStyle(fontSize: 15, color: p.primaryInk),
                    ),
                    const SizedBox(height: 4),
                    Text(ed.period,
                        style: TextStyle(fontSize: 14, color: p.muted)),
                    const SizedBox(height: 14),
                    Text(
                      ed.text,
                      style:
                          TextStyle(fontSize: 15, height: 1.6, color: p.body),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Projects ──────────────────────────────────────────────────────────────

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 768 ? 1 : (width < 1100 ? 2 : 3);
    return Section(
      title: 'Projects',
      subtitle: 'Systems I designed and built',
      child: EqualHeightGrid(
        columns: columns,
        children: [
          for (final (i, pr) in projects.indexed)
            Reveal(
              delay: Duration(milliseconds: (i % columns) * 80),
              child: _ProjectCard(pr),
            ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard(this.project);
  final Project project;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 96,
            width: double.infinity,
            decoration: BoxDecoration(gradient: p.heroGradient),
            child: ExcludeSemantics(
              child: Icon(project.icon, size: 44, color: p.onHero),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    project.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: p.ink,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project.context,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: p.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  project.description,
                  style: TextStyle(fontSize: 14.5, height: 1.6, color: p.body),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 22),
            child: TagWrap(project.tags),
          ),
        ],
      ),
    );
  }
}

// ─── Contact ───────────────────────────────────────────────────────────────

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = isMobileWidth(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: p.heroGradient),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: mobile ? 64 : 96,
      ),
      child: Reveal(
        child: Column(
          children: [
            Semantics(
              header: true,
              child: Text(
                "Let's work together",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: mobile ? 32 : 42,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  color: p.onHero,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Have a backend, an API or a platform to build? Write to me.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, height: 1.5, color: p.onHeroMuted),
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: () => openLink('mailto:$email'),
                  icon: const Icon(Icons.mail_outline),
                  label: const Text(email),
                  style: FilledButton.styleFrom(
                    backgroundColor: p.onHero,
                    foregroundColor: Palette.light.primaryInk,
                    minimumSize: const Size(48, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => openLink(phoneUri),
                  icon: const Icon(Icons.phone_outlined),
                  label: const Text(phoneDisplay),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: p.onHero,
                    side: BorderSide(color: p.onHero),
                    minimumSize: const Size(48, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Footer ────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer({required this.onNavigate});
  final ValueChanged<NavSection> onNavigate;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mobile = isMobileWidth(context);

    Widget heading(String t) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            t,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: p.footerInk,
            ),
          ),
        );

    Widget link(String text, VoidCallback onTap) => TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: p.footerMuted,
            minimumSize: const Size(0, 44),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            tapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: Text(text, style: const TextStyle(fontSize: 14)),
        );

    final brand = Column(
      crossAxisAlignment:
          mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          fullName,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: p.footerBrand,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Let's create exceptional digital experiences together.",
          textAlign: mobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(fontSize: 14, height: 1.5, color: p.footerMuted),
        ),
        const SizedBox(height: 16),
        _SocialRow(color: p.footerInk, background: const Color(0x1AFFFFFF)),
      ],
    );

    final nav = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading('Navigation'),
        for (final s in NavSection.values
            .where((s) => s != NavSection.contact))
          link(s.label, () => onNavigate(s)),
      ],
    );

    final contact = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading('Contact'),
        link(email, () => openLink('mailto:$email')),
        link(phoneDisplay, () => openLink(phoneUri)),
        link('GitHub', () => openLink(githubUrl)),
      ],
    );

    return Container(
      width: double.infinity,
      color: p.footer,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 48,
        vertical: 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: Column(
            children: [
              if (mobile)
                Column(children: [
                  brand,
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: nav),
                      Expanded(child: contact),
                    ],
                  ),
                ])
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: brand),
                    const SizedBox(width: 48),
                    Expanded(child: nav),
                    Expanded(child: contact),
                  ],
                ),
              const SizedBox(height: 32),
              Divider(color: p.footerMuted.withValues(alpha: 0.25)),
              const SizedBox(height: 20),
              Text(
                '© ${DateTime.now().year} $fullName. All rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: p.footerMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
