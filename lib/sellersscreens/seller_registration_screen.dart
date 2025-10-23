import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zatch_app/sellersscreens/Daiilogs/common_text_field.dart';

class SellerRegistrationScreen extends StatefulWidget {
  const SellerRegistrationScreen({super.key});

  @override
  State<SellerRegistrationScreen> createState() =>
      _SellerRegistrationScreenState();
}

class _SellerRegistrationScreenState extends State<SellerRegistrationScreen> with SingleTickerProviderStateMixin {  int _currentStep = 0;
  final PageController _pageController = PageController();
  late TabController _tabController;
  // Step 1: KYC
  final _businessNameController = TextEditingController();
  final _gstController = TextEditingController();

  // Step 2: Address
  final _pickupAddress1Controller = TextEditingController();
  final _pickupAddress2Controller = TextEditingController();
  final _pickupPinCodeController = TextEditingController();
  final _pickupStateController = TextEditingController(); // This would be a dropdown in a real app
  final _pickupPhoneController = TextEditingController();
  bool _sameAsPickup = false;

  // Step 3: Bank Details
  final _accountHolderNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _upiController = TextEditingController();

  // Step 4: T&C
  bool _agreedToTerms = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // <--- ADD THIS INITIALIZATION
  }

  @override
  void dispose() {
    // Dispose all controllers
    _tabController.dispose();
    _pageController.dispose();
    _businessNameController.dispose();
    _gstController.dispose();
    _pickupAddress1Controller.dispose();
    _pickupAddress2Controller.dispose();
    _pickupPinCodeController.dispose();
    _pickupStateController.dispose();
    _pickupPhoneController.dispose();
    _accountHolderNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _bankNameController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      print("Registration Submitted!");
      // TODO: Add logic to submit all collected data
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.of(context).pop();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          const SizedBox(height: 30),
          _buildProgressStepper(),
          const SizedBox(height: 20),
          // The PageView replaces the static form
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Step1_KycInfo(),
                _Step2_AddressInfo(),
                _Step3_BankDetails(),
                _Step4_TermsAndConditions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: _previousPage, // Use the previous page handler
          child: Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFFDFDEDE)),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 18),
          ),
        ),
      ),
      title: const Text(
        "Register as a Seller",
        style: TextStyle(
          color: Color(0xFF121111),
          fontSize: 16,
          fontFamily: 'Encode Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressStepper() {
    final steps = ['Shop &\nKYC Info', 'Address', 'Bank Details', 'T&C'];
    double progressPercent = _currentStep / (steps.length - 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust this value as needed
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps.length, (index) {
              return SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(top: 44.0,),
                  child: Text(
                    steps[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF2C2C2C),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.36,
                    ),
                  ),
                ),
              );
            }),
          ),
          // This stack will contain the circles and the lines behind them.
          Padding(
            // Top padding to vertically center the 32px circles and 2px line
            padding: const EdgeInsets.only(top: 8.0),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // The background gray line
                Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 16), // Inset the line
                  color: const Color(0xFFDDDDDD),
                ),
                // The foreground green (progress) line
                FractionallySizedBox(
                  widthFactor: progressPercent,
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 16), // Inset the line
                    color: const Color(0xFFA2DC00),
                  ),
                ),
                // The step indicator circles, drawn on top of the lines
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(steps.length, (index) {
                    final isCompleted = index < _currentStep;
                    final isActive = index == _currentStep;
                    return _ProgressStepIndicator(
                      isActive: isActive,
                      isCompleted: isCompleted,
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // REPLACE this method
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 6.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFABABAB),
              fontSize: 14,
              fontFamily: 'Encode Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Color(0xFF616161),
            fontSize: 16,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF616161),
              fontSize: 16,
              fontFamily: 'Encode Sans',
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: const Color(0xFFF2F4F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(70),
              borderSide: BorderSide.none,
            ),
            // Adjusted padding to match Figma's text field appearance
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          ),
        ),
      ],
    );
  }
  Widget _Step1_KycInfo() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight( // Ensures the Column tries to be as tall as its parent
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Business Name *',
                  hint: 'Enter Business Name',
                  controller: _businessNameController,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'GSTIN / Enrollment ID *',
                  hint: 'Enter GST / Enrollment ID',
                  controller: _gstController,
                ),
                const SizedBox(height: 12),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Don't have GST Number? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Apply now',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => print("Navigate to GST application"),
                      ),
                    ],
                  ),
                ),
                const Spacer(), // This pushes the buttons to the bottom
                _buildActionButtons(), // Action buttons are now part of the step
                const SizedBox(height: 20), // Add some padding at the bottom
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _Step2_AddressInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 27.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          const SizedBox(height: 16),
          const Text("Shipping Method", style: TextStyle(color: Color(0xFFABABAB), fontSize: 14)),
          const SizedBox(height: 6),
          _buildShippingMethodTabBar(),

          const SizedBox(height: 24),

 SizedBox(
            height: 100,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildShippingByZatchView(),
                _buildShippingBySelfView(),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Pickup Address Section
          const Text('Pick up Address', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 20),
          _buildMapPlaceholder(), // Placeholder for map
          const SizedBox(height: 20),

          // Address Form
          _buildTextField(label: "Address line - 1", hint: "Enter Address", controller: _pickupAddress1Controller),
          const SizedBox(height: 20),
          _buildTextField(label: "Address line - 2(optional)", hint: "Enter Address", controller: _pickupAddress2Controller),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _buildTextField(label: "Pin Code", hint: "Enter Pin Code", controller: _pickupPinCodeController, keyboardType: TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(label: "State", hint: "Select State", controller: _pickupStateController)),
          ]),
          const SizedBox(height: 20),
          _buildTextField(label: "Phone", hint: "9966127822", controller: _pickupPhoneController, keyboardType: TextInputType.phone),

          const SizedBox(height: 50),

          // Billing Address Section
          const Text('Billing Address', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(value: _sameAsPickup, onChanged: (val) => setState(()=> _sameAsPickup = val!)),
              const Text('Same as Pick up address', style: TextStyle(color: Color(0xFF616161), fontSize: 16)),
            ],
          ),

          // If not the same, show the billing form (simplified here)
          if (!_sameAsPickup)
            const Text("Billing address form would appear here..."),

          const SizedBox(height: 40),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // --- Helper Widgets for Step 2 ---

  /// Builds the TabBar for shipping method selection.
  Widget _buildShippingMethodTabBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F5), // Unselected background
        borderRadius: BorderRadius.circular(60),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black, // Selected text color
        unselectedLabelColor: const Color(0xFF616161), // Unselected text color
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: const Color(0xFFCCF656), // Selected tab background
          borderRadius: BorderRadius.circular(60),
          border: Border.all(color: const Color(0xFFA2DC00)), // Selected tab border
        ),
        tabs: const [
          Tab(child: Text("Shipping by Zatch", style: TextStyle(fontWeight: FontWeight.w600))),
          Tab(child: Text("Shipping by self", style: TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  /// Content for the "Shipping by Zatch" tab.
  Widget _buildShippingByZatchView() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          "Zatch will handle the shipping. Please provide your pickup address below.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF616161), fontSize: 16),
        ),
      ),
    );
  }

  /// Content for the "Shipping by self" tab.
  Widget _buildShippingBySelfView() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          "You will handle your own shipping. The pickup address will be your primary business address.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF616161), fontSize: 16),
        ),
      ),
    );
  }

  /// Placeholder for the map widget.
  Widget _buildMapPlaceholder() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.map_outlined, color: Colors.grey, size: 50),
      ),
    );
  }


  // STEP 3: Bank Details
  Widget _Step3_BankDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 30),
          _buildTextField(label: "Account Holder Name*", hint: "Enter Account Holder Name", controller: _accountHolderNameController),
          const SizedBox(height: 20),
          _buildTextField(label: "Account Number", hint: "Enter Account Number", controller: _accountNumberController, keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTextField(label: "IFSC Code", hint: "Enter IFSC Code", controller: _ifscController)),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCF656),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
                ),
                child: const Text("IFSC Lookup", style: TextStyle(color: Colors.black, fontSize: 14)),
              )
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(label: "Bank Name", hint: "Enter Bank Name", controller: _bankNameController),
          const SizedBox(height: 20),
          _buildTextField(label: "UPI ID (optional)", hint: "Enter UPI ID", controller: _upiController),
          const SizedBox(height: 120),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // STEP 4: Terms & Conditions
  Widget _Step4_TermsAndConditions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 27.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          _buildPolicySection("Terms & Conditions"),
          const SizedBox(height: 30),
          _buildPolicySection("Returns Policy summary"),
          const SizedBox(height: 30),
          _buildPolicySection("Your Final Terms"),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(value: _agreedToTerms, onChanged: (val) => setState(() => _agreedToTerms = val!)),
              const Text('I agree to Terms & Returns Policy', style: TextStyle(color: Color(0xFF191919), fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 40),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 59),
            side: const BorderSide(width: 1, color: Colors.black),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CancelRegistrationModal();
              },
            );
          }, // Always cancel
          child: const Text('Cancel', style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        const SizedBox(height: 18),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCCF656),
            minimumSize: const Size(double.infinity, 59),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: _nextPage,
          child: Text(
            _currentStep == 3 ? 'Submit Registration' : 'Next',
            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
  // --- Dialog for Cancellation ---
  void _showCancelDialog() {showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.3), // Figma's background dim
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use minimum space
            children: <Widget>[
              const SizedBox(height: 26),
              const Text(
                'Are you sure you want to cancel\nRegistration Process',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1728),
                  fontSize: 18,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 36),

              // This button will fully cancel and exit the screen
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 59),
                  side: const BorderSide(width: 1, color: Colors.black),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog first
                  Navigator.of(context).pop(); // Then close the registration screen
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 12),

              // This button has its own logic (e.g., save to a database)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 59),
                  side: const BorderSide(width: 1, color: Colors.black),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  print("Save to draft action triggered!");
                  // TODO: Add your logic to save the form data
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Save To Draft',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 12),

              // This button simply closes the dialog
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA2DC00),
                  minimumSize: const Size(double.infinity, 59),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => Navigator.of(context).pop(), // Just close the dialog
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Encode Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
  }



  Widget _buildToggleSwitch(List<String> options){
    // This is a simplified representation. A real one would use a state variable.
    return Container(
      height: 49,
      decoration: BoxDecoration(
          color: const Color(0x1E767680),
          borderRadius: BorderRadius.circular(58)
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(58),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 3))]
              ),
              child: Center(child: Text(options[0], style: const TextStyle(fontWeight: FontWeight.w500))),
            ),
          ),
          Expanded(
            child: Center(child: Text(options[1])),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection(String title){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF191919), fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque dictum augue arcu, hendrerit lobortis neque malesuada sit amet. Quisque scelerisque ut massa in convallis. Vivamus ut gravida elit. In pulvinar, mauris non commodo ultrices, est orci gravida leo...",
            style: TextStyle(color: Color(0xFF9A9A9A), fontSize: 12, height: 1.33)
        ),
      ],
    );
  }

  }

// A new widget for JUST the step indicator circle and checkmark.
class _ProgressStepIndicator extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;

  const _ProgressStepIndicator({
    this.isActive = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color stepColor = (isActive || isCompleted)
        ? const Color(0xFFA2DC00) // Green for active or completed
        : const Color(0xFFDDDDDD); // Gray for inactive

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: stepColor,
            shape: BoxShape.circle,
          ),
        ),
        // If the step is NOT completed, show the inner dot
        if (!isCompleted)
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: stepColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
          ),
        // If the step IS completed, show a checkmark icon instead
        if (isCompleted)
          const Icon(
            Icons.check,
            color: Colors.white,
            size: 20.0,
          ),
      ],
    );
  }
}


class _ProgressStep extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _ProgressStep({
    required this.label,
    this.isActive = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color stepColor = (isActive || isCompleted)
        ? const Color(0xFFA2DC00) // Green for active or completed
        : const Color(0xFFDDDDDD); // Gray for inactive

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: stepColor,
                shape: BoxShape.circle,
              ),
            ),
            // If the step is NOT completed, show the inner dot
            if (!isCompleted)
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: stepColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
              ),
            // If the step IS completed, show a checkmark icon instead
            if (isCompleted)
              const Icon(
                Icons.check,
                color: Colors.white,
                size: 20.0,
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 80, // Give a fixed width for consistent wrapping
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.36,
            ),
          ),
        )
      ],
    );
  }
}
