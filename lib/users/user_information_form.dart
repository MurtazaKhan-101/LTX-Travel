import 'package:flutter/material.dart';
import 'booking_selection_screen.dart';
import 'checkout_screen.dart';

class UserInfoForm extends StatefulWidget {
  final Map<String, dynamic> packageData;
  final bool proceedToCheckoutDirectly;

  const UserInfoForm({
    super.key,
    required this.packageData,
    this.proceedToCheckoutDirectly = false,
  });

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  String? _payerStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Information",
        ),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Complete Your Information",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _fullNameController,
                          labelText: "Full Name",
                          icon: Icons.person,
                          validator: (value) => value == null || value.isEmpty
                              ? "Please enter your full name."
                              : null,
                        ),
                        _buildTextField(
                          controller: _emailController,
                          labelText: "Email Address",
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email.";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return "Please enter a valid email.";
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _mobileController,
                          labelText: "Mobile Number",
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) => value == null || value.isEmpty
                              ? "Please enter your mobile number."
                              : null,
                        ),
                        DropdownButtonFormField<String>(
                          value: _payerStatus,
                          items: const [
                            DropdownMenuItem(
                                value: "Filer", child: Text("Filer")),
                            DropdownMenuItem(
                                value: "Non-Filer", child: Text("Non-Filer")),
                            DropdownMenuItem(
                                value: "I will Become Filer Soon",
                                child: Text("I will Become Filer Soon")),
                          ],
                          onChanged: (value) =>
                              setState(() => _payerStatus = value),
                          decoration: InputDecoration(
                            labelText: "Payer Status",
                            prefixIcon:
                                const Icon(Icons.account_balance_wallet),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Please select your payer status."
                              : null,
                        ),
                        const SizedBox(height: 10.0),
                        _buildTextField(
                          controller: _passportController,
                          labelText: "Passport Number",
                          icon: Icons.document_scanner,
                          validator: (value) => value == null || value.isEmpty
                              ? "Please enter your passport number."
                              : null,
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: _proceedToNextStep,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text("Next",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              )),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  void _proceedToNextStep() {
    if (_formKey.currentState!.validate()) {
      final userInfo = {
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'payerStatus': _payerStatus,
        'passportNumber': _passportController.text,
      };

      final packageDataWithUserInfo = {
        ...widget.packageData,
        'userInfo': userInfo,
      };

      if (widget.proceedToCheckoutDirectly) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutScreen(
              packageData: packageDataWithUserInfo,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingSelectionScreen(
              packageData: packageDataWithUserInfo,
            ),
          ),
        );
      }
    }
  }
}
