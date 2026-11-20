import 'package:flutter/material.dart';

/// All portfolio content lives here, separate from layout.

const String fullName = 'Khadim SECK';
const String headline =
    'Software Engineer | Fullstack Java Developer | Senior AI Scientist (Geek)';
const String email = 'seckhadime2@gmail.com';
const String phoneDisplay = '+221 77 123 76 80';
const String phoneUri = 'tel:+221771237680';
const String githubUrl = 'https://github.com/bambaacodeur';

/// Career start: November 2021 (SONATEL ORANGE).
final DateTime careerStart = DateTime(2021, 11);

int get yearsOfExperience {
  final now = DateTime.now();
  var years = now.year - careerStart.year;
  if (now.month < careerStart.month) years--;
  return years;
}

const List<String> aboutParagraphs = [
  'Passionate about technology from a young age, I am a software engineer specialised in Java backends and fullstack web and mobile applications, from mobile money and banking to healthcare information systems.',
  'My mission is to transform complex ideas into elegant and high-performing digital solutions. I firmly believe that technology should serve humanity and enhance our daily lives.',
];

class SkillGroup {
  const SkillGroup(this.title, this.icon, this.skills);
  final String title;
  final IconData icon;
  final List<String> skills;
}

const List<SkillGroup> skillGroups = [
  SkillGroup('Languages & Frontend', Icons.web, [
    'Java',
    'Python',
    'Flutter',
    'Angular',
    'React JS',
    'Node JS',
  ]),
  SkillGroup('Backend & Architecture', Icons.hub, [
    'Spring Boot',
    'Spring Cloud',
    'JHipster',
    'Microservices',
    'REST APIs',
    'Kafka',
    'Keycloak',
    'Apigee',
  ]),
  SkillGroup('Data & Search', Icons.storage, [
    'PostgreSQL',
    'MySQL',
    'MongoDB',
    'Elasticsearch',
    'Redis',
    'MinIO',
  ]),
  SkillGroup('DevOps & Cloud', Icons.cloud, [
    'Docker',
    'OpenShift',
    'Jenkins',
    'Bitbucket Pipelines',
    'AWS',
    'Maven',
  ]),
];

class Highlight {
  const Highlight({
    required this.title,
    required this.period,
    required this.context,
    required this.responsibilities,
    required this.stack,
    required this.results,
  });
  final String title;
  final String period;
  final String context;
  final List<String> responsibilities;
  final String stack;
  final List<String> results;
}

class Experience {
  const Experience({
    required this.period,
    required this.role,
    required this.company,
    required this.summary,
    this.bullets = const [],
    this.highlights = const [],
    required this.tags,
  });
  final String period;
  final String role;
  final String company;
  final String summary;
  final List<String> bullets;
  final List<Highlight> highlights;
  final List<String> tags;
}

const List<Experience> experiences = [
  Experience(
    period: 'November 2025 – Present',
    role: 'Backend Java / Fullstack Developer',
    company: 'EYONE SANTÉ',
    summary:
        'Design and development of the SI Médical platform (hospital information system) and of health-data interoperability services, in a microservices architecture.',
    bullets: [
      'Spring Boot microservices for billing, settlement, patients, medical records, products / medical acts and fees.',
      'Mobile payments (Wave, Orange Money) and insurance / third-party payer flows (ICAMO, Eyassur, Passport).',
      'FHIR R4 interoperability API (YONEWI) integrated with OpenIMIS, with Elasticsearch indexing and Redis cache.',
      'Event-driven data migration platform (Télémigration) between SIMedical, Eyassur and Passport over Kafka.',
      'Contribution to EYONE Framework, shared Spring Boot starters (Kafka, Elasticsearch, Redis, MinIO, WebClient, JOLT, security).',
      'Frontend features on the Angular application and CI/CD with Jenkins, Bitbucket Pipelines and Docker.',
    ],
    tags: [
      'Java 21',
      'Spring Boot 3',
      'Kafka',
      'Elasticsearch',
      'Redis',
      'MinIO',
      'FHIR R4',
      'Angular',
      'Docker',
      'Jenkins',
    ],
  ),
  Experience(
    period: 'August 2023 – August 2025',
    role: 'Backend Java Developer',
    company: 'SONATEL ORANGE',
    summary:
        'Development and enhancement of Java backend applications and microservices within an SOA architecture.',
    bullets: [
      'Level 3 maintenance and technical support, incident resolution and production debugging.',
      'Design and exposure of APIs for Orange B2C/B2B applications (Orange Money, Maxit, Orange & Moi, Kaabu…), internal applications (HR SelfCare) and partner systems.',
      'Collaboration with software architects to implement new interfaces.',
      'Unit, integration and regression tests, applying API development best practices.',
      'Agile/Scrum and SAFe, with strong involvement in continuous delivery.',
      'Distributed architectures: Kafka (streaming), Elastic & ELK (data historisation, monitoring and log analysis).',
    ],
    highlights: [
      Highlight(
        title: 'Docubase – Document Management and Indexing System',
        period: '2023',
        context:
            'A centralized system unifying the document databases of the Orange ecosystem. Each information system previously managed its own repository; the goal was a single platform for document access and management (upload, download, search), improving data consistency and operational efficiency.',
        responsibilities: [
          'Designed and developed RESTful APIs for document search, upload and download.',
          'Implemented a secure microservices architecture with Spring Boot and Spring Cloud.',
          'Integrated Keycloak for authentication and authorization.',
          'Documented and tested APIs with Postman and exposed them through Apigee.',
          'CI/CD with Jenkins and OpenShift; sprint planning in Jira, source code on Bitbucket.',
        ],
        stack:
            'JHipster · Spring Boot · Spring Cloud · Java 11 · Keycloak · Apigee · Postman · Jenkins · OpenShift · Jira · Bitbucket',
        results: [
          'Centralized document databases previously spread across multiple systems.',
          'Simplified integration with other systems through standardized, secure APIs.',
          'Improved document traceability and governance across departments.',
        ],
      ),
      Highlight(
        title: 'Orange Money Package – Wallet Transfer and Billing Redesign',
        period: '2024 – 2025',
        context:
            'Modernisation of the Mobile Money ecosystem by redesigning wallet transfers and billing. Key feature: transaction packages. For example, a 75 XOF package allows up to 10,000 XOF of fee-free transfers; on a 15,000 XOF transfer, the first 10,000 XOF stay free and standard fees apply to the remaining 5,000 XOF.',
        responsibilities: [
          'Designed and developed the microservice for P2P transfers, international remittances, cancellations and package-based fees.',
          'Redesigned the billing module, unifying internal and partner billing in one microservice.',
          'Redis caching for high-volume transactional data; Elasticsearch for search, monitoring and analytics.',
          'Keycloak security, APIs exposed through Apigee and documented with Swagger, Redoc and Postman.',
        ],
        stack:
            'Java 21 · Spring Boot · Spring Cloud · JHipster · Redis · Elasticsearch · Keycloak · Apigee · Swagger · Maven',
        results: [
          'Dynamic package-based pricing model live for Orange Money users.',
          'Partner billing and transaction logic centralized in a single microservice.',
          'Stronger security and transactional integrity through fine-grained access control.',
        ],
      ),
      Highlight(
        title: 'Orange Bank – Tik Tak (Mobile Credit Service)',
        period: '2024 – 2025',
        context:
            'Instant mobile credit for eligible Orange Money customers based on their financial scoring, requested and received directly from the wallet. APIs cover the full credit lifecycle: loan request, partner bank authorization, customer consent, validation and disbursement.',
        responsibilities: [
          'Designed and developed backend APIs for the full credit request and validation workflow.',
          'Integrated authorization and customer consent flows in the Orange Money ecosystem.',
          'Worked with architects and security teams on banking and regulatory compliance.',
          'Unit, integration and regression tests; CI/CD and monitoring on OpenShift.',
        ],
        stack:
            'Java 21 · Spring Boot · Spring Cloud · JHipster · Keycloak · Apigee · Redis · Elasticsearch · Maven',
        results: [
          'Loan processing time cut from several hours to a few seconds.',
          'Fully automated workflow: scoring, authorization, consent, validation.',
          'Credit access for unbanked and underbanked users.',
        ],
      ),
    ],
    tags: [
      'Java 11',
      'Java 21',
      'Spring Boot',
      'Spring Cloud',
      'JHipster',
      'REST API',
      'Kafka',
      'Elasticsearch',
      'Redis',
      'OpenShift',
      'Apigee',
      'Maven',
    ],
  ),
  Experience(
    period: 'August 2023 – August 2025',
    role: 'Fullstack Developer',
    company: 'COOPÉRATIVE SONATEL BAMBILOR',
    summary:
        'Design and development of an integrated web platform for managing human resources, land and plots, tracking contributions and automating plot distribution.',
    tags: ['PHP', 'Symfony 5', 'Python'],
  ),
  Experience(
    period: 'September 2022 – July 2023',
    role: 'Fullstack Developer – Freelance',
    company: 'OMVG',
    summary: 'Study and development of a geographic information system.',
    tags: ['Python', 'Django', 'REST API', 'PostgreSQL', 'Leaflet', 'QGIS'],
  ),
  Experience(
    period: 'November 2021 – June 2022',
    role: 'Fullstack Developer',
    company: 'SONATEL ORANGE',
    summary:
        'Study and development of a microservices architecture with JHipster for the merger of the MYSMC and SELF-SERVICE applications.',
    tags: [
      'Java 11',
      'JHipster',
      'Spring Boot',
      'Spring Cloud',
      'REST API',
      'OpenShift',
      'Apigee',
      'Maven',
    ],
  ),
];

class Education {
  const Education(this.icon, this.degree, this.school, this.period, this.text);
  final IconData icon;
  final String degree;
  final String school;
  final String period;
  final String text;
}

const List<Education> education = [
  Education(
    Icons.school,
    'Master’s Degree in Software Engineering',
    'Higher Institute of Computer Science of Dakar (ISI)',
    '2022 – 2024',
    'Specialisation in software architecture, advanced web development and distributed systems.',
  ),
  Education(
    Icons.menu_book,
    'Bachelor’s Degree in Computer Science',
    'AMDI Institute',
    '2019 – 2022',
    'Comprehensive training in programming, algorithms and information systems.',
  ),
];

class Project {
  const Project({
    required this.title,
    required this.context,
    required this.icon,
    required this.description,
    required this.tags,
  });
  final String title;
  final String context;
  final IconData icon;
  final String description;
  final List<String> tags;
}

const List<Project> projects = [
  Project(
    title: 'SI Médical – Hospital Information System',
    context: 'EYONE SANTÉ · 2025 – Present',
    icon: Icons.local_hospital,
    description:
        'Microservices platform for clinics and hospitals: patients, medical records, medical acts and products, billing, settlement, fees and third-party payer (insurance) management, with Wave / Orange Money payments.',
    tags: ['Java 21', 'Spring Boot', 'Kafka', 'MinIO', 'Angular'],
  ),
  Project(
    title: 'YONEWI – FHIR Interoperability API',
    context: 'EYONE SANTÉ · 2025 – Present',
    icon: Icons.health_and_safety,
    description:
        'FHIR R4 interoperability service for health insurance (ICAMO), integrated with OpenIMIS: patients, insurance plans and contracts, with Elasticsearch indexing and Redis caching.',
    tags: ['FHIR R4', 'OpenIMIS', 'Elasticsearch', 'Redis', 'Docker'],
  ),
  Project(
    title: 'EYONE Télémigration',
    context: 'EYONE SANTÉ · 2026',
    icon: Icons.sync_alt,
    description:
        'Event-driven platform exchanging and migrating medical data between SIMedical, Eyassur (insurance) and Passport through Kafka messages, exposed with secured REST APIs.',
    tags: ['Spring Boot 3.5', 'Spring Cloud Stream', 'Kafka', 'JWT'],
  ),
  Project(
    title: 'EYONE Framework',
    context: 'EYONE SANTÉ · 2026',
    icon: Icons.widgets,
    description:
        'Modular Java framework of reusable Spring Boot starters shared by all medical services: Kafka, Elasticsearch, Redis, MinIO, reactive WebClient, JOLT transformations, auth and utilities.',
    tags: ['Java', 'Spring Boot Starters', 'Maven', 'Kafka', 'Redis'],
  ),
  Project(
    title: 'SI Médical ePayment',
    context: 'EYONE SANTÉ · 2026',
    icon: Icons.payments,
    description:
        'Public payment-return page for Wave and Orange Money: payment status polling, multi-client theming (Eyone, MSAS, CBAO) and mobile-first design, without any build step.',
    tags: ['HTML5', 'CSS3', 'JavaScript', 'Nginx', 'Docker'],
  ),
  Project(
    title: 'ENEXA / StationPilot',
    context: 'SaaS · 2026',
    icon: Icons.local_gas_station,
    description:
        'Multi-company SaaS for managing service stations and their daily closing (bouclage), with one sub-domain and branding per company, role-based menus and JWT security.',
    tags: ['Java 25', 'Spring Boot 4', 'Angular', 'PostgreSQL', 'Dokploy'],
  ),
  Project(
    title: 'Orange Money Package',
    context: 'SONATEL ORANGE · 2024 – 2025',
    icon: Icons.account_balance_wallet,
    description:
        'Redesign of wallet transfers and billing: P2P and international transfers, cancellations and fee-free transaction packages, with a unified partner billing microservice.',
    tags: ['Java 21', 'Spring Cloud', 'Redis', 'Elasticsearch', 'Apigee'],
  ),
  Project(
    title: 'Orange Bank – Tik Tak',
    context: 'SONATEL ORANGE · 2024 – 2025',
    icon: Icons.credit_score,
    description:
        'Instant mobile credit for Orange Money customers: loan request, bank authorization, customer consent and disbursement APIs, cutting processing time from hours to seconds.',
    tags: ['Java 21', 'Spring Boot', 'Keycloak', 'OpenShift'],
  ),
  Project(
    title: 'Buy Now Pay Later',
    context: 'SONATEL ORANGE · 2023 – 2025',
    icon: Icons.shopping_cart_checkout,
    description:
        'Instant loan for Orange Money customers short on balance, so they can keep using Orange Money services right away (Illimix bundles, merchant payments, bill payments…) and pay back later.',
    tags: ['Java 21', 'Spring Boot', 'Spring Cloud', 'Keycloak', 'Apigee'],
  ),
  Project(
    title: 'Docubase',
    context: 'SONATEL ORANGE · 2023',
    icon: Icons.folder_copy,
    description:
        'Centralized document management and indexing system unifying the document repositories of the Orange ecosystem: secure search, upload and download APIs.',
    tags: ['JHipster', 'Spring Cloud', 'Keycloak', 'Apigee', 'Jenkins'],
  ),
  Project(
    title: 'Cooperative Management Platform',
    context: 'COOPÉRATIVE SONATEL BAMBILOR',
    icon: Icons.landscape,
    description:
        'Web platform managing members, land and plots, contribution tracking and automated plot distribution for a housing cooperative.',
    tags: ['PHP', 'Symfony 5', 'Python'],
  ),
  Project(
    title: 'OMVG – Geographic Information System',
    context: 'Freelance · 2022 – 2023',
    icon: Icons.map,
    description:
        'Study and development of a web GIS for the OMVG to visualise and manage geographic data on interactive maps.',
    tags: ['Django', 'PostgreSQL', 'Leaflet', 'QGIS'],
  ),
  Project(
    title: 'Carpooling',
    context: 'Personal project',
    icon: Icons.directions_car,
    description:
        'Carpooling application to publish and book rides, with map-based itineraries and secured user accounts.',
    tags: ['Angular', 'Spring Boot', 'Spring Security', 'MySQL', 'Leaflet'],
  ),
];
