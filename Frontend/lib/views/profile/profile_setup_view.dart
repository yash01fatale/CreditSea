import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';
import '../../widgets/creditsea_ui.dart';

class ProfileSetupView extends StatelessWidget {
  ProfileSetupView({super.key});

  final ProfileController c = Get.find<ProfileController>();
  static const _genders = ['Male', 'Female', 'Other'];

  Future<void> _pickDob(BuildContext context) async {
    final now = DateTime.now();
    final initial = c.selectedDob.value ?? DateTime(2000, 1, 1);
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year - 18, now.month, now.day),
      helpText: 'Select date of birth',
    );
    if (date != null) c.selectedDob.value = date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CreditSeaColors.background,
      appBar: AppBar(
        title: const Text('KYC verification'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Form(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              Row(
                children: [
                  _step('01', 'Mobile', true),
                  _stepLine(true),
                  _step('02', 'Personal info', true),
                  _stepLine(false),
                  _step('03', 'Complete', false),
                ],
              ),
              const SizedBox(height: 25),
              CreditSeaCard(
                color: CreditSeaColors.navyCard,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: CreditSeaColors.mint,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your details stay protected',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Share accurate information to complete your profile. This demo does not connect to UIDAI or credit bureaus.',
                            style: TextStyle(
                              color: Color(0xFFD0DCE8),
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 7),
              Text(
                'Complete your personal details to continue with your loan application.',
                style: TextStyle(
                  color: CreditSeaColors.muted,
                  height: 1.5,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              const _FieldLabel('FULL NAME (AS PER PAN)'),
              const SizedBox(height: 8),
              TextField(
                controller: c.nameController,
                textCapitalization: TextCapitalization.words,
                decoration: creditSeaInput(
                  label: 'Full name',
                  hint: 'Enter your full name',
                  prefix: const Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 18),
              const _FieldLabel('DATE OF BIRTH'),
              const SizedBox(height: 8),
              Obx(
                () => InkWell(
                  onTap: () => _pickDob(context),
                  borderRadius: BorderRadius.circular(15),
                  child: InputDecorator(
                    decoration: creditSeaInput(
                      label: 'Date of birth',
                      prefix: const Icon(Icons.calendar_month_outlined),
                      suffix: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                    child: Text(
                      c.selectedDob.value == null
                          ? 'Select your date of birth'
                          : '${c.selectedDob.value!.day.toString().padLeft(2, '0')}/${c.selectedDob.value!.month.toString().padLeft(2, '0')}/${c.selectedDob.value!.year}',
                      style: TextStyle(
                        color: c.selectedDob.value == null
                            ? CreditSeaColors.muted
                            : CreditSeaColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const _FieldLabel('GENDER'),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: _genders.map((gender) {
                    final selected = c.selectedGender.value == gender;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => c.selectedGender.value = gender,
                          borderRadius: BorderRadius.circular(13),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                              color: selected
                                  ? CreditSeaColors.blueSoft
                                  : CreditSeaColors.surface,
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: selected
                                    ? CreditSeaColors.blue
                                    : CreditSeaColors.line,
                                width: selected ? 1.4 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                gender,
                                style: TextStyle(
                                  color: selected
                                      ? CreditSeaColors.blue
                                      : CreditSeaColors.muted,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
              const _FieldLabel('PERMANENT ACCOUNT NUMBER'),
              const SizedBox(height: 8),
              TextField(
                controller: c.panController,
                textCapitalization: TextCapitalization.characters,
                maxLength: 10,
                decoration: creditSeaInput(
                  label: 'PAN number',
                  hint: 'ABCDE1234F',
                  prefix: const Icon(Icons.credit_card_outlined),
                ).copyWith(counterText: ''),
              ),
              const SizedBox(height: 18),
              const _FieldLabel('EMAIL ADDRESS'),
              const SizedBox(height: 8),
              TextField(
                controller: c.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: creditSeaInput(
                  label: 'Email address',
                  hint: 'you@example.com',
                  prefix: const Icon(Icons.alternate_email_rounded),
                ),
              ),
              const SizedBox(height: 18),
              const _FieldLabel('CURRENT RESIDENTIAL ADDRESS'),
              const SizedBox(height: 8),
              TextField(
                controller: c.addressController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: creditSeaInput(
                  label: 'Address',
                  hint: 'Flat / House, street, city, state and PIN code',
                  prefix: const Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 22),
              Obx(
                () => CreditSeaPrimaryButton(
                  label: 'Save & continue',
                  icon: Icons.arrow_forward_rounded,
                  loading: c.isLoading.value,
                  onPressed: c.saveProfile,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your information is used for this assignment demo and is stored in your configured MongoDB database.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CreditSeaColors.muted,
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _step(String number, String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: active
              ? CreditSeaColors.blue
              : const Color(0xFFE5EAF1),
          child: Text(
            number,
            style: TextStyle(
              color: active ? Colors.white : CreditSeaColors.muted,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: active ? CreditSeaColors.text : CreditSeaColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _stepLine(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 17, left: 4, right: 4),
        color: active ? CreditSeaColors.blue : CreditSeaColors.line,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: CreditSeaColors.text,
        fontSize: 10,
        letterSpacing: .7,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
