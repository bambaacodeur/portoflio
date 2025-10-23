import 'package:flutter/material.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khadim SECK - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _headerAnimController;
  late AnimationController _fadeAnimController;
  bool _showScrollToTop = false;

  // Keys pour les sections
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _fadeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 300 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
    } else if (_scrollController.offset < 300 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero).dy;
      final offset =
          _scrollController.offset + position - 80; // 80px pour le header

      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerAnimController.dispose();
    _fadeAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeader(context),
                _buildHeroSection(context),
                Container(key: _aboutKey, child: _buildAboutSection(context)),
                Container(key: _skillsKey, child: _buildSkillsSection(context)),
                Container(
                    key: _experienceKey,
                    child: _buildExperienceSection(context)),
                Container(
                    key: _educationKey, child: _buildEducationSection(context)),
                Container(
                    key: _projectsKey, child: _buildProjectsSection(context)),
                _buildFooter(context),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: AnimatedOpacity(
              opacity: _showScrollToTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedScale(
                scale: _showScrollToTop ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: FloatingActionButton(
                  onPressed: _scrollToTop,
                  backgroundColor: const Color(0xFF6366F1),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return FadeTransition(
      opacity: _fadeAnimController,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 80,
          vertical: 20,
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bamba API',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6366F1),
              ),
            ),
            if (!isMobile)
              Row(
                children: [
                  _buildNavLink('Bio', _aboutKey),
                  _buildNavLink('Skills', _skillsKey),
                  _buildNavLink('Expérience', _experienceKey),
                  _buildNavLink('Formation', _educationKey),
                  _buildNavLink('Projects', _projectsKey),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Contact'),
                  ),
                ],
              ),
            if (isMobile)
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _showMobileMenu(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              _buildMobileMenuItem('Bio', Icons.person, _aboutKey),
              _buildMobileMenuItem('Compétences', Icons.stars, _skillsKey),
              _buildMobileMenuItem('Expérience', Icons.work, _experienceKey),
              _buildMobileMenuItem('Formation', Icons.school, _educationKey),
              _buildMobileMenuItem('Projets', Icons.apps, _projectsKey),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Contact',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileMenuItem(
      String text, IconData icon, GlobalKey sectionKey) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6366F1)),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollToSection(sectionKey);
        });
      },
    );
  }

  Widget _buildNavLink(String text, GlobalKey sectionKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: () => _scrollToSection(sectionKey),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _headerAnimController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: _headerAnimController,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 80,
            vertical: isMobile ? 60 : 100,
          ),
          child: Column(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/khadim.jpg'),
                          fit: BoxFit.fill, // zooms in and fills the circle
                          alignment: Alignment
                              .center, // adjust to focus on top/center/bottom
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Khadim SECK',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Software Engineer |Java Developer fullstack | AI scientis senior ( GEEK )',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.work_outline),
                  _buildSocialIcon(Icons.code),
                  _buildSocialIcon(Icons.share),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Let's talk together!"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 80,
            vertical: isMobile ? 40 : 80,
          ),
          child: isMobile
              ? Column(
                  children: [
                    _buildAboutText(),
                    const SizedBox(height: 40),
                    _buildAboutImage(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildAboutText()),
                    const SizedBox(width: 60),
                    Expanded(child: _buildAboutImage()),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildAboutText() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(-50 * (1 - value), 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Passionate about technology from a young age, I am a software engineering professional with over 4 years of experience in developing innovative web and mobile applications.',
                  style: TextStyle(fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 15),
                const Text(
                  'My mission is to transform complex ideas into elegant and high-performing digital solutions. I firmly believe that technology should serve humanity and enhance our daily lives',
                  style: TextStyle(fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    // _buildStatCard('50+', 'Projets réalisés'),
                    const SizedBox(width: 30),
                    _buildStatCard('5', 'Years of experience'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6366F1),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildAboutImage() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(50 * (1 - value), 0),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 40 : 80,
      ),
      color: Colors.grey[50],
      child: Column(
        children: [
          const Text(
            'My Skills',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Technologies and tools I master',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = isMobile ? 1 : 3;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.5,
                children: [
                  _buildSkillCard(
                    'Frontend',
                    Icons.web,
                    Colors.blue,
                    [
                      SkillItem('FLUTTER', 0.9),
                      SkillItem('ANGULAR', 0.85),
                      SkillItem('REACT JS', 0.88),
                    ],
                  ),
                  _buildSkillCard(
                    'Backend',
                    Icons.storage,
                    Colors.green,
                    [
                      SkillItem('JAVA', 0.98),
                      SkillItem('Python', 0.95),
                      SkillItem('Node JS', 0.80),
                    ],
                  ),
                  _buildSkillCard(
                    'Database & Cloud',
                    Icons.cloud,
                    Colors.purple,
                    [
                      SkillItem('MySQL', 0.90),
                      SkillItem('MongoDB', 0.88),
                      SkillItem('PostgreSQL', 0.85),
                      SkillItem('AWS', 0.82),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(
      String title, IconData icon, Color color, List<SkillItem> skills) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...skills.map((skill) => _buildSkillBar(skill, value)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillBar(SkillItem skill, double animValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(skill.name, style: const TextStyle(fontSize: 14)),
              Text('${(skill.level * 100).toInt()}%',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: skill.level * animValue,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 40 : 80,
      ),
      child: Column(
        children: [
          const Text(
            'Professional Experience',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'My Professional Journey',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 50),
          _buildExperienceCard(
            'August 2023 - August 2025',
            'Developer Backend JAVA',
            'SONATEL ORANGE',
            """ Development and enhancement of Java backend applications and microservices within an SOA architecture.
    Level 3 maintenance and technical support, incident resolution, and production debugging.
    Design and exposure of APIs for Orange B2C/B2B applications (Orange Money, Maxit, Orange & Moi, Kaabu, etc.), as well as for internal applications (HR SelfCare) and external partner systems.
    Collaboration with software architects to implement new interfaces.
    Writing unit, integration, and regression tests while applying best practices in API development.
    Experience with Agile/Scrum and SAFe methodologies, with strong involvement in continuous delivery.
    Expertise in distributed architectures: Kafka (streaming), Elastic & ELK (data historization, monitoring, and log analysis).
    Projects completed: \n
    
      Project: Docubase – Document Management and Indexing System

      Period: 2023
      Context / Business Objective:
      Docubase is a centralized information system designed to unify and consolidate the various document databases within the Orange ecosystem. Each information system previously managed its own repository; 
      the goal was to build a single, unified platform for document access and management (upload, download, search), improving data consistency and operational efficiency across internal services.
      
      Role / Responsibilities:
      
      Designed and developed RESTful APIs for document search, upload, and download operations.
      
      Implemented secure microservices architecture using Spring Boot and Spring Cloud.
      
      Integrated Keycloak for authentication and authorization management.
      
      Documented and tested APIs using Postman, and exposed them through Apigee.
      
      Participated in continuous integration and deployment (CI/CD) processes with Jenkins and OpenShift.
      
      Collaborated on issue tracking and sprint planning using Jira, and managed source code via Bitbucket.
      
      Technical Environment:
      JHipster · Spring Boot · Spring Cloud · Microservices · Java 11 · Keycloak · Apigee · Postman · Jenkins · OpenShift · Jira · Bitbucket · CI/CD
      
      Results / Impact:
      
      Successfully centralized document databases previously spread across multiple systems.
      
      
      Simplified integration with other systems through standardized and secure APIs.
      
      Improved document traceability and governance across departments.
      
      Methodology:
      Agile (Scrum) – two-week sprints, code reviews, continuous integration and delivery on OpenShift.
      
      
      💸 Project: Orange Money Package – Wallet Transfer and Billing System Redesign

          Period: 2024 – 2025
          Context / Business Objective:
          The Orange Money Package project aimed to modernize the Mobile Money ecosystem by redesigning the wallet transfer and billing systems to improve performance, scalability, and transactional security.
           A key component of the initiative was the introduction of transaction packages (“forfaits”), 
          allowing customers to benefit from fee-free transfers up to a defined threshold.
          For example, a customer purchasing a 75 XOF package could perform up to 10,000 XOF in transactions without any fees applied. 
          If the transaction amount exceeded this limit (e.g., 15,000 XOF), the first 10,000 XOF would remain fee-free, while the remaining 5,000 XOF would incur standard transaction fees.
          This mechanism aimed to enhance customer satisfaction and encourage higher usage of digital financial services.
          
          Role / Responsibilities:
          
          Designed and developed the microservice to handle P2P transfers, international remittances, transaction cancellations, and package-based fee management.
          
          Contributed to the complete redesign of the billing module, consolidating internal and external partner billing under a unified microservice.
          
          Implemented a secure and distributed microservices architecture using Spring Boot and Spring Cloud.
          
          Integrated Redis for caching and optimization of high-volume transactional data.
          
          Leveraged Elasticsearch for search, monitoring, and analytics of wallet transactions.
          
          Integrated Keycloak for authentication and authorization, and exposed APIs through Apigee.
          
          Created and maintained API documentation with Swagger, Redoc, and Postman.
          
          Followed Agile (Scrum) methodology using Jira for sprint tracking, Bitbucket for version control, and automated deployments via CI/CD pipelines.
          
          Technical Environment:
          Java 21 · Spring Boot · Spring Cloud · JHipster · Redis · Elasticsearch · Keycloak · Apigee · Swagger · Redoc · Maven · Jira · Bitbucket · Postman · CI/CD
          
          Results / Impact:
          
          Successfully implemented a dynamic package-based pricing model for Orange Money users.
          
          Centralized and standardized partner billing and transaction logic within a single microservice.
          
          Strengthened security and transactional integrity through fine-grained access control.
          
          Provided a scalable foundation for future Orange Money digital financial services.
          
          Methodology:
          Agile (Scrum) – biweekly sprints, code reviews, automated testing, and continuous delivery on Orange’s infrastructure
          
          
          
          🏦 Project: Orange Bank – Tik Tak (Mobile Credit Service)

          Period: 2024 – 2025
          Context / Business Objective:
          The Orange Bank – Tik Tak project aimed to develop an instant mobile credit solution for Orange Money customers who are eligible based on their financial scoring profile.
          The main objective was to enable users to apply for and receive mobile loans directly through their Orange Money wallet — quickly, securely, and seamlessly.
          
          The project focused on the design and exposure of RESTful APIs supporting the entire credit lifecycle, including:
          
          Loan request API (credit application submission)
          
          getAuthorization API to obtain partner bank authorization
          
          Customer consent API for loan approval confirmation
          
          Loan validation and disbursement API
          
          Role / Responsibilities:
          
          Designed and developed backend APIs covering the full credit request and validation workflow.
          
          Integrated authorization and customer consent flows within the Orange Money ecosystem.
          
          Collaborated with software architects and security teams to ensure compliance with banking and regulatory standards.
          
          Implemented unit, integration, and regression tests to ensure service reliability and resilience.
          
          Participated in CI/CD deployment and monitoring on OpenShift infrastructure.
          
          Technical Environment:
          Java 21 · Spring Boot · Spring Cloud · JHipster · Keycloak · Apigee · Redis · Elasticsearch · Maven · Postman · Jira · Bitbucket · CI/CD
          
          Results / Impact:
          
          Delivered a fully integrated instant mobile loan service within Orange Money.
          
          Reduced loan processing time from several hours to just a few seconds.
          
          Enhanced customer experience through a fully automated workflow (scoring, authorization, consent, validation).
          
          Contributed to financial inclusion by providing credit access to unbanked and underbanked users.
          
          Methodology:
          Agile (Scrum) – biweekly sprints, continuous integration, and close collaboration between developers, architects, and security experts.
        
   
    
    """,
            [
              'JAVA 11',
              'JAVA 21',
              'SpringBoot',
              'Spring CLOUD',
              'JHIPSTER',
              'REST API',
              'POSTMAN',
              'KAFKA',
              'ELASTICSEARCH',
              'REDIS',
              'OPENSHIFT',
              'APIGEE',
              'MAVEN',
            ],
            true,
          ),
          const SizedBox(height: 30),
          _buildExperienceCard(
            'August 2023 - August 2025',
            'Developer Fullstack',
            'COOPERATIVE SONATEL BAMBILOR',
            "Design and development of an integrated web platform enabling complete management of human resources, land, and plots, as well as tracking of contributions and automated plot distribution.",
            [
              'PHP',
              'Symfony 5',
              'PYTHON',
            ],
            false,
          ),
          const SizedBox(height: 30),
          _buildExperienceCard(
            'September 2022 - July 2023',
            'Developer Fullstack - Freelance',
            'OMVG',
            "Study and development of a geographic information system",
            [
              'PYTHON',
              'DJANGO',
              'REST API',
              'POSTGRESQL',
              'Leaflet',
              'QGIS',
            ],
            false,
          ),
          const SizedBox(height: 30),
          _buildExperienceCard(
            'September 2023 - August 2023',
            'Developer Fullstack',
            'SNSOFTWARE',
            "Study and development of  applications.",
            [
              'JAVA 11',
              'SpringBoot',
              'REST API',
              'FLUTTER',
              'ODOO15',
              'MAVEN',
            ],
            false,
          ),
          const SizedBox(height: 30),
          _buildExperienceCard(
            'November 2021 - June 2022',
            'Developer Fullstack',
            'SONATEL-ORANGE',
            "Study and development of a microservices architecture using JHIPSTER for the merger of the MYSMC and SELF-SERVICE applications.",
            [
              'JAVA 11',
              'JHIPSTER',
              'SpringBoot',
              'Spring CLOUD',
              'REST API',
              'OPENSHIFT',
              'APIGEE',
              'MAVEN',
            ],
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(String period, String title, String company,
      String description, List<String> tags, bool isFirst) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: isFirst ? 1000 : 1200),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      period,
                      style: const TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    company,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEducationSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 40 : 80,
      ),
      color: Colors.grey[50],
      child: Column(
        children: [
          const Text(
            'Formation',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Mon parcours académique',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile) {
                return Column(
                  children: [
                    _buildEducationCard(
                      Icons.school,
                      'Master’s Degree in Software Engineering',
                      'Higher Institute of Computer Science of Dakar (ISI)',
                      '2022 - 2024',
                      'Specialization in software architecture, advanced web development, and distributed systems.',
                    ),
                    const SizedBox(height: 20),
                    _buildEducationCard(
                      Icons.business,
                      'Licence Informatique',
                      'AMDI Institute',
                      '2019 - 2022',
                      'Comprehensive training in programming, algorithms, and information systems.',
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: _buildEducationCard(
                      Icons.school,
                      'Master’s Degree in Software Engineering',
                      'Higher Institute of Computer Science of Dakar (ISI)',
                      '2022 - 2024',
                      'Specialization in software architecture, advanced web development, and distributed systems.',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildEducationCard(
                      Icons.business,
                      'Licence Informatique',
                      'AMDI Institute',
                      '2019 - 2022',
                      'Comprehensive training in programming, algorithms, and information systems.',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(IconData icon, String degree, String school,
      String period, String description) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 40, color: const Color(0xFF6366F1)),
                  const SizedBox(height: 15),
                  Text(
                    degree,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    school,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    period,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectsSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 40 : 80,
      ),
      child: Column(
        children: [
          const Text(
            'Projects Completed',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Some of My Achievements',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = isMobile ? 1 : 3;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.85,
                children: [
                  _buildProjectCard(
                    'E-Commerce Platform',
                    'https://images.unsplash.com/photo-1557821552-17105176677c?w=400',
                    'Modern online sales platform with shopping cart management, secure payments, and a responsive interface',
                    ['React', 'Node.js', 'MongoDB'],
                    0,
                  ),
                  _buildProjectCard(
                    'Task Manager App',
                    'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400',
                    'Task management application with real-time notifications and team collaboration features.',
                    ['Vue.js', 'Firebase', 'Vuex'],
                    1,
                  ),
                  _buildProjectCard(
                    'Carpooling',
                    'https://images.unsplash.com/photo-1636935529049-2078e9ee3e6c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1335?w=400',
                    'Task management application with real-time notifications and team collaboration features.',
                    [
                      'Anglar',
                      'Springboot',
                      'Spring Securite',
                      'Spring cloud',
                      'MySql',
                      'leaflet'
                    ],
                    1,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String imageUrl, String description,
      List<String> tags, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000 + (index * 200)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tags
                              .map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6366F1)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF6366F1),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 15),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('View Project'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Column(
                  children: [
                    const Text(
                      "Let's Work Together",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Ready to bring your project to life? Contact me!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.email),
                          label: const Text('Me contacter'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF6366F1),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          label: const Text('Doawload CV'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 40,
      ),
      color: const Color(0xFF1F2937),
      child: Column(
        children: [
          if (!isMobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bamba API',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Let's create exceptional digital experiences together.",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 60),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Navigation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildFooterLink('Bio'),
                      _buildFooterLink('Compétences'),
                      _buildFooterLink('Expérience'),
                      _buildFooterLink('Projects'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'seckhadime2@gmail.com',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '+221 77 123 76 80',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          _buildFooterSocialIcon(Icons.work_outline),
                          _buildFooterSocialIcon(Icons.code),
                          _buildFooterSocialIcon(Icons.share),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (isMobile)
            Column(
              children: [
                const Text(
                  'Bamba API',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterSocialIcon(Icons.work_outline),
                    _buildFooterSocialIcon(Icons.code),
                    _buildFooterSocialIcon(Icons.share),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 30),
          Divider(color: Colors.grey[700]),
          const SizedBox(height: 20),
          Text(
            '© 2025 Khadim SECK. All rights reserved',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSocialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class SkillItem {
  final String name;
  final double level;

  SkillItem(this.name, this.level);
}
