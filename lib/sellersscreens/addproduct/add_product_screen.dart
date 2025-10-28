import 'package:flutter/material.dart';
import 'package:zatch_app/services/api_service.dart'; // Import your ApiService

// Main Screen - A StatefulWidget to manage the multi-step form
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Controller to manage which page (step) is visible
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false; // To show a loading indicator during API calls

  // API Service instance
  final ApiService _apiService = ApiService();

  // --- FORM KEYS FOR VALIDATION ---
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _step3FormKey = GlobalKey<FormState>();
  final _step4FormKey = GlobalKey<FormState>();

  // --- STATE MANAGEMENT FOR FORM DATA (STEP 1) ---
  final _categoryController = TextEditingController(text: "electronics");
  final _subCategoryController = TextEditingController(text: "gadgets");
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _discountedPriceController = TextEditingController();
  final _stockQuantityController = TextEditingController();
  String _orderAcceptingType = "autoAccept";
  bool _isBargainEnabled = true;
  double _autoAcceptDiscount = 5.0;
  double _maxDiscount = 15.0;

  // --- STATE MANAGEMENT FOR FORM DATA (STEP 2, 3, etc.) ---
  final _colorController = TextEditingController();
  final _sizeController = TextEditingController();
  String? _productId; // To store the product ID returned from step 1

  @override
  void dispose() {
    // Dispose all controllers
    _pageController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    _salePriceController.dispose();
    _discountedPriceController.dispose();
    _stockQuantityController.dispose();
    _colorController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  /// Shows a snackbar with a message.
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 16,
            right: 16),
      ),
    );
  }

  /// Central logic to validate, build payload, and call the API.
  Future<void> _handleNext() async {
    if (_isLoading) return; // Prevent multiple submissions

    bool isFormValid = false;
    switch (_currentStep) {
      case 0:
        isFormValid = _step1FormKey.currentState?.validate() ?? false;
        break;
      case 1:
        isFormValid = _step2FormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isFormValid = _step3FormKey.currentState?.validate() ?? false;
        break;
      case 3:
        isFormValid = _step4FormKey.currentState?.validate() ?? false;
        break;
    }

    if (!isFormValid) {
      _showMessage("Please fill all required fields.", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> payload = {};

      // Build the payload based on the current step
      switch (_currentStep) {
        case 0:
          payload = {
            "step": "1",
            "category": _categoryController.text,
            "subCategory": _subCategoryController.text,
            "name": _productNameController.text,
            "description": _descriptionController.text,
            "price": int.tryParse(_salePriceController.text) ?? 0,
            "discountedPrice":
            int.tryParse(_discountedPriceController.text) ?? 0,
            "totalStock": int.tryParse(_stockQuantityController.text) ?? 0,
            "orderAcceptingType": _orderAcceptingType,
            "globalBargainSettings": {"enabled": _isBargainEnabled},
            "bargainSettings": {
              "autoAcceptDiscount": _autoAcceptDiscount,
              "maximumDiscount": _maxDiscount
            }
          };
          break;
        case 1:
          payload = {
            "step": "2",
            "productId": _productId, // Include the product ID
            "color": _colorController.text
          };
          break;
        case 2:
          payload = {
            "step": "3",
            "productId": _productId, // Include the product ID
            "size": _sizeController.text
          };
          break;
        case 3:
        // This is the final submission. Assuming step 4 is local validation only
        // before showing success.
          _showSuccessDialog();
          setState(() => _isLoading = false);
          return;
      }

      // Call the API
      final response = await _apiService.submitProductStep(payload);

      // Store product ID from step 1 response
      if (_currentStep == 0 && response.containsKey('productId')) {
        _productId = response['productId'];
      }

      _showMessage(response['message'] ?? "Step completed successfully!");

      // If API call is successful, move to the next page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } catch (e) {
      _showMessage(e.toString(), isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Added'),
        content: const Text('Your new product has been successfully added.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back from AddProductScreen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Function to move to the previous page
  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(92.0),
        child: Container(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 40.0, bottom: 16),
          decoration: const ShapeDecoration(
            color: Color(0xFFCCF656),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (_currentStep == 0) {
                    Navigator.of(context).pop();
                  } else {
                    _previousPage();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFDFDEDE)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.black, size: 20),
                ),
              ),
              const Text(
                'Add Products',
                style: TextStyle(
                  color: Color(0xFF121111),
                  fontSize: 16,
                  fontFamily: 'Encode Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 44), // Spacer for centering title
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 24.0),
                child: _ProductStepper(currentStep: _currentStep),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) {
                    setState(() {
                      _currentStep = page;
                    });
                  },
                  children: [
                    _ProductDetailsStep(
                      formKey: _step1FormKey,
                      onContinue: _handleNext,
                      nameController: _productNameController,
                      descriptionController: _descriptionController,
                      salePriceController: _salePriceController,
                      discountedPriceController: _discountedPriceController,
                      stockQuantityController: _stockQuantityController,
                      onBargainChanged: (enabled, autoAccept, max) {
                        setState(() {
                          _isBargainEnabled = enabled;
                          _autoAcceptDiscount = autoAccept;
                          _maxDiscount = max;
                        });
                      },
                      onOrderTypeChanged: (type) {
                        setState(() => _orderAcceptingType = type);
                      },
                    ),
                    _ColorVariantStep(
                      formKey: _step2FormKey,
                      onContinue: _handleNext,
                      onBack: _previousPage,
                      colorController: _colorController,
                    ),
                    _SizeVariantStep(
                      formKey: _step3FormKey,
                      onContinue: _handleNext,
                      onBack: _previousPage,
                      sizeController: _sizeController,
                    ),
                    _InventoryStep(
                        formKey: _step4FormKey,
                        onAddProduct: _handleNext,
                        onBack: _previousPage),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}

// ---- Reusable Stepper Widget (No Changes) ----
class _ProductStepper extends StatelessWidget {
  final int currentStep;
  const _ProductStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final List<String> steps = [
      'Product\nDetails',
      'Colors',
      'Sizes',
      'Inventory'
    ];
    return Column(
      children: [
        Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              return Expanded(
                child: Container(
                  height: 2,
                  color: currentStep >= (index ~/ 2) + 1
                      ? const Color(0xFFA2DC00)
                      : const Color(0xFFDDDDDD),
                ),
              );
            }
            final stepIndex = index ~/ 2;
            return _buildStepCircle(stepIndex);
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length, (index) {
            return Expanded(
              child: Text(
                steps[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF2C2C2C),
                  fontSize: 12,
                  fontWeight:
                  currentStep == index ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStepCircle(int index) {
    bool isActive = currentStep >= index;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFA2DC00) : const Color(0xFFDDDDDD),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFA2DC00) : const Color(0xFFD9D9D9),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// ==== STEP 1: PRODUCT DETAILS (MODIFIED FOR STATE) ===============
// ===================================================================

class _ProductDetailsStep extends StatelessWidget {
  final VoidCallback onContinue;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController salePriceController;
  final TextEditingController discountedPriceController;
  final TextEditingController stockQuantityController;
  final Function(bool, double, double) onBargainChanged;
  final ValueChanged<String> onOrderTypeChanged;

  const _ProductDetailsStep({
    super.key,
    required this.onContinue,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.salePriceController,
    required this.discountedPriceController,
    required this.stockQuantityController,
    required this.onBargainChanged,
    required this.onOrderTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _FormStepContainer(
      onContinue: onContinue,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Product Details',
              icon: Icons.inventory_2_outlined,
              child: Column(
                children: [
                  _buildTextField('Category *', 'Select Category',
                      isDropdown: true,
                      validator: (v) =>
                      v == null || v.isEmpty ? "Category is required" : null),
                  _buildTextField('Sub Category *', 'Select Sub Category',
                      isDropdown: true,
                      validator: (v) => v == null || v.isEmpty
                          ? "Sub Category is required"
                          : null),
                  _buildTextField('Product Name *', 'Enter product name',
                      controller: nameController,
                      validator: (v) => v == null || v.isEmpty
                          ? "Product Name is required"
                          : null),
                  _buildTextField(
                      'Description *', 'Describe your product...',
                      maxLines: 4,
                      controller: descriptionController,
                      validator: (v) => v == null || v.isEmpty
                          ? "Description is required"
                          : null),
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField('Sale price *', '299',
                              controller: salePriceController,
                              hasCurrency: true,
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || v.isEmpty
                                  ? "Sale Price is required"
                                  : null)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildTextField(
                              'Discounted price', '199',
                              controller: discountedPriceController,
                              hasCurrency: true,
                              keyboardType: TextInputType.number)),
                    ],
                  ),
                  _buildTextField(
                      'Stock Quantity *', 'Enter Stock Quantity',
                      controller: stockQuantityController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty
                          ? "Stock is required"
                          : null),
                  _buildOrderAcceptingType(),
                ],
              ),
            ),
            const SizedBox(height: 21),
            _BargainSettingsCard(onChanged: onBargainChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      {TextEditingController? controller,
        bool isDropdown = false,
        int maxLines = 1,
        bool hasCurrency = false,
        TextInputType? keyboardType,
        FormFieldValidator<String>? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF354152),
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 7),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
              const TextStyle(color: Color(0xFF717182), fontSize: 12.30),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(maxLines > 1 ? 16 : 46),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(maxLines > 1 ? 16 : 46),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: isDropdown
                  ? const Icon(Icons.arrow_drop_down, color: Colors.grey)
                  : null,
              prefixIcon: hasCurrency
                  ? const Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 2),
                  child: Text('₹',
                      style: TextStyle(color: Colors.grey, fontSize: 18)))
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderAcceptingType() {
    return StatefulBuilder(builder: (context, setState) {
      String groupValue = "autoAccept"; // Manage state locally for radio buttons
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Accepting Type *',
              style: TextStyle(
                  color: Color(0xFF354152),
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 11),
          Row(
            children: [
              Row(children: [
                Radio<String>(
                    value: "autoAccept",
                    groupValue: groupValue,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => groupValue = v);
                        onOrderTypeChanged(v);
                      }
                    },
                    activeColor: const Color(0xFFA2DC00)),
                const Text('Auto Accept')
              ]),
              const SizedBox(width: 18),
              Row(children: [
                Radio<String>(
                    value: "manual",
                    groupValue: groupValue,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => groupValue = v);
                        onOrderTypeChanged(v);
                      }
                    },
                    activeColor: const Color(0xFFA2DC00)),
                const Text('Ask before accepting')
              ]),
            ],
          )
        ],
      );
    });
  }

  Widget _buildSectionCard(
      {required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17.50, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF101727)),
              const SizedBox(width: 7),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF101727),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _BargainSettingsCard extends StatefulWidget {
  final Function(bool, double, double) onChanged;
  const _BargainSettingsCard({required this.onChanged});

  @override
  __BargainSettingsCardState createState() => __BargainSettingsCardState();
}

class __BargainSettingsCardState extends State<_BargainSettingsCard> {
  bool _isBargainEnabled = true;
  double _autoAcceptDiscount = 5.0;
  double _maxDiscount = 30.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17.50, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.sell_outlined, size: 18, color: Color(0xFF101727)),
                  SizedBox(width: 7),
                  Text(
                    'Bargain Settings',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Switch(
                value: _isBargainEnabled,
                onChanged: (value) {
                  setState(() => _isBargainEnabled = value);
                  widget.onChanged(
                      _isBargainEnabled, _autoAcceptDiscount, _maxDiscount);
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF030213),
              ),
            ],
          ),
          if (_isBargainEnabled) ...[
            const SizedBox(height: 21),
            _buildSlider(
              label: 'Auto-Accept Discount',
              value: _autoAcceptDiscount,
              onChanged: (newValue) {
                setState(() => _autoAcceptDiscount = newValue);
                widget.onChanged(
                    _isBargainEnabled, _autoAcceptDiscount, _maxDiscount);
              },
            ),
            const SizedBox(height: 21),
            _buildSlider(
              label: 'Maximum Discount',
              value: _maxDiscount,
              onChanged: (newValue) {
                setState(() => _maxDiscount = newValue);
                widget.onChanged(
                    _isBargainEnabled, _autoAcceptDiscount, _maxDiscount);
              },
            ),
            const SizedBox(height: 21),
            _buildPriceFloorInfo(),
          ]
        ],
      ),
    );
  }

  Widget _buildSlider(
      {required String label,
        required double value,
        required ValueChanged<double> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF354152),
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFECECF0),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                '${value.toInt()}%',
                style: const TextStyle(
                    color: Color(0xFF016630),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 14.0,
            trackShape: const RoundedRectSliderTrackShape(),
            activeTrackColor: const Color(0xFF030213),
            inactiveTrackColor: const Color(0xFFECECF0),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7.0),
            thumbColor: Colors.white,
            overlayColor: Colors.transparent,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            onChanged: onChanged,
          ),
        ),
        if (label == 'Auto-Accept Discount')
          const Text(
              'Orders at this discount or lower will be auto-accepted',
              style: TextStyle(color: Color(0xFF697282), fontSize: 10.5)),
      ],
    );
  }

  Widget _buildPriceFloorInfo() {
    const salePrice = 299;
    final priceFloor = salePrice * (1 - _maxDiscount / 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14.50, vertical: 10.50),
      decoration: BoxDecoration(
        color: const Color(0xFFECECF0),
        borderRadius: BorderRadius.circular(8.75),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price Floor:',
                style: TextStyle(color: Color(0xFF354152), fontSize: 12.30),
              ),
              Text(
                '₹${priceFloor.toStringAsFixed(0)}',
                style: const TextStyle(
                    color: Color(0xFF101727),
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 3.5),
          const Text(
            'Buyer will bargain till this price at the most',
            style: TextStyle(color: Color(0xFF697282), fontSize: 10.50),
          ),
        ],
      ),
    );
  }
}

// ==== STEP 2, 3, 4 WIDGETS (MODIFIED FOR STATE) ===

class _ColorVariantStep extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final GlobalKey<FormState> formKey;
  final TextEditingController colorController;

  const _ColorVariantStep(
      {super.key,
        required this.onContinue,
        required this.onBack,
        required this.formKey,
        required this.colorController});

  @override
  Widget build(BuildContext context) {
    return _FormStepContainer(
      onContinue: onContinue,
      onBack: onBack,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              color: const Color(0xFFF8FAFB),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Available Colours*',
                        style: TextStyle(
                            color: Color(0xFF354152),
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: colorController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter at least one color'
                          : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'e.g., Black, White, Red',
                        hintStyle: const TextStyle(color: Color(0xFF717182)),
                        fillColor: const Color(0xFFF9FAFB),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(46),
                            borderSide:
                            const BorderSide(color: Color(0xFFE5E7EB))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(46),
                            borderSide:
                            const BorderSide(color: Color(0xFFE5E7EB))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SizeVariantStep extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final GlobalKey<FormState> formKey;
  final TextEditingController sizeController;

  const _SizeVariantStep(
      {super.key,
        required this.onContinue,
        required this.onBack,
        required this.formKey,
        required this.sizeController});

  @override
  Widget build(BuildContext context) {
    return _FormStepContainer(
      onContinue: onContinue,
      onBack: onBack,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              color: const Color(0xFFF8FAFB),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildColorVariantCard(context, 'Black'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorVariantCard(BuildContext context, String colorName) {
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(colorName, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Available Sizes*',
                  style: TextStyle(
                      color: Color(0xFF354152),
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 7),
              TextFormField(
                controller: sizeController,
                validator: (v) =>
                v == null || v.isEmpty ? 'Please enter sizes' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: 'e.g., S, M, L',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(46),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(46),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Upload Images',
                  style: TextStyle(
                      color: Color(0xFF354152),
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 7),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: const Color(0xFFD0D5DB),
                          width: 1.5,
                          style: BorderStyle.solid),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, color: Colors.grey),
                        SizedBox(height: 4),
                        Text('Add Image',
                            style:
                            TextStyle(color: Colors.grey, fontSize: 10.5)),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              const Text('Upload at least 3 high-quality images.',
                  style: TextStyle(color: Color(0xFF697282), fontSize: 10.5)),
            ],
          ),
        )
      ],
    );
  }
}

class _InventoryStep extends StatelessWidget {
  final VoidCallback onAddProduct;
  final VoidCallback onBack;
  final GlobalKey<FormState> formKey;

  const _InventoryStep(
      {super.key,
        required this.onAddProduct,
        required this.onBack,
        required this.formKey});

  @override
  Widget build(BuildContext context) {
    return _FormStepContainer(
      onContinue: onAddProduct,
      continueText: 'Add Product',
      onBack: onBack,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              color: const Color(0xFFF8FAFB),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // This should be built dynamically based on selected colors/sizes
                  children: [
                    _buildInventoryCard('Size S - Colour Black'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(String variantName) {
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      title:
      Text(variantName, style: const TextStyle(fontWeight: FontWeight.w600)),
      childrenPadding:
      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      children: [
        TextFormField(
          validator: (v) =>
          v == null || v.isEmpty ? 'Inventory is required' : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: 'Inventory Available',
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(46),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(46),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          ),
          keyboardType: TextInputType.number,
        )
      ],
    );
  }
}

// ---- Reusable Container for Each Form Step with Buttons (No Changes) ----
class _FormStepContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback onContinue;
  final VoidCallback? onBack;
  final String continueText;

  const _FormStepContainer({
    required this.child,
    required this.onContinue,
    this.onBack,
    this.continueText = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: child,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA2DC00),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  continueText,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              if (onBack != null) ...[
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}
