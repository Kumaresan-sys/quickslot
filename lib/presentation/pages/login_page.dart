import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme.dart';
import '../blocs/auth/auth_cubit.dart';
import '../utils/app_feedback.dart';
import '../utils/form_validators.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import 'venue_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'test@example.com');
  final _passwordController = TextEditingController(text: 'password123');

  static const _demoUsers = [
    ('John Doe', 'test@example.com'),
    ('Jane Smith', 'jane@example.com'),
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<AuthCubit>().login(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  void _loginAsDemoUser(String email) {
    _emailController.text = email;
    _passwordController.text = 'password123';
    _handleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const VenueListPage()),
            );
          } else if (state is AuthError) {
            AppFeedback.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _LoginHeader(),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          'Demo access',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: _demoUsers.map((user) {
                            return _DemoUserChip(
                              name: user.$1,
                              email: user.$2,
                              enabled: !isLoading,
                              onTap: () => _loginAsDemoUser(user.$2),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppTextField(
                          controller: _emailController,
                          label: 'Email',
                          hintText: 'you@example.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: FormValidators.email,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: FormValidators.password,
                          onFieldSubmitted: (_) {
                            if (!isLoading) _handleLogin();
                          },
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppButton(
                          label: 'Log in',
                          icon: Icons.arrow_forward_rounded,
                          isLoading: isLoading,
                          onPressed: isLoading ? null : _handleLogin,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Icon(
            Icons.sports_tennis_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 34,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('QuickSlot', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Book courts and venues with real-time slot availability.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: context.appColors.mutedText,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _DemoUserChip extends StatelessWidget {
  final String name;
  final String email;
  final bool enabled;
  final VoidCallback onTap;

  const _DemoUserChip({
    required this.name,
    required this.email,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.person_outline_rounded, size: 18),
      label: Text(name),
      tooltip: email,
      onPressed: enabled ? onTap : null,
      side: BorderSide(color: context.appColors.border),
      backgroundColor: Theme.of(context).colorScheme.surface,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
    );
  }
}
