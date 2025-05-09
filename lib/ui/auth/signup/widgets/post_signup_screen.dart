import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/auth/signup/view_models/signup_viewmodel.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/ui/shared/widgets/app_link.dart';
import 'package:loop/ui/shared/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';

class PostSignupScreen extends StatelessWidget {
  final String email;

  const PostSignupScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<SignUpViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.successMessage != null) {
        AppSnackBar.show(
          context,
          title: viewModel.successMessage!,
          type: SnackBarType.success,
        );
        viewModel.clearSuccess();
      }

      if (viewModel.errorMessage != null) {
        AppSnackBar.show(
          context,
          title: 'Failed to resend email',
          body: viewModel.errorMessage,
          type: SnackBarType.error,
        );
        viewModel.clearError();
      }
    });

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              maxWidth: AppDimensions.formWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/mailbox.svg',
                width: AppDimensions.iconSizeXXL,
                height: AppDimensions.iconSizeXXL,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: AppDimensions.gapLg),
              Text(
                'Almost there',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge,
              ),
              const SizedBox(height: AppDimensions.gapLg),
              Text(
                "A verification email has been sent to",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDimensions.gapXs),
              Text(
                email,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.gapLg),
              Text(
                "Didn't receive it?",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDimensions.gapXs),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Check your spam folder or ",
                      style: theme.textTheme.bodyMedium),
                  AppLink(
                    text: viewModel.isSendingEmail
                        ? "Sending..."
                        : "Click here",
                    color: viewModel.isSendingEmail
                        ? theme.colorScheme.secondary
                        : null,
                    onTap: () {
                      if (!viewModel.isSendingEmail) {
                        viewModel
                            .resendVerificationEmail(email);
                      }
                    },
                    isLoading: viewModel.isSendingEmail,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.gapXl),
              AppButton(
                label: "Go to Login",
                width: AppDimensions.buttonWidth,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
