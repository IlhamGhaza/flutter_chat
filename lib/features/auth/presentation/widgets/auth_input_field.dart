import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/theme_cubit.dart';
import '../../../../core/theme.dart';

class AuthInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? toggleObscureText;
  final String? Function(String?)? validator;

  const AuthInputField({
    Key? key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.toggleObscureText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;
        final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && obscureText,
            decoration: InputDecoration(
              labelText: label,
              labelStyle:
                  theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
              prefixIcon: Icon(icon, color: theme.iconTheme.color),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: theme.iconTheme.color,
                      ),
                      onPressed: toggleObscureText,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: theme.colorScheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:
                    BorderSide(color: theme.colorScheme.error, width: 2),
              ),
              filled: true,
              fillColor: isDarkMode
                  ? DefaultColors.darkInputBackground
                  : DefaultColors.lightInputBackground,
            ),
            validator: validator,
            style: theme.textTheme.bodyLarge,
            cursorColor: theme.primaryColor,
          ),
        );
      },
    );
  }
}
