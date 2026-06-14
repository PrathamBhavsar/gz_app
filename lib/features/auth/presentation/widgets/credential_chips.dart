import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class CredentialInfo {
  final String email;
  final String password;
  final String label;

  const CredentialInfo({
    required this.email,
    required this.password,
    required this.label,
  });
}

class DeveloperCredentials {
  static const List<CredentialInfo> admins = [
    CredentialInfo(email: 'admin@urban-gamer.com', password: 'password123', label: 'Urban Gamer'),
    CredentialInfo(email: 'admin@elite-esports.com', password: 'password123', label: 'Elite Esports'),
    CredentialInfo(email: 'admin@console-corner.com', password: 'password123', label: 'Console Corner'),
    CredentialInfo(email: 'admin@retro-pc.com', password: 'password123', label: 'Retro PC'),
  ];

  static const List<CredentialInfo> staff = [
    CredentialInfo(email: 'staff@urban-gamer.com', password: 'password123', label: 'Urban Staff'),
    CredentialInfo(email: 'staff@elite-esports.com', password: 'password123', label: 'Elite Staff'),
    CredentialInfo(email: 'staff@console-corner.com', password: 'password123', label: 'Console Staff'),
    CredentialInfo(email: 'staff@retro-pc.com', password: 'password123', label: 'Retro Staff'),
  ];

  static const List<CredentialInfo> players = [
    CredentialInfo(email: 'teresa43@hotmail.com', password: 'password123', label: 'Teresa'),
    CredentialInfo(email: 'iris8@hotmail.com', password: 'password123', label: 'Iris'),
    CredentialInfo(email: 'joan_ankunding80@yahoo.com', password: 'password123', label: 'Joan'),
    CredentialInfo(email: 'gerardo.weissnat@yahoo.com', password: 'password123', label: 'Gerardo'),
    CredentialInfo(email: 'zakary66@yahoo.com', password: 'password123', label: 'Zakary'),
    CredentialInfo(email: 'ian.watsica@yahoo.com', password: 'password123', label: 'Ian'),
    CredentialInfo(email: 'verna.turner90@yahoo.com', password: 'password123', label: 'Verna'),
    CredentialInfo(email: 'anna85@hotmail.com', password: 'password123', label: 'Anna'),
    CredentialInfo(email: 'tamara_schmeler@gmail.com', password: 'password123', label: 'Tamara'),
    CredentialInfo(email: 'henry_flatley60@hotmail.com', password: 'password123', label: 'Henry'),
    CredentialInfo(email: 'erika.legros99@hotmail.com', password: 'password123', label: 'Erika'),
    CredentialInfo(email: 'vilma.dibbert@gmail.com', password: 'password123', label: 'Vilma'),
    CredentialInfo(email: 'dwayne_vandervort23@yahoo.com', password: 'password123', label: 'Dwayne'),
    CredentialInfo(email: 'miracle_schulist21@gmail.com', password: 'password123', label: 'Miracle'),
    CredentialInfo(email: 'marjorie.hand@gmail.com', password: 'password123', label: 'Marjorie'),
    CredentialInfo(email: 'raymond_lowe@gmail.com', password: 'password123', label: 'Raymond'),
    CredentialInfo(email: 'tara.dibbert@hotmail.com', password: 'password123', label: 'Tara'),
    CredentialInfo(email: 'gladys23@hotmail.com', password: 'password123', label: 'Gladys'),
    CredentialInfo(email: 'jeremiah_beahan56@yahoo.com', password: 'password123', label: 'Jeremiah'),
  ];
}

class CredentialChips extends StatelessWidget {
  final String title;
  final List<CredentialInfo> credentials;
  final bool horizontal;
  final void Function(String email, String password) onTap;

  const CredentialChips({
    super.key,
    required this.title,
    required this.credentials,
    this.horizontal = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleWidget = title.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              title,
              style: AppTypography.meta.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          )
        : const SizedBox.shrink();

    if (horizontal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          titleWidget,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: credentials.map((cred) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildChip(cred),
                );
              }).toList(),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          titleWidget,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: credentials.map((cred) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: _buildChip(cred),
              );
            }).toList(),
          ),
        ],
      );
    }
  }

  Widget _buildChip(CredentialInfo cred) {
    return Material(
      color: AppColors.surfaceTint,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => onTap(cred.email, cred.password),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Text(
            cred.label,
            textAlign: TextAlign.center,
            style: AppTypography.small.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
