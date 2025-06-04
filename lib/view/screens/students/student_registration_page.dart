import 'package:flutter/material.dart';
import 'package:markme/view/common/colors.dart';
import 'package:markme/view/common/snackbar.dart';

class StudentRegisterationPage extends StatefulWidget {
  const StudentRegisterationPage({super.key});

  @override
  State<StudentRegisterationPage> createState() =>
      _StudentRegisterationPageState();
}

class _StudentRegisterationPageState extends State<StudentRegisterationPage> {
  // For Displaying
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // For Page Changes
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _ktuIdController = TextEditingController();

  // Other Indicators
  bool _isLoading = false;

  // Password strength
  int _passwordStrength = 0;

  // Dropdown values
  String? _selectedCollege;
  String? _selectedDepartment;
  String? _selectedCourse;
  String? _selectedClass;
  int? _currentSemester;
  int? _admissionYear;
  int? _endYear;

  // TODO: Replace mock data with database data
  final List<String> _colleges = ['MDL', 'FISAT', 'SCMS', 'RIT'];
  final List<String> _departments = [
    'Computer Science',
    'Electronics',
    'Mechanical',
  ];
  final List<String> _courses = ['B.Tech CSE', 'B.Tech ECE', 'B.Tech ME'];
  final List<String> _classes = ['A', 'B', 'C'];

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordStrength);
  }

  void _checkPasswordStrength() {
    setState(() {
      _passwordStrength = _calculatePasswordScore(_passwordController.text);
    });
  }

  String _getPageTitle() {
    switch (_currentPage) {
      case 0:
        return 'Personal Information';
      case 1:
        return 'Academic Information';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ktuIdController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  int _calculatePasswordScore(String password) {
    if (password.isEmpty) return 0;

    int score = 0;

    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    return score;
  }

  String _getStrengthText(int score) {
    switch (score) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Strong';
      default:
        return 'None';
    }
  }

  Color _getStrengthColor(int score) {
    switch (score) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  bool _validatePersonalInfo() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar.showErrorSnackBar(
          snackBarTitle: 'Incomplete Fields!',
          snackBarMessage: 'Please fill all required fields',
          duration: const Duration(seconds: 5),
        ),
      );
      return false;
    }

    if (!emailRegex.hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar.showErrorSnackBar(
          snackBarTitle: 'Invalid Email!',
          snackBarMessage: 'Please enter a valid email address',
          duration: const Duration(seconds: 5),
        ),
      );
      return false;
    }

    if (!_isPasswordValid(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar.showErrorSnackBar(
          snackBarTitle: 'Weak Password!',
          snackBarMessage: 'Password must meet all security requirements',
          duration: const Duration(seconds: 5),
        ),
      );
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar.showErrorSnackBar(
          snackBarTitle: 'Password Mismatch!',
          snackBarMessage: 'Passwords do not match',
          duration: const Duration(seconds: 5),
        ),
      );
      return false;
    }

    return true;
  }

  bool _validateAcademicInfo() {
    if (_ktuIdController.text.isEmpty ||
        _selectedCollege == null ||
        _selectedDepartment == null ||
        _selectedCourse == null ||
        _selectedClass == null ||
        _currentSemester == null ||
        _admissionYear == null ||
        _endYear == null) {
          CustomSnackbar.showErrorSnackBar(
            snackBarMessage: 'Please fill all academic information',
            snackBarTitle: 'Incomplete Fields'
          );
      return false;
    }
    return true;
  }

  bool _validateCurrentPage() {
    if (_currentPage == 0) {
      return _validatePersonalInfo();
    } else if (_currentPage == 1) {
      return _validateAcademicInfo();
    } else {
      return false;
    }
  }

  void _submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackbar.showSuccessSnackBar(
        snackBarTitle: 'Success!',
        snackBarMessage: 'User Registered Successfully! Please Login Now',
      ),
    );
    
    // TODO: Navigate to login page
  }

  void _nextPage() {
    if (_currentPage < 1) {
      if (_validateCurrentPage()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _submitForm();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios),
                  color: AppColors.textPrimary,
                ),
                const Expanded(
                  child: Text(
                    'Student Registration',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              _getPageTitle(),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 18),

            // Progress Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  for (int i = 0; i < 2; i++) ...[
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? AppColors.primary
                              : AppColors.neutral200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (i < 1) const SizedBox(width: 8),
                  ],
                ],
              ),
            ),

            // Form Fields
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildPersonalInfoPage(),
                    _buildAcademicInfoPage(),
                  ],
                ),
              ),
            ),

            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _previousPage,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: AppColors.primary),
                        ),
                        child: const Text(
                          'Previous',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              _currentPage == 1 ? 'Register' : 'Next',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simple strength bar
  Widget _buildSimpleStrengthBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Password Strength: ',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            Text(
              _getStrengthText(_passwordStrength),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _getStrengthColor(_passwordStrength),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: _passwordStrength / 5.0, // Convert to 0-1 range
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getStrengthColor(_passwordStrength),
          ),
          minHeight: 4,
        ),
      ],
    );
  }

  // Password equirements list
  Widget _buildSimpleRequirements() {
    String password = _passwordController.text;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password Requirements:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Length requirement
          _buildRequirementRow('At least 8 characters', password.length >= 8),

          // Uppercase requirement
          _buildRequirementRow(
            'One uppercase letter (A-Z)',
            password.contains(RegExp(r'[A-Z]')),
          ),

          // Lowercase requirement
          _buildRequirementRow(
            'One lowercase letter (a-z)',
            password.contains(RegExp(r'[a-z]')),
          ),

          // Number requirement
          _buildRequirementRow(
            'One number (0-9)',
            password.contains(RegExp(r'[0-9]')),
          ),

          // Special character requirement
          _buildRequirementRow(
            'One special character (!@#\$%^&*)',
            password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isMet ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: isMet ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            const Text(" *", style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            hintText: 'Enter $label',
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.inputFocused,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            const Text(" *", style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          onChanged: (value) {
            if (controller == _passwordController) {
              setState(() {
                _passwordStrength = _calculatePasswordScore(value);
              });
            }
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
            ),
            hintText: 'Enter $label',
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.inputFocused,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String label,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const Text(' *', style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            hintText: 'Select $label',
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.inputFocused,
                width: 2,
              ),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required int? value,
    required String label,
    required IconData icon,
    required int min,
    required int max,
    required ValueChanged<int?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const Text(' *', style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            hintText: 'Select $label',
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.inputFocused,
                width: 2,
              ),
            ),
          ),
          items: List.generate(max - min + 1, (index) => min + index)
              .map(
                (number) => DropdownMenuItem<int>(
                  value: number,
                  child: Text(number.toString()),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // Pages Descriptions
  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _passwordController,
            label: 'Password',
            obscureText: _obscurePassword,
            onToggle: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),

          // Password Strength Indicator
          if (_passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSimpleStrengthBar(),
            const SizedBox(height: 8),
            _buildSimpleRequirements(),
          ],

          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            obscureText: _obscureConfirmPassword,
            onToggle: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _ktuIdController,
            label: 'KTU ID',
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            value: _selectedCollege,
            items: _colleges,
            label: 'College',
            icon: Icons.school_outlined,
            onChanged: (value) => setState(() => _selectedCollege = value),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            value: _selectedDepartment,
            items: _departments,
            label: 'Department',
            icon: Icons.domain_outlined,
            onChanged: (value) => setState(() => _selectedDepartment = value),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            value: _selectedCourse,
            items: _courses,
            label: 'Course',
            icon: Icons.menu_book_outlined,
            onChanged: (value) => setState(() => _selectedCourse = value),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            value: _selectedClass,
            items: _classes,
            label: 'Section',
            icon: Icons.class_outlined,
            onChanged: (value) => setState(() => _selectedClass = value),
          ),
          const SizedBox(height: 16),
          _buildNumberField(
            value: _currentSemester,
            label: 'Current Semester',
            icon: Icons.timeline_outlined,
            onChanged: (value) => setState(() => _currentSemester = value),
            min: 1,
            max: 8,
          ),
          const SizedBox(height: 16),
          _buildNumberField(
            value: _admissionYear,
            label: 'Admission Year',
            icon: Icons.calendar_today_outlined,
            onChanged: (value) => setState(() => _admissionYear = value),
            min: 2015,
            max: DateTime.now().year,
          ),
          const SizedBox(height: 16),
          _buildNumberField(
            value: _endYear,
            label: 'Expected Passout Year',
            icon: Icons.group_outlined,
            onChanged: (value) => setState(() => _endYear = value),
            min: 2015,
            max: DateTime.now().year + 5,
          ),
        ],
      ),
    );
  }
}
