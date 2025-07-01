import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/staff.dart';
import '../services/firestore_service.dart';
import '../constants/departments.dart';
import 'staff_list_page.dart';

class StaffCreationPage extends StatefulWidget {
  final Staff? staff; // For editing existing staff

  const StaffCreationPage({super.key, this.staff});

  @override
  State<StaffCreationPage> createState() => _StaffCreationPageState();
}

class _StaffCreationPageState extends State<StaffCreationPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _staffIdController = TextEditingController();
  final _ageController = TextEditingController();
  final _firestoreService = FirestoreService();

  String? _selectedDepartment;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // If editing existing staff, populate the fields
    if (widget.staff != null) {
      _nameController.text = widget.staff!.name;
      _staffIdController.text = widget.staff!.staffId;
      _ageController.text = widget.staff!.age.toString();
      _selectedDepartment = widget.staff!.department;
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _staffIdController.dispose();
    _ageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateStaffId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Staff ID is required';
    }
    if (value.trim().length < 3) {
      return 'Staff ID must be at least 3 characters long';
    }
    if (value.trim().length > 20) {
      return 'Staff ID must be less than 20 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value.trim())) {
      return 'Staff ID can only contain letters and numbers';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Please enter a valid number';
    }
    if (age < 18) {
      return 'Age must be at least 18';
    }
    if (age > 100) {
      return 'Age must be less than 100';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a department'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final staffId = _staffIdController.text.trim();
      final age = int.parse(_ageController.text.trim());

      // Check if staff ID already exists (unless we're editing the same staff)
      final staffIdExists = await _firestoreService.isStaffIdExists(
        staffId,
        excludeDocId: widget.staff?.id,
      );

      if (staffIdExists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Staff ID already exists. Please choose a different ID.',
              ),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      if (widget.staff != null) {
        // Update existing staff
        final updatedStaff = widget.staff!.copyWith(
          name: name,
          staffId: staffId,
          age: age,
          department: _selectedDepartment!,
        );
        await _firestoreService.updateStaff(updatedStaff);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Staff updated successfully!'),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        // Add new staff
        final staff = Staff(
          name: name,
          staffId: staffId,
          age: age,
          department: _selectedDepartment!,
        );
        await _firestoreService.addStaff(staff);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Staff added successfully!'),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate to Staff List Page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const StaffListPage()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _staffIdController.clear();
    _ageController.clear();
    setState(() {
      _selectedDepartment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.staff != null ? 'Edit Staff' : 'Add New Staff',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6A4C93),
        foregroundColor: Colors.white,
        elevation: 0,
        actions:
            widget.staff == null
                ? [
                  IconButton(
                    onPressed: _clearForm,
                    icon: const Icon(Icons.clear_all),
                    tooltip: 'Clear Form',
                  ),
                ]
                : null,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6A4C93),
                          const Color(0xFF8E7CC3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          widget.staff != null ? Icons.edit : Icons.person_add,
                          size: 50,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.staff != null
                              ? 'Update Staff Information'
                              : 'Enter Staff Details',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Form Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              hintText: 'Enter staff full name',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF6A4C93),
                                ),
                              ),
                            ),
                            validator: _validateName,
                            textCapitalization: TextCapitalization.words,
                          ),

                          const SizedBox(height: 20),

                          // Staff ID Field
                          TextFormField(
                            controller: _staffIdController,
                            decoration: InputDecoration(
                              labelText: 'Staff ID',
                              hintText: 'Enter unique staff ID',
                              prefixIcon: const Icon(Icons.badge),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF6A4C93),
                                ),
                              ),
                            ),
                            validator: _validateStaffId,
                            textCapitalization: TextCapitalization.characters,
                          ),

                          const SizedBox(height: 20),

                          // Age Field
                          TextFormField(
                            controller: _ageController,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              hintText: 'Enter age (18-100)',
                              prefixIcon: const Icon(Icons.cake),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF6A4C93),
                                ),
                              ),
                            ),
                            validator: _validateAge,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Department Dropdown
                          InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Department',
                              hintText: 'Select a department',
                              prefixIcon: const Icon(Icons.business),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF6A4C93),
                                ),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedDepartment,
                                isExpanded: true,
                                hint: const Text('Select a department'),
                                items:
                                    UniversityDepartments.departments.map((
                                      department,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: department,
                                        child: Row(
                                          children: [
                                            Text(
                                              UniversityDepartments.getIcon(
                                                department,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text(department)),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDepartment = value;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Submit Button
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A4C93),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      widget.staff != null
                                          ? 'Update Staff'
                                          : 'Add Staff',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
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
