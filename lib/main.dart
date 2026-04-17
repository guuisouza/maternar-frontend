import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gestcare_app/home_dashboard_data_source.dart';

void main() {
  runApp(const GestCareApp());
}

class GestCareColors {
  static const Color deepTeal = Color(0xFF0C7A71);
  static const Color mint = Color(0xFFBEEDE1);
  static const Color softMint = Color(0xFFD9EEE9);
  static const Color cream = Color(0xFFF6EFE5);
  static const Color peach = Color(0xFFF8C9AF);
  static const Color coral = Color(0xFFF6AA8C);
  static const Color background = Color(0xFFF4F7F5);
  static const Color textPrimary = Color(0xFF173831);
  static const Color textMuted = Color(0xFF6B8A83);
}

class GestCareApp extends StatelessWidget {
  const GestCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.dmSansTextTheme(ThemeData.light().textTheme)
        .apply(
          bodyColor: GestCareColors.textPrimary,
          displayColor: GestCareColors.textPrimary,
        );

    return MaterialApp(
      title: 'Maternar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: GestCareColors.background,
        textTheme: textTheme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: GestCareColors.deepTeal,
          primary: GestCareColors.deepTeal,
          secondary: GestCareColors.mint,
          surface: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainAppNavigation(),
        '/questionnaire': (context) => const QuestionnaireScreen(),
        '/processing': (context) => const ProfileProcessingScreen(),
        '/safe-path': (context) => const SafePathResultScreen(),
        '/high-alert': (context) => const HighAlertResultScreen(),
        '/daily-log': (context) => const DailyLogScreen(),
        '/education': (context) => const EducationalArticlesScreen(),
        '/baby-week': (context) => const BabyWeekPlannerScreen(),
        '/nutrition': (context) => const NutritionTipsScreen(),
        '/notifications': (context) => const NotificationCenterScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FBF9), Color(0xFFEFF7F3)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              children: [
                const Spacer(),
                const _PregnancyWelcomeIllustration(),
                const SizedBox(height: 28),
                Text(
                  'Maternar',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: GestCareColors.deepTeal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Acompanhamento preventivo para\numa gestacao tranquila',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: GestCareColors.textMuted,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Criar Minha Conta',
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: const BorderSide(color: Color(0x220C7A71)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    foregroundColor: GestCareColors.textMuted,
                  ),
                  child: const Text('Ja tenho cadastro'),
                ),
                const SizedBox(height: 18),
                Text(
                  'TERMOS DE USO',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.4,
                    color: const Color(0xFFB1C1BA),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isFormattingPhone = false;

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  static final RegExp _numberRegex = RegExp(r'\d');
  static final RegExp _upperRegex = RegExp(r'[A-Z]');
  static final RegExp _lowerRegex = RegExp(r'[a-z]');

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasSpecialChar =>
      _specialCharRegex.hasMatch(_passwordController.text);
  bool get _hasNumber => _numberRegex.hasMatch(_passwordController.text);
  bool get _hasUpperAndLower =>
      _upperRegex.hasMatch(_passwordController.text) &&
      _lowerRegex.hasMatch(_passwordController.text);

  int get _passwordScore {
    int score = 0;
    if (_hasMinLength) score++;
    if (_hasSpecialChar) score++;
    if (_hasNumber) score++;
    if (_hasUpperAndLower) score++;
    return score;
  }

  String get _passwordStrengthLabel {
    if (_passwordController.text.isEmpty) return 'Nao definida';
    if (_passwordScore <= 1) return 'Fraca';
    if (_passwordScore <= 3) return 'Media';
    return 'Forte';
  }

  Color get _passwordStrengthColor {
    if (_passwordController.text.isEmpty) return const Color(0xFFB8C7C2);
    if (_passwordScore <= 1) return const Color(0xFFE87B73);
    if (_passwordScore <= 3) return const Color(0xFFE2A93B);
    return GestCareColors.deepTeal;
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _phoneController.removeListener(_onPhoneChanged);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dueDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onPhoneChanged() {
    if (_isFormattingPhone) return;

    final digitsOnly = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final clamped = digitsOnly.length > 11
        ? digitsOnly.substring(0, 11)
        : digitsOnly;
    final formatted = _formatPhone(clamped);

    _isFormattingPhone = true;
    _phoneController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    _isFormattingPhone = false;
  }

  String _formatPhone(String digits) {
    if (digits.isEmpty) return '';
    if (digits.length <= 2) return '($digits';

    final ddd = digits.substring(0, 2);
    final rest = digits.substring(2);

    if (rest.length <= 4) {
      return '($ddd) $rest';
    }

    if (digits.length <= 10) {
      final first = rest.substring(0, 4);
      final second = rest.substring(4);
      return second.isEmpty ? '($ddd) $first' : '($ddd) $first-$second';
    }

    final first = rest.substring(0, 5);
    final second = rest.substring(5);
    return second.isEmpty ? '($ddd) $first' : '($ddd) $first-$second';
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final initial = now.add(const Duration(days: 120));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 320)),
      helpText: 'Data prevista do parto',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );

    if (picked == null) return;

    final day = picked.day.toString().padLeft(2, '0');
    final month = picked.month.toString().padLeft(2, '0');
    final year = picked.year.toString();
    _dueDateController.text = '$day/$month/$year';
  }

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe seu nome completo.';
    if (text.length < 3) return 'Nome muito curto.';
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe seu e-mail.';
    if (!_emailRegex.hasMatch(text)) return 'E-mail invalido.';
    return null;
  }

  String? _validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'Informe seu telefone.';
    if (digits.length < 10) return 'Telefone incompleto.';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Crie uma senha.';
    if (text.length < 8) return 'A senha precisa ter no minimo 8 caracteres.';
    if (!_specialCharRegex.hasMatch(text)) {
      return 'Inclua ao menos 1 caractere especial.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Confirme sua senha.';
    if (value != _passwordController.text) return 'As senhas nao conferem.';
    return null;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro validado com sucesso!')),
    );

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(
                'Vamos comecar sua jornada',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preencha seus dados para acessar o acompanhamento personalizado.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GestCareColors.textMuted,
                ),
              ),
              const SizedBox(height: 18),
              LabeledField(
                label: 'Nome completo',
                child: TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Ana Clara Sousa',
                  ),
                ),
              ),
              LabeledField(
                label: 'E-mail',
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    hintText: 'seuemail@exemplo.com',
                  ),
                ),
              ),
              LabeledField(
                label: 'Telefone',
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: _validatePhone,
                  decoration: const InputDecoration(
                    hintText: '(11) 99999-8888',
                  ),
                ),
              ),
              LabeledField(
                label: 'Data prevista do parto (opcional)',
                child: TextFormField(
                  controller: _dueDateController,
                  readOnly: true,
                  onTap: _pickDueDate,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Selecione uma data',
                    suffixIcon: IconButton(
                      onPressed: _pickDueDate,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ),
                ),
              ),
              LabeledField(
                label: 'Senha',
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    hintText: 'Crie uma senha segura',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _hidePassword = !_hidePassword);
                      },
                      icon: Icon(
                        _hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Regras da senha',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _PasswordRuleTile(
                      passed: _hasMinLength,
                      label: 'Minimo de 8 caracteres',
                    ),
                    const SizedBox(height: 6),
                    _PasswordRuleTile(
                      passed: _hasSpecialChar,
                      label: 'Pelo menos 1 caractere especial',
                    ),
                    const SizedBox(height: 6),
                    _PasswordRuleTile(
                      passed: _hasNumber,
                      label: 'Pelo menos 1 numero',
                    ),
                    const SizedBox(height: 6),
                    _PasswordRuleTile(
                      passed: _hasUpperAndLower,
                      label: 'Letras maiusculas e minusculas',
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      minHeight: 8,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      value: _passwordController.text.isEmpty
                          ? 0
                          : _passwordScore / 4,
                      color: _passwordStrengthColor,
                      backgroundColor: const Color(0xFFE6EEEA),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Forca da senha: $_passwordStrengthLabel',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _passwordStrengthColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              LabeledField(
                label: 'Confirmar senha',
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _hideConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText: 'Repita sua senha',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(
                          () => _hideConfirmPassword = !_hideConfirmPassword,
                        );
                      },
                      icon: Icon(
                        _hideConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(label: 'Finalizar Cadastro', onPressed: _submit),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordRuleTile extends StatelessWidget {
  const _PasswordRuleTile({required this.passed, required this.label});

  final bool passed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: passed ? GestCareColors.deepTeal : GestCareColors.textMuted,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: passed
                ? GestCareColors.textPrimary
                : GestCareColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class MainAppNavigation extends StatefulWidget {
  const MainAppNavigation({super.key});

  @override
  State<MainAppNavigation> createState() => _MainAppNavigationState();
}

class _MainAppNavigationState extends State<MainAppNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboardScreen(),
    HealthMetricsScreen(),
    ConsultationHistoryScreen(),
    ProfileSettingsScreen(),
  ];

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFEAF1EE),
        elevation: 8,
        unselectedItemColor: const Color(0xFF97ABA4),
        selectedItemColor: GestCareColors.deepTeal,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saude'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Consultas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({
    this.dataSource = const MockHomeDashboardDataSource(),
    super.key,
  });

  final HomeDashboardDataSource dataSource;

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  late Future<HomeDashboardData> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = widget.dataSource.fetch();
  }

  void _reload() {
    setState(() {
      _dashboardFuture = widget.dataSource.fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<HomeDashboardData>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Nao foi possivel carregar os dados da Home.'),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: _reload,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data!;
            final babySize = _babySizeForWeek(data.currentWeek);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              children: [
                _HomeGreetingHeader(
                  userName: data.userName,
                  currentWeek: data.currentWeek,
                  onNotificationsTap: () =>
                      Navigator.pushNamed(context, '/notifications'),
                ),
                const SizedBox(height: 20),
                _HomeHealthProfileCard(
                  onQuestionnaireTap: () =>
                      Navigator.pushNamed(context, '/questionnaire'),
                ),
                const SizedBox(height: 16),
                _HomeStatusCardsRow(
                  currentWeek: data.currentWeek,
                  babySizeName: babySize.name,
                  babySizeIcon: babySize.icon,
                  daysToBirth: data.daysToBirth,
                  onBabySizeTap: () =>
                      Navigator.pushNamed(context, '/baby-week'),
                ),
                const SizedBox(height: 16),
                _HomeDailyTipsSection(
                  tips: data.dailyTips,
                  onSeeAllTap: () => Navigator.pushNamed(context, '/education'),
                  onTipTap: (tip) {
                    if (tip.routeName != null) {
                      Navigator.pushNamed(context, tip.routeName!);
                    }
                  },
                ),
                const SizedBox(height: 16),
                _HomeQuickActionsSection(
                  actions: data.quickActions,
                  onActionTap: (action) {
                    Navigator.pushNamed(context, action.routeName);
                  },
                ),
                const SizedBox(height: 18),
                _HomeRecommendedArticleCard(
                  title: data.recommendedArticleTitle,
                  onTap: () => Navigator.pushNamed(
                    context,
                    data.recommendedArticleRoute,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeGreetingHeader extends StatelessWidget {
  const _HomeGreetingHeader({
    required this.userName,
    required this.currentWeek,
    required this.onNotificationsTap,
  });

  final String userName;
  final int currentWeek;
  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: GestCareColors.peach,
          child: Icon(Icons.face, color: GestCareColors.deepTeal),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Oi, $userName!',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                '${currentWeek} semanas de gestação',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: GestCareColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onNotificationsTap,
          tooltip: 'Abrir notificacoes',
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}

class _HomeHealthProfileCard extends StatelessWidget {
  const _HomeHealthProfileCard({required this.onQuestionnaireTap});

  final VoidCallback onQuestionnaireTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFC4F3E8), Color(0xFF8CDDC9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x55FFFFFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'SEU PERFIL ATUAL',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: GestCareColors.textMuted,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Como voce esta\nse sentindo hoje?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Compartilhe sintomas para receber orientacao especializada.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Responder questionario de saude',
            icon: Icons.arrow_forward,
            onPressed: onQuestionnaireTap,
          ),
        ],
      ),
    );
  }
}

class _HomeStatusCardsRow extends StatelessWidget {
  const _HomeStatusCardsRow({
    required this.currentWeek,
    required this.babySizeName,
    required this.babySizeIcon,
    required this.daysToBirth,
    required this.onBabySizeTap,
  });

  final int currentWeek;
  final String babySizeName;
  final IconData babySizeIcon;
  final int daysToBirth;
  final VoidCallback onBabySizeTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TinyStatusCard(
            title: '$currentWeek semanas',
            value: 'Tamanho de $babySizeName',
            icon: babySizeIcon,
            onTap: onBabySizeTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TinyStatusCard(
            title: 'Dias para o parto',
            value: '$daysToBirth dias',
            icon: Icons.favorite,
            warm: true,
          ),
        ),
      ],
    );
  }
}

class _HomeDailyTipsSection extends StatelessWidget {
  const _HomeDailyTipsSection({
    required this.tips,
    required this.onSeeAllTap,
    required this.onTipTap,
  });

  final List<HomeTipData> tips;
  final VoidCallback onSeeAllTap;
  final ValueChanged<HomeTipData> onTipTap;

  IconData _iconForKey(String key) {
    switch (key) {
      case 'water':
        return Icons.water_drop;
      case 'meditation':
        return Icons.self_improvement;
      case 'nutrition':
        return Icons.restaurant_menu;
      default:
        return Icons.tips_and_updates;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dicas de hoje',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            TextButton(onPressed: onSeeAllTap, child: const Text('Ver tudo')),
          ],
        ),
        for (final tip in tips) ...[
          TipTile(
            icon: _iconForKey(tip.iconKey),
            title: tip.title,
            subtitle: tip.subtitle,
            warm: tip.warm,
            onTap: () => onTipTap(tip),
          ),
          if (tip != tips.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _HomeQuickActionsSection extends StatelessWidget {
  const _HomeQuickActionsSection({
    required this.actions,
    required this.onActionTap,
  });

  final List<HomeQuickActionData> actions;
  final ValueChanged<HomeQuickActionData> onActionTap;

  IconData _iconForKey(String key) {
    switch (key) {
      case 'diary':
        return Icons.edit_note;
      case 'library':
        return Icons.menu_book;
      default:
        return Icons.widgets;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        for (int index = 0; index < actions.length; index++) ...[
          Expanded(
            child: QuickActionCard(
              icon: _iconForKey(actions[index].iconKey),
              title: actions[index].title,
              subtitle: actions[index].subtitle,
              onTap: () => onActionTap(actions[index]),
            ),
          ),
          if (index < actions.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _HomeRecommendedArticleCard extends StatelessWidget {
  const _HomeRecommendedArticleCard({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 145,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF0A1A1F), Color(0xFF283A40)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ARTIGO RECOMENDADO',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF9FB5BC),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HealthMetricsScreen extends StatelessWidget {
  const HealthMetricsScreen({super.key});

  void _showManualEntrySheet(BuildContext context) {
    final valueController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adicionar medicao',
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text('Valor da medicao'),
              const SizedBox(height: 8),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(
                  hintText: 'Ex: 118/76 ou 68.2',
                ),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Salvar',
                onPressed: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        valueController.text.isEmpty
                            ? 'Medicao salva.'
                            : 'Medicao ${valueController.text} salva.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metricas de Saude'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              'Acompanhe seu progresso',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _MetricCard(
              title: 'Pressao Arterial',
              value: '120/80 mmHg',
              subtitle: 'Ultima medicao: Hoje',
              icon: Icons.favorite,
              isNormal: true,
            ),
            const SizedBox(height: 12),
            _MetricCard(
              title: 'Peso',
              value: '68.5 kg',
              subtitle: 'Ganho de 8.5kg na gestacao',
              icon: Icons.scale,
              isNormal: true,
            ),
            const SizedBox(height: 12),
            _MetricCard(
              title: 'Glicemia',
              value: '95 mg/dL',
              subtitle: 'Ultima medicao: 2 dias atras',
              icon: Icons.trending_up,
              isNormal: true,
            ),
            const SizedBox(height: 12),
            _MetricCard(
              title: 'Tamanho do Bebe',
              value: '30.5 cm',
              subtitle: 'Peso estimado: 700g',
              icon: Icons.child_care,
              isNormal: true,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Adicionar Medicao Manual',
              icon: Icons.add,
              onPressed: () => _showManualEntrySheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final bool isNormal;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.isNormal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNormal ? GestCareColors.mint : GestCareColors.coral,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isNormal
                ? const Color(0xFFE5F2FF)
                : const Color(0xFFFFE8DA),
            child: Icon(
              icon,
              color: isNormal ? GestCareColors.deepTeal : GestCareColors.coral,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: GestCareColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: GestCareColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});

  void _openScheduleDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Agendar consulta'),
          content: const Text(
            'Fluxo de agendamento em construcao. Em breve voce podera escolher data, horario e especialidade.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final consultations = [
      {
        'date': '15 de Abril',
        'professional': 'Dra. Marina Silva',
        'type': 'Consulta Pre-Natal',
        'notes': 'Tudo normal, bebe em posicao correta',
        'done': true,
      },
      {
        'date': '25 de Abril',
        'professional': 'Dra. Marina Silva',
        'type': 'Ultrassom',
        'notes': 'Agendado',
        'done': false,
      },
      {
        'date': '10 de Maio',
        'professional': 'Dr. Carlos Mendes',
        'type': 'Consulta Pre-Natal',
        'notes': 'Agendado',
        'done': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Consultas'),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openScheduleDialog(context),
        backgroundColor: GestCareColors.deepTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agendar'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              'Historico e proximas consultas',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < consultations.length; i++) ...[
              _ConsultationTile(
                date: consultations[i]['date'] as String,
                professional: consultations[i]['professional'] as String,
                type: consultations[i]['type'] as String,
                notes: consultations[i]['notes'] as String,
                isDone: consultations[i]['done'] as bool,
              ),
              if (i < consultations.length - 1) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _ConsultationTile extends StatelessWidget {
  final String date;
  final String professional;
  final String type;
  final String notes;
  final bool isDone;

  const _ConsultationTile({
    required this.date,
    required this.professional,
    required this.type,
    required this.notes,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDone ? GestCareColors.mint : const Color(0xFFE0E6E3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDone ? Icons.check_circle : Icons.calendar_today,
                color: isDone
                    ? GestCareColors.deepTeal
                    : GestCareColors.textMuted,
                size: 20,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    type,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: GestCareColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            professional,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: GestCareColors.textMuted),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDone ? const Color(0xFFF0F9F6) : const Color(0xFFFAF9F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(notes, style: Theme.of(context).textTheme.labelSmall),
          ),
        ],
      ),
    );
  }
}

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sair da conta'),
          content: const Text('Deseja encerrar a sessao agora?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: GestCareColors.peach,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: GestCareColors.deepTeal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ana Clara Sousa',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ana.sousa@email.com',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: GestCareColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Dados Pessoais',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _SettingRow(
              icon: Icons.cake,
              title: 'Data de Nascimento',
              subtitle: '12 de Janeiro de 1995',
            ),
            _SettingRow(
              icon: Icons.phone,
              title: 'Telefone',
              subtitle: '(11) 9 9999-8888',
            ),
            _SettingRow(
              icon: Icons.location_on,
              title: 'Endereco',
              subtitle: 'Sao Paulo, SP',
            ),
            const SizedBox(height: 24),
            Text(
              'Preferencias',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _PreferenceToggle(title: 'Notificacoes', enabled: true),
            _PreferenceToggle(title: 'Lembretes de Consultas', enabled: true),
            _PreferenceToggle(title: 'Dicas Diarias', enabled: false),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => _confirmLogout(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: GestCareColors.coral),
              ),
              child: const Text('Sair da Conta'),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyLogScreen extends StatefulWidget {
  const DailyLogScreen({super.key});

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen> {
  final TextEditingController _noteController = TextEditingController();
  final Set<String> _selectedSymptoms = {};
  final List<Map<String, String>> _entries = [
    {
      'date': '15 Abr',
      'mood': 'Calma',
      'symptoms': 'Leve cansaco',
      'note': 'Dormir melhor hoje.',
    },
  ];

  double _moodScore = 4;

  final List<String> _symptoms = const [
    'Nausea',
    'Cansaco',
    'Dor nas costas',
    'Inchaco',
    'Azia',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _moodLabel(double score) {
    if (score <= 2) return 'Sensivel';
    if (score <= 3) return 'Estavel';
    if (score <= 4) return 'Calma';
    return 'Animada';
  }

  void _saveEntry() {
    final symptomText = _selectedSymptoms.isEmpty
        ? 'Sem sintomas'
        : _selectedSymptoms.join(', ');

    setState(() {
      _entries.insert(0, {
        'date': 'Hoje',
        'mood': _moodLabel(_moodScore),
        'symptoms': symptomText,
        'note': _noteController.text.trim().isEmpty
            ? 'Sem observacoes adicionais.'
            : _noteController.text.trim(),
      });
      _noteController.clear();
      _selectedSymptoms.clear();
      _moodScore = 4;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entrada do diario registrada.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diario de Sintomas'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(
              'Como voce esta hoje?',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Humor: ${_moodLabel(_moodScore)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Slider(
                    value: _moodScore,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: GestCareColors.deepTeal,
                    label: _moodLabel(_moodScore),
                    onChanged: (value) => setState(() => _moodScore = value),
                  ),
                  const SizedBox(height: 8),
                  const Text('Sintomas percebidos'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _symptoms.map((symptom) {
                      final selected = _selectedSymptoms.contains(symptom);
                      return FilterChip(
                        label: Text(symptom),
                        selected: selected,
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              _selectedSymptoms.add(symptom);
                            } else {
                              _selectedSymptoms.remove(symptom);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Observacoes'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Ex: senti mais cansaco no fim da tarde.',
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: 'Salvar no Diario',
                    onPressed: _saveEntry,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ultimos registros',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            for (final entry in _entries)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry['date']} - ${entry['mood']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry['symptoms']!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: GestCareColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(entry['note']!),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EducationalArticlesScreen extends StatefulWidget {
  const EducationalArticlesScreen({super.key});

  @override
  State<EducationalArticlesScreen> createState() =>
      _EducationalArticlesScreenState();
}

class _EducationalArticlesScreenState extends State<EducationalArticlesScreen> {
  String _selectedCategory = 'Todos';
  final Set<String> _savedArticles = {};

  final List<Map<String, String>> _articles = const [
    {
      'title': 'Sinais de alerta no terceiro trimestre',
      'category': 'Saude',
      'time': '6 min',
      'excerpt': 'Aprenda quais sinais precisam de avaliacao imediata.',
    },
    {
      'title': 'Rotina noturna para melhorar o sono',
      'category': 'Bem-estar',
      'time': '4 min',
      'excerpt': 'Ajustes simples para descansar melhor nessa fase.',
    },
    {
      'title': 'Plano de parto: o que conversar com a equipe',
      'category': 'Preparo',
      'time': '7 min',
      'excerpt': 'Defina preferencias e entenda opcoes com antecedencia.',
    },
  ];

  List<Map<String, String>> get _filteredArticles {
    if (_selectedCategory == 'Todos') return _articles;
    return _articles
        .where((article) => article['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    const categories = ['Todos', 'Saude', 'Bem-estar', 'Preparo'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca Educativa'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(
              'Conteudos para cada fase',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: category == _selectedCategory,
                  onSelected: (_) {
                    setState(() => _selectedCategory = category);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            for (final article in _filteredArticles)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: GestCareColors.softMint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            article['category']!,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          article['time']!,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              final title = article['title']!;
                              if (_savedArticles.contains(title)) {
                                _savedArticles.remove(title);
                              } else {
                                _savedArticles.add(title);
                              }
                            });
                          },
                          icon: Icon(
                            _savedArticles.contains(article['title'])
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: GestCareColors.deepTeal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article['title']!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article['excerpt']!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GestCareColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Leitura completa em breve.'),
                          ),
                        );
                      },
                      child: const Text('Ler conteudo'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BabyWeekPlannerScreen extends StatefulWidget {
  const BabyWeekPlannerScreen({super.key});

  @override
  State<BabyWeekPlannerScreen> createState() => _BabyWeekPlannerScreenState();
}

class _BabyWeekPlannerScreenState extends State<BabyWeekPlannerScreen> {
  final TextEditingController _taskController = TextEditingController();

  int _currentWeek = 24;

  bool _showAllTasks = false;

  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Tomar vitamina pre-natal', 'done': true},
    {'title': 'Agendar ultrassom desta semana', 'done': false},
    {'title': 'Beber pelo menos 2L de agua por dia', 'done': false},
    {'title': 'Separar exames para consulta', 'done': false},
  ];

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  int get _doneCount => _tasks.where((task) => task['done'] == true).length;

  _BabySizeInfo get _babySizeInfo => _babySizeForWeek(_currentWeek);

  List<Map<String, dynamic>> get _visibleTasks {
    if (_showAllTasks || _tasks.length <= 3) return _tasks;
    return _tasks.take(3).toList();
  }

  void _toggleTask(int index, bool? checked) {
    setState(() {
      _tasks[index]['done'] = checked ?? false;
    });
  }

  void _addTask() {
    final title = _taskController.text.trim();
    if (title.isEmpty) return;

    setState(() {
      _tasks.add({'title': title, 'done': false});
      _taskController.clear();
      _showAllTasks = true;
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Nova tarefa adicionada.')));
  }

  void _openAddTaskDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Adicionar tarefa'),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Ex: Caminhar 20 minutos',
            ),
            onSubmitted: (_) => _addTask(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _taskController.clear();
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(onPressed: _addTask, child: const Text('Adicionar')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semana do Bebe'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: GestCareColors.softMint,
                    child: const Icon(
                      Icons.calendar_month,
                      color: GestCareColors.deepTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voce esta na ${_currentWeek}a semana',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Acompanhamento semanal ativo',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: GestCareColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ajustar semana da gestacao',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: GestCareColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Slider(
                    min: 4,
                    max: 40,
                    divisions: 36,
                    activeColor: GestCareColors.deepTeal,
                    value: _currentWeek.toDouble(),
                    label: '$_currentWeek semanas',
                    onChanged: (value) {
                      setState(() => _currentWeek = value.round());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF2E4), Color(0xFFFFE8CF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tamanho do bebe',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: GestCareColors.textMuted,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Seu bebe tem o\ntamanho de ${_babySizeInfo.article} ${_babySizeInfo.name}!',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: _FruitIllustration(info: _babySizeInfo),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Suas tarefas da semana',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _showAllTasks = !_showAllTasks);
                  },
                  child: Text(_showAllTasks ? 'Ver menos' : 'Ver todas'),
                ),
              ],
            ),
            Text(
              'Concluidas: $_doneCount de ${_tasks.length}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: GestCareColors.textMuted),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              minHeight: 7,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              value: _tasks.isEmpty ? 0 : _doneCount / _tasks.length,
              color: GestCareColors.deepTeal,
              backgroundColor: const Color(0xFFE3ECE8),
            ),
            const SizedBox(height: 12),
            for (final task in _visibleTasks)
              _WeeklyTaskCard(
                title: task['title'] as String,
                done: task['done'] as bool,
                onChanged: (value) {
                  final index = _tasks.indexOf(task);
                  _toggleTask(index, value);
                },
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _openAddTaskDialog,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Adicionar outra tarefa'),
            ),
          ],
        ),
      ),
    );
  }
}

class NutritionTipsScreen extends StatelessWidget {
  const NutritionTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        'title': 'Cafe da manha nutritivo',
        'description':
            'Inclua 1 fonte de proteina (ovo, iogurte natural) e 1 fruta rica em fibras.',
        'icon': Icons.breakfast_dining,
      },
      {
        'title': 'Prato equilibrado no almoco',
        'description':
            'Metade do prato com legumes e verduras, 1 porcao de proteina magra e carboidrato integral.',
        'icon': Icons.lunch_dining,
      },
      {
        'title': 'Lanches inteligentes',
        'description':
            'Prefira castanhas, frutas e sanduiche natural em vez de ultraprocessados.',
        'icon': Icons.apple,
      },
      {
        'title': 'Hidratacao diaria',
        'description':
            'Meta de 2 a 3 litros de agua por dia, com pequenos goles ao longo do dia.',
        'icon': Icons.local_drink,
      },
      {
        'title': 'Seguranca alimentar',
        'description':
            'Evite alimentos crus de risco e mantenha boa higiene no preparo das refeicoes.',
        'icon': Icons.health_and_safety,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dicas de Nutricao'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(
              'Alimentacao para cada fase',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Sugestoes gerais para ajudar no bem-estar da gestacao. Elas nao substituem orientacao medica personalizada.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: GestCareColors.textMuted),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6F1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: GestCareColors.deepTeal,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Converse com sua nutricionista ou obstetra para ajustes conforme exames e sintomas.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            for (final tip in tips)
              _NutritionTipCard(
                title: tip['title']! as String,
                description: tip['description']! as String,
                icon: tip['icon']! as IconData,
              ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Salvar lembrete de hidratacao',
              icon: Icons.alarm,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lembrete salvo. Em breve com notificacoes.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Consulta amanha as 09:30',
      'message': 'Leve seus ultimos exames e cartao de pre-natal.',
      'read': false,
    },
    {
      'title': 'Hora da hidratacao',
      'message': 'Beba um copo de agua e marque no diario.',
      'read': false,
    },
    {
      'title': 'Novo conteudo recomendado',
      'message': 'Confira o artigo sobre plano de parto.',
      'read': true,
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (final item in _notifications) {
        item['read'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificacoes'),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text('Marcar lidas'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final item = _notifications[index];
            final isRead = item['read'] as bool;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isRead ? Colors.white : const Color(0xFFE9F4F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                onTap: () {
                  setState(() => item['read'] = true);
                },
                leading: CircleAvatar(
                  backgroundColor: isRead
                      ? const Color(0xFFECEFED)
                      : GestCareColors.mint,
                  child: Icon(
                    isRead ? Icons.notifications_none : Icons.notifications,
                    color: GestCareColors.deepTeal,
                  ),
                ),
                title: Text(
                  item['title'] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                  ),
                ),
                subtitle: Text(item['message'] as String),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFF1F6F3),
            child: Icon(icon, color: GestCareColors.deepTeal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: GestCareColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferenceToggle extends StatefulWidget {
  final String title;
  final bool enabled;

  const _PreferenceToggle({required this.title, required this.enabled});

  @override
  State<_PreferenceToggle> createState() => _PreferenceToggleState();
}

class _PreferenceToggleState extends State<_PreferenceToggle> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          Switch(
            value: _isEnabled,
            onChanged: (value) => setState(() => _isEnabled = value),
            activeColor: GestCareColors.deepTeal,
          ),
        ],
      ),
    );
  }
}

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final TextEditingController _ageController = TextEditingController();
  String _lastSeries = '';
  bool _firstPregnancy = true;

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Conhecendo Voce'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LinearProgressIndicator(
                  value: 0.2,
                  minHeight: 6,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: GestCareColors.deepTeal,
                  backgroundColor: Color(0xFFE2ECE8),
                ),
                const SizedBox(height: 24),
                Text(
                  'Sua jornada,\nseu cuidado.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Conte-nos um pouco sobre voce para personalizarmos seu Sanctuary.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: GestCareColors.textMuted,
                  ),
                ),
                const SizedBox(height: 18),
                LabeledField(
                  label: 'Sua idade',
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Ex: 28'),
                  ),
                ),
                LabeledField(
                  label: 'Ultima serie concluida',
                  child: DropdownButtonFormField<String>(
                    value: _lastSeries.isEmpty ? null : _lastSeries,
                    decoration: const InputDecoration(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Ensino fundamental',
                        child: Text('Ensino fundamental'),
                      ),
                      DropdownMenuItem(
                        value: 'Ensino medio',
                        child: Text('Ensino medio'),
                      ),
                      DropdownMenuItem(
                        value: 'Ensino superior',
                        child: Text('Ensino superior'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _lastSeries = value ?? ''),
                  ),
                ),
                LabeledField(
                  label: 'Consultas de pre-natal realizadas',
                  child: TextField(
                    decoration: const InputDecoration(hintText: '0'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Primeira gestacao?',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('Sim')),
                    ButtonSegment(value: false, label: Text('Nao')),
                  ],
                  selected: {_firstPregnancy},
                  onSelectionChanged: (values) {
                    setState(() => _firstPregnancy = values.first);
                  },
                ),
                const SizedBox(height: 24),
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD2F4EA), Color(0xFFF1F9F6)],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Voltar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Proximo',
                        icon: Icons.arrow_forward,
                        onPressed: () =>
                            Navigator.pushNamed(context, '/processing'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileProcessingScreen extends StatelessWidget {
  const ProfileProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SereneSanctuary'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: GestCareColors.deepTeal,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x440C7A71),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Criando seu caminho\npersonalizado...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Estamos cruzando suas informacoes para te dar as melhores orientacoes.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GestCareColors.textMuted,
                ),
              ),
              const SizedBox(height: 22),
              const DotLoader(),
              const SizedBox(height: 12),
              const LinearProgressIndicator(
                value: 0.68,
                minHeight: 6,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: GestCareColors.deepTeal,
              ),
              const SizedBox(height: 8),
              Text(
                'PROCESSANDO',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: GestCareColors.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFE6ECE9),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Ver Resultado Seguro',
                onPressed: () => Navigator.pushNamed(context, '/safe-path'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/high-alert'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Ver Resultado de Atencao'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SafePathResultScreen extends StatelessWidget {
  const SafePathResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResultTemplate(
      title: 'Tudo pronto! Seu perfil esta definido.',
      subtitle:
          'Uma jornada de cuidado e serenidade comeca agora para voce e seu bebe.',
      badgeTitle: 'Caminho Seguro',
      badgeDescription: 'Parabens pelo otimo acompanhamento da sua gestacao!',
      actionLabel: 'Ir para o Meu Painel',
      actionRoute: '/home',
      isAlert: false,
      tips: [
        'Ritmo de hidratacao: mantenha consumo de agua constante para o bem-estar.',
        'Pausas de descanso: reserve pequenos periodos durante o dia para recuperar energia.',
        'Suplementacao ativa: siga o plano vitaminico recomendado no pre-natal.',
      ],
    );
  }
}

class HighAlertResultScreen extends StatelessWidget {
  const HighAlertResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResultTemplate(
      title: 'Tudo pronto! Seu perfil esta definido.',
      subtitle: '',
      badgeTitle: 'Atencao Redobrada',
      badgeDescription:
          'Sua gestacao precisa de um pouco mais de cuidado. Estamos aqui para ajudar.',
      actionLabel: 'Entrar em Contato com a Rede de Apoio',
      actionRoute: '/home',
      isAlert: true,
      tips: [
        'Monitore sua pressao arterial diariamente e anote em diario de saude.',
        'Fique atenta a inchacos repentinos nas maos e no rosto.',
        'Mantenha contato da sua obstetra e da rede de apoio sempre a mao.',
      ],
    );
  }
}

class ResultTemplate extends StatelessWidget {
  const ResultTemplate({
    required this.title,
    required this.subtitle,
    required this.badgeTitle,
    required this.badgeDescription,
    required this.actionLabel,
    required this.actionRoute,
    required this.isAlert,
    required this.tips,
    super.key,
  });

  final String title;
  final String subtitle;
  final String badgeTitle;
  final String badgeDescription;
  final String actionLabel;
  final String actionRoute;
  final bool isAlert;
  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAlert ? 'Atencao Redobrada' : 'Caminho Seguro'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GestCareColors.textMuted,
                ),
              ),
            ],
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: isAlert
                    ? const Color(0xFFFFE1D1)
                    : const Color(0xFFE9F4F0),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: isAlert
                        ? GestCareColors.peach
                        : GestCareColors.mint,
                    child: Icon(
                      isAlert ? Icons.flag : Icons.verified_user,
                      color: GestCareColors.deepTeal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    badgeTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: GestCareColors.deepTeal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badgeDescription,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isAlert
                  ? 'Orientacoes Urgentinhas'
                  : 'Orientacoes Personalizadas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            for (final tip in tips)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      isAlert
                          ? Icons.priority_high_rounded
                          : Icons.check_circle_rounded,
                      color: isAlert
                          ? GestCareColors.coral
                          : GestCareColors.deepTeal,
                    ),
                    title: Text(tip),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: actionLabel,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  actionRoute,
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Revisar Respostas'),
            ),
          ],
        ),
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  const LabeledField({required this.label, required this.child, super.key});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: GestCareColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class DotLoader extends StatelessWidget {
  const DotLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoaderDot(opacity: 1),
        SizedBox(width: 8),
        LoaderDot(opacity: 0.7),
        SizedBox(width: 8),
        LoaderDot(opacity: 0.45),
      ],
    );
  }
}

class LoaderDot extends StatelessWidget {
  const LoaderDot({required this.opacity, super.key});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: GestCareColors.deepTeal,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class TipTile extends StatelessWidget {
  const TipTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.warm = false,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool warm;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: '$title. $subtitle',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: warm
                ? const Color(0xFFFFE8DA)
                : const Color(0xFFE5F2FF),
            child: Icon(
              icon,
              color: warm ? GestCareColors.coral : GestCareColors.deepTeal,
            ),
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class _NutritionTipCard extends StatelessWidget {
  const _NutritionTipCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE8F6F1),
            child: Icon(icon, color: GestCareColors.deepTeal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: GestCareColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TinyStatusCard extends StatelessWidget {
  const TinyStatusCard({
    required this.title,
    required this.value,
    required this.icon,
    this.warm = false,
    this.onTap,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool warm;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: '$title: $value',
      child: Material(
        color: warm ? const Color(0xFFFFE0CC) : const Color(0xFFF1F6F3),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: GestCareColors.deepTeal),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: GestCareColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: GestCareColors.deepTeal),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: GestCareColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyTaskCard extends StatelessWidget {
  const _WeeklyTaskCard({
    required this.title,
    required this.done,
    required this.onChanged,
  });

  final String title;
  final bool done;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: CheckboxListTile(
        value: done,
        onChanged: onChanged,
        activeColor: GestCareColors.deepTeal,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            decoration: done ? TextDecoration.lineThrough : null,
            color: done ? GestCareColors.textMuted : GestCareColors.textPrimary,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

class _BabySizeInfo {
  const _BabySizeInfo({
    required this.name,
    this.article = 'uma',
    required this.icon,
    required this.kind,
    required this.primaryColor,
    required this.secondaryColor,
    required this.leafColor,
  });

  final String name;
  final String article;
  final IconData icon;
  final _FruitKind kind;
  final Color primaryColor;
  final Color secondaryColor;
  final Color leafColor;
}

_BabySizeInfo _babySizeForWeek(int currentWeek) {
  if (currentWeek <= 8) {
    return const _BabySizeInfo(
      name: 'Morango',
      article: 'um',
      icon: Icons.circle,
      kind: _FruitKind.berry,
      primaryColor: Color(0xFFE66A8C),
      secondaryColor: Color(0xFFB8325A),
      leafColor: Color(0xFF4F8A4C),
    );
  }
  if (currentWeek <= 12) {
    return const _BabySizeInfo(
      name: 'Limao',
      article: 'um',
      icon: Icons.circle_outlined,
      kind: _FruitKind.citrus,
      primaryColor: Color(0xFFFFD94D),
      secondaryColor: Color(0xFFF2C500),
      leafColor: Color(0xFF5FA35C),
    );
  }
  if (currentWeek <= 16) {
    return const _BabySizeInfo(
      name: 'Abacate',
      article: 'um',
      icon: Icons.spa,
      kind: _FruitKind.avocado,
      primaryColor: Color(0xFF9AC46A),
      secondaryColor: Color(0xFF5F8D40),
      leafColor: Color(0xFF3F6D3D),
    );
  }
  if (currentWeek <= 20) {
    return const _BabySizeInfo(
      name: 'Banana',
      icon: Icons.emoji_food_beverage,
      kind: _FruitKind.banana,
      primaryColor: Color(0xFFFFE07A),
      secondaryColor: Color(0xFFE4B83A),
      leafColor: Color(0xFF6E9A50),
    );
  }
  if (currentWeek <= 24) {
    return const _BabySizeInfo(
      name: 'Manga',
      icon: Icons.apple,
      kind: _FruitKind.mango,
      primaryColor: Color(0xFFFFB347),
      secondaryColor: Color(0xFFE87C3D),
      leafColor: Color(0xFF5E9C55),
    );
  }
  if (currentWeek <= 28) {
    return const _BabySizeInfo(
      name: 'Berinjela',
      icon: Icons.eco,
      kind: _FruitKind.eggplant,
      primaryColor: Color(0xFF8C66D0),
      secondaryColor: Color(0xFF5B3A99),
      leafColor: Color(0xFF58915B),
    );
  }
  if (currentWeek <= 32) {
    return const _BabySizeInfo(
      name: 'Coco',
      article: 'um',
      icon: Icons.bubble_chart,
      kind: _FruitKind.coconut,
      primaryColor: Color(0xFFB78A55),
      secondaryColor: Color(0xFF8E6337),
      leafColor: Color(0xFF4E8A4B),
    );
  }
  if (currentWeek <= 36) {
    return const _BabySizeInfo(
      name: 'Melao',
      article: 'um',
      icon: Icons.local_florist,
      kind: _FruitKind.papaya,
      primaryColor: Color(0xFFFFB36B),
      secondaryColor: Color(0xFFE36D4E),
      leafColor: Color(0xFF5E9E4F),
    );
  }
  return const _BabySizeInfo(
    name: 'Melancia pequena',
    icon: Icons.brightness_1,
    kind: _FruitKind.watermelon,
    primaryColor: Color(0xFF6FCF97),
    secondaryColor: Color(0xFF2F9E63),
    leafColor: Color(0xFF4E8A4B),
  );
}

enum _FruitKind {
  berry,
  citrus,
  avocado,
  banana,
  mango,
  eggplant,
  coconut,
  papaya,
  watermelon,
}

class _FruitIllustration extends StatelessWidget {
  const _FruitIllustration({required this.info});

  final _BabySizeInfo info;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 94,
        height: 94,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.35),
        ),
        alignment: Alignment.center,
        child: Text(
          _fallbackEmoji(info.kind),
          style: const TextStyle(fontSize: 58),
        ),
      ),
    );
  }

  String _fallbackEmoji(_FruitKind kind) {
    switch (kind) {
      case _FruitKind.berry:
        return '🍓';
      case _FruitKind.citrus:
        return '🍋';
      case _FruitKind.avocado:
        return '🥑';
      case _FruitKind.banana:
        return '🍌';
      case _FruitKind.mango:
        return '🥭';
      case _FruitKind.eggplant:
        return '🍆';
      case _FruitKind.coconut:
        return '🥥';
      case _FruitKind.papaya:
        return '🍈';
      case _FruitKind.watermelon:
        return '🍉';
    }
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        backgroundColor: GestCareColors.deepTeal,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, textAlign: TextAlign.center),
          if (icon != null) ...[const SizedBox(width: 8), Icon(icon, size: 18)],
        ],
      ),
    );
  }
}

class _PregnancyWelcomeIllustration extends StatelessWidget {
  const _PregnancyWelcomeIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        color: GestCareColors.cream,
        boxShadow: const [
          BoxShadow(
            color: Color(0x220C7A71),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          'src/images/Gemini_Generated_Image_ca70o3ca70o3ca70.png',
          fit: BoxFit.cover,
          semanticLabel: 'Ilustracao de gestante na tela inicial',
        ),
      ),
    );
  }
}
