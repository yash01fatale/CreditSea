import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/loan_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/creditsea_ui.dart';
import '../../widgets/theme_toggle_button.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController c = Get.find<ProfileController>();
  final LoanController loans = Get.find<LoanController>();
  final AuthController auth = Get.find<AuthController>();
  final RxBool editing = false.obs;

  Future<void> _pickDob(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: c.selectedDob.value ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year - 18, now.month, now.day),
    );
    if (date != null) c.selectedDob.value = date;
  }

  Future<void> _save() async {
    final ok = await c.updateProfile({
      'name': c.nameController.text.trim(),
      'email': c.emailController.text.trim(),
      'pan': c.panController.text.trim().toUpperCase(),
      'address': c.addressController.text.trim(),
      if (c.selectedGender.value != null) 'gender': c.selectedGender.value,
      if (c.selectedDob.value != null)
        'dob': c.selectedDob.value!.toIso8601String(),
    });
    if (ok) editing.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.background,
      appBar: AppBar(
        title: const Text('My profile'),
        backgroundColor: CreditSeaColors.background,
        actions: [
          const CreditSeaThemeButton(),
          Obx(
            () => TextButton(
              onPressed: () => editing.toggle(),
              child: Text(
                editing.value ? 'Cancel' : 'Edit',
                style: TextStyle(
                  color: CreditSeaColors.blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: c.fetchProfile,
          color: CreditSeaColors.blue,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              CreditSeaCard(
                color: CreditSeaColors.navyCard,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Text(
                        _initial(c.user.value.name),
                        style: TextStyle(
                          color: CreditSeaColors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      c.user.value.name ?? 'CreditSea member',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c.user.value.phone == null
                          ? 'Mobile number not available'
                          : '+91 ${c.user.value.phone}',
                      style: const TextStyle(
                        color: Color(0xFFC6D5E4),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: CreditSeaColors.mint.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_user_rounded,
                              color: CreditSeaColors.mint, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            c.user.value.profileCompleted
                                ? 'Profile completed'
                                : 'Profile incomplete',
                            style: TextStyle(
                              color: CreditSeaColors.mint,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      'CreditSea score',
                      c.user.value.creditScore > 0
                          ? '${c.user.value.creditScore}'
                          : '—',
                      Icons.speed_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statCard(
                      'Applications',
                      '${loans.loans.length}',
                      Icons.description_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              if (editing.value) ...[
                const CreditSeaSectionTitle('Edit personal information'),
                const SizedBox(height: 12),
                _editForm(context),
              ] else ...[
                const CreditSeaSectionTitle('Personal & KYC information'),
                const SizedBox(height: 10),
                CreditSeaCard(
                  child: Column(
                    children: [
                      _profileRow(
                        Icons.person_outline_rounded,
                        'Full name',
                        c.user.value.name ?? 'Not added',
                      ),
                      _profileRow(
                        Icons.email_outlined,
                        'Email address',
                        c.user.value.email ?? 'Not added',
                      ),
                      _profileRow(
                        Icons.credit_card_outlined,
                        'PAN number',
                        c.user.value.pan ?? 'Not added',
                      ),
                      _profileRow(
                        Icons.calendar_month_outlined,
                        'Date of birth',
                        c.user.value.dob == null
                            ? 'Not added'
                            : '${c.user.value.dob!.day.toString().padLeft(2, '0')}/${c.user.value.dob!.month.toString().padLeft(2, '0')}/${c.user.value.dob!.year}',
                      ),
                      _profileRow(
                        Icons.wc_outlined,
                        'Gender',
                        c.user.value.gender ?? 'Not added',
                      ),
                      _profileRow(
                        Icons.location_on_outlined,
                        'Address',
                        c.user.value.address ?? 'Not added',
                        last: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 21),
                const CreditSeaSectionTitle('Security & preferences'),
                const SizedBox(height: 10),
                CreditSeaCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _settingsRow(
                        Icons.lock_outline_rounded,
                        'Account security',
                        'JWT-based sign-in session',
                      ),
                      const Divider(height: 1, indent: 58),
                      _settingsRow(
                        Icons.privacy_tip_outlined,
                        'Privacy & data',
                        'Review how your information is used',
                      ),
                      const Divider(height: 1, indent: 58),
                      _settingsRow(
                        Icons.support_agent_rounded,
                        'Help & support',
                        'Support options for the demo app',
                        last: true,
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Log out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CreditSeaColors.danger,
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Color(0xFFF2CACA)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'CreditSea assignment demo • CreditSea score is illustrative and is not an official CIBIL or credit bureau score. Banking, biometric and repayment integrations are not enabled.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CreditSeaColors.muted,
                  fontSize: 9,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editForm(BuildContext context) {
    return CreditSeaCard(
      child: Column(
        children: [
          TextField(
            controller: c.nameController,
            textCapitalization: TextCapitalization.words,
            decoration: creditSeaInput(
              label: 'Full name',
              prefix: const Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: c.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: creditSeaInput(
              label: 'Email address',
              prefix: const Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: c.panController,
            textCapitalization: TextCapitalization.characters,
            maxLength: 10,
            decoration: creditSeaInput(
              label: 'PAN number',
              prefix: const Icon(Icons.credit_card_outlined),
            ).copyWith(counterText: ''),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: c.addressController,
            maxLines: 2,
            decoration: creditSeaInput(
              label: 'Residential address',
              prefix: const Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => DropdownButtonFormField<String>(
              initialValue: c.selectedGender.value,
              decoration: creditSeaInput(
                label: 'Gender',
                prefix: const Icon(Icons.wc_outlined),
              ),
              items: ['Male', 'Female', 'Other']
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (value) => c.selectedGender.value = value,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.calendar_month_outlined,
                  color: CreditSeaColors.blue),
              title: Text(
                'Date of birth',
                style: TextStyle(
                  color: CreditSeaColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                c.selectedDob.value == null
                    ? 'Select date'
                    : '${c.selectedDob.value!.day}/${c.selectedDob.value!.month}/${c.selectedDob.value!.year}',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _pickDob(context),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => CreditSeaPrimaryButton(
              label: 'Save changes',
              loading: c.isLoading.value,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return CreditSeaCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(icon, color: CreditSeaColors.blue, size: 22),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: CreditSeaColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: CreditSeaColors.muted,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileRow(
    IconData icon,
    String title,
    String value, {
    bool last = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: CreditSeaColors.blue, size: 19),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: CreditSeaColors.muted,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        color: CreditSeaColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!last) const Divider(height: 1),
      ],
    );
  }

  Widget _settingsRow(
    IconData icon,
    String title,
    String subtitle, {
    bool last = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: CreditSeaColors.blue),
      title: Text(
        title,
        style: TextStyle(
          color: CreditSeaColors.text,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: CreditSeaColors.muted,
          fontSize: 10,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: CreditSeaColors.muted),
      onTap: () {
        Get.snackbar(
          title,
          'This feature is not connected in the assignment demo.',
        );
      },
      dense: true,
    );
  }

  String _initial(String? name) {
    final value = name?.trim() ?? '';
    return value.isEmpty ? 'C' : value[0].toUpperCase();
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out of CreditSea?'),
        content: const Text(
          'You will need to verify your mobile number the next time you sign in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed == true) await auth.logout();
  }
}
