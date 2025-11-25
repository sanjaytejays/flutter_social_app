import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Ensure you add this to pubspec.yaml for date formatting
import 'package:medcon/app/profile/domain/models/user_profile_model.dart';
import 'package:medcon/app/profile/presentation/cubit/profile_cubit.dart';
import 'package:medcon/app/profile/presentation/cubit/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfileModel user;
  const EditProfileScreen({required this.user, super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController aboutMeController;
  late TextEditingController nameController;
  late TextEditingController headLineController;
  late TextEditingController dateOfBirthController;
  late TextEditingController locationController;
  late TextEditingController skillsController;
  late TextEditingController accountTypeController;
  late TextEditingController profilePicController;

  // State Data
  String _selectedAccountType = '';
  final List<String> _accountTypes = ['Doctor', 'Student', 'Intern', 'Nurse'];
  List<String> _skills = [];
  List<EducationEntry> _educationList = [];
  List<ExperienceEntry> _experienceList = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    aboutMeController = TextEditingController(text: widget.user.aboutMe);
    nameController = TextEditingController(text: widget.user.name);
    headLineController = TextEditingController(text: widget.user.headLine);
    dateOfBirthController = TextEditingController(
      text: widget.user.dateOfBirth,
    );
    locationController = TextEditingController(text: widget.user.location);
    skillsController = TextEditingController();
    profilePicController = TextEditingController(
      text: widget.user.profilePicUrl,
    );

    // Lists
    _skills = List.from(widget.user.skills);
    _educationList = List.from(widget.user.education);
    _experienceList = List.from(widget.user.experience);

    // Dropdown logic
    _selectedAccountType =
        widget.user.accountType.isNotEmpty &&
            _accountTypes.contains(widget.user.accountType)
        ? widget.user.accountType
        : _accountTypes.first;
  }

  @override
  void dispose() {
    aboutMeController.dispose();
    nameController.dispose();
    headLineController.dispose();
    dateOfBirthController.dispose();
    locationController.dispose();
    skillsController.dispose();
    profilePicController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 365 * 20),
      ), // approx 20 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // Formatting date: YYYY-MM-DD or similar
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void updateProfile() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedAccountType == 'Student') {
      _experienceList = [];
    }

    context.read<ProfileCubit>().updateProfileCubit(
      uid: widget.user.uid,
      name: nameController.text.trim(),
      location: locationController.text.trim(),
      headLine: headLineController.text.trim(),
      dateOfBirth: dateOfBirthController.text.trim(),
      accountType: _selectedAccountType,
      profilePicUrl: profilePicController.text.trim(),
      aboutMe: aboutMeController.text.trim(),
      skills: _skills,
      education: _educationList,
      experience: _experienceList,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.greenAccent,
            ),
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoading;

        return Scaffold(
          backgroundColor: colorScheme.surface, // Light background
          appBar: AppBar(
            title: const Text(
              'Edit Profile',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: TextButton(
                  onPressed: isLoading ? null : updateProfile,
                  style: TextButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.primary,
                          ),
                        )
                      : Text(
                          'Save',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
              children: [
                _buildProfileImageSection(theme),
                const SizedBox(height: 30),

                _buildSectionHeader("Personal Information"),
                const SizedBox(height: 16),
                _CustomTextField(
                  controller: nameController,
                  label: "Full Name",
                  icon: Icons.person_outline_rounded,
                  validator: (v) => v!.isEmpty ? "Name is required" : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _CustomTextField(
                        controller: dateOfBirthController,
                        label: "Birth Date",
                        icon: Icons.calendar_today_rounded,
                        readOnly: true,
                        onTap: () =>
                            _selectDate(context, dateOfBirthController),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedAccountType,
                        decoration: _inputDecoration(
                          context,
                          "Role",
                          Icons.badge_outlined,
                        ),
                        items: _accountTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedAccountType = val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  controller: locationController,
                  label: "Location",
                  icon: Icons.location_on_outlined,
                ),

                const SizedBox(height: 30),
                _buildSectionHeader("Professional Bio"),
                const SizedBox(height: 16),
                _CustomTextField(
                  controller: headLineController,
                  label: "Headline",
                  hint: "e.g. Cardio Surgeon at Apollo",
                  icon: Icons.medical_services_outlined,
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  controller: aboutMeController,
                  label: "About Me",
                  icon: Icons.description_outlined,
                  maxLines: 4,
                  alignLabelWithHint: true,
                ),

                _selectedAccountType == "Doctor" ||
                        _selectedAccountType == "Nurse" ||
                        _selectedAccountType == "Intern"
                    ? Column(
                        children: [
                          const SizedBox(height: 30),
                          _buildListHeader(
                            "Experience",
                            onAdd: _showAddExperienceSheet,
                          ),
                          _buildExperienceList(theme),
                        ],
                      )
                    : const SizedBox.shrink(),

                const SizedBox(height: 30),
                _buildListHeader("Education", onAdd: _showAddEducationSheet),
                _buildEducationList(theme),

                const SizedBox(height: 30),
                _buildSectionHeader("Skills"),
                const SizedBox(height: 12),
                _buildSkillsSection(theme),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Widgets & Builders ---

  Widget _buildProfileImageSection(ThemeData theme) {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
              backgroundImage: NetworkImage(
                widget.user.profilePicUrl.isNotEmpty
                    ? widget.user.profilePicUrl
                    : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.user.name)}&background=random',
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Material(
              elevation: 2,
              shape: const CircleBorder(),
              color: theme.colorScheme.primary,
              child: InkWell(
                onTap: () {
                  // TODO: Implement Image Picker
                },
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildListHeader(String title, {required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionHeader(title),
        InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  "Add",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skills
              .map(
                (skill) => Chip(
                  label: Text(skill),
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  deleteIcon: Icon(
                    Icons.close,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onDeleted: () => setState(() => _skills.remove(skill)),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )
              .toList(),
        ),
        if (_skills.isNotEmpty) const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _CustomTextField(
                controller: skillsController,
                label: "Add a skill",
                hint: "e.g. Surgery, Java, Pediatrics",
                icon: Icons.star_border_rounded,
                onSubmitted: (_) => _addSkill(),
              ),
            ),
            const SizedBox(width: 12),
            IconButton.filled(
              onPressed: _addSkill,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _addSkill() {
    final text = skillsController.text.trim();
    if (text.isNotEmpty && !_skills.contains(text)) {
      setState(() {
        _skills.add(text);
        skillsController.clear();
      });
    }
  }

  // --- List Builders ---

  Widget _buildExperienceList(ThemeData theme) {
    if (_experienceList.isEmpty)
      return _buildEmptyState("No experience listed");

    return Column(
      children: _experienceList.asMap().entries.map((entry) {
        final index = entry.key;
        final exp = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.work_outline, color: theme.colorScheme.primary),
            ),
            title: Text(
              exp.role,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  exp.organizationName,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                Text(
                  "${exp.startDate} - ${exp.endDate}",
                  style: TextStyle(color: theme.colorScheme.outline),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => setState(() => _experienceList.removeAt(index)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEducationList(ThemeData theme) {
    if (_educationList.isEmpty) return _buildEmptyState("No education listed");

    return Column(
      children: _educationList.asMap().entries.map((entry) {
        final index = entry.key;
        final edu = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.school_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              edu.degree,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  edu.institutionName,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                Text(
                  "${edu.yearStart} - ${edu.yearEnd}",
                  style: TextStyle(color: theme.colorScheme.outline),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => setState(() => _educationList.removeAt(index)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  // --- Bottom Sheets (Better than Dialogs) ---

  void _showAddExperienceSheet() {
    final roleCtrl = TextEditingController();
    final orgCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();

    _showGenericBottomSheet(
      title: "Add Experience",
      onSave: () {
        if (roleCtrl.text.isNotEmpty && orgCtrl.text.isNotEmpty) {
          setState(() {
            _experienceList.add(
              ExperienceEntry(
                role: roleCtrl.text,
                organizationName: orgCtrl.text,
                startDate: startCtrl.text,
                endDate: endCtrl.text,
              ),
            );
          });
          Navigator.pop(context);
        }
      },
      children: [
        _CustomTextField(
          controller: roleCtrl,
          label: "Job Role",
          hint: "e.g. Senior Surgeon",
          icon: Icons.work_outline,
        ),
        const SizedBox(height: 12),
        _CustomTextField(
          controller: orgCtrl,
          label: "Organization",
          hint: "e.g. City Hospital",
          icon: Icons.business,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _CustomTextField(
                controller: startCtrl,
                label: "Start Year",
                hint: "2018",
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CustomTextField(
                controller: endCtrl,
                label: "End Year",
                hint: "Present",
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddEducationSheet() {
    final degreeCtrl = TextEditingController();
    final instCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();

    _showGenericBottomSheet(
      title: "Add Education",
      onSave: () {
        if (degreeCtrl.text.isNotEmpty && instCtrl.text.isNotEmpty) {
          setState(() {
            _educationList.add(
              EducationEntry(
                degree: degreeCtrl.text,
                institutionName: instCtrl.text,
                yearStart: startCtrl.text,
                yearEnd: endCtrl.text,
              ),
            );
          });
          Navigator.pop(context);
        }
      },
      children: [
        _CustomTextField(
          controller: degreeCtrl,
          label: "Degree",
          hint: "e.g. MBBS",
          icon: Icons.school_outlined,
        ),
        const SizedBox(height: 12),
        _CustomTextField(
          controller: instCtrl,
          label: "Institution",
          hint: "e.g. Harvard Medical",
          icon: Icons.account_balance,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _CustomTextField(
                controller: startCtrl,
                label: "Start Year",
                hint: "2015",
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CustomTextField(
                controller: endCtrl,
                label: "End Year",
                hint: "2019",
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showGenericBottomSheet({
    required String title,
    required VoidCallback onSave,
    required List<Widget> children,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            ...children,
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onSave,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Save Changes"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helpers ---

  InputDecoration _inputDecoration(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        size: 22,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

// --- Reusable Widget to Clean up Code ---

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final int maxLines;
  final bool readOnly;
  final bool alignLabelWithHint;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.maxLines = 1,
    this.readOnly = false,
    this.alignLabelWithHint = false,
    this.keyboardType,
    this.onTap,
    this.onSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onTap: onTap,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: alignLabelWithHint,
        labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        prefixIcon: Icon(
          icon,
          size: 22,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
