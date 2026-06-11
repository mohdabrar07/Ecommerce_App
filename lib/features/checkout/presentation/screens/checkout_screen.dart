import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/logic/cubit/cart_cubit.dart';
import '../../../cart/logic/cubit/cart_state.dart';
import 'package:ecommerce_app/features/address/data/models/address_model.dart'; // ADD THIS LINE

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Requirement 7: Saved Address pool matching requirement specifications
  List<AddressModel> userAddresses = [
    AddressModel(
      id: "1",
      fullName: "John Doe",
      mobileNumber: "+971 50 123 4567",
      emirate: "Dubai",
      area: "Dubai Marina",
      buildingName: "Marina Heights",
      flatNumber: "1402",
      landmark: "Near Metro Station",
      isDefault: true,
    )
  ];

  String selectedPaymentMethod = "Cash on Delivery"; // Default option
  int selectedAddressIndex = 0;

  // Form Controllers for Address Fields
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _areaController = TextEditingController();
  final _buildingController = TextEditingController();
  final _flatController = TextEditingController();
  final _landmarkController = TextEditingController();
  String _selectedEmirate = "Dubai";

  final List<String> _emirates = ["Abu Dhabi", "Dubai", "Sharjah", "Ajman", "Umm Al Quwain", "Ras Al Khaimah", "Fujairah"];

  void _openAddressFormDialog({AddressModel? addressToEdit, int? index}) {
    if (addressToEdit != null) {
      _nameController.text = addressToEdit.fullName;
      _mobileController.text = addressToEdit.mobileNumber;
      _selectedEmirate = addressToEdit.emirate;
      _areaController.text = addressToEdit.area;
      _buildingController.text = addressToEdit.buildingName;
      _flatController.text = addressToEdit.flatNumber;
      _landmarkController.text = addressToEdit.landmark;
    } else {
      _nameController.clear();
      _mobileController.clear();
      _selectedEmirate = "Dubai";
      _areaController.clear();
      _buildingController.clear();
      _flatController.clear();
      _landmarkController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(addressToEdit == null ? "Add UAE Address" : "Edit Address"),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name *"), validator: (v) => v!.isEmpty ? "Required" : null),
                    TextFormField(controller: _mobileController, decoration: const InputDecoration(labelText: "Mobile Number *"), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? "Required" : null),
                    DropdownButtonFormField<String>(
                      value: _selectedEmirate,
                      decoration: const InputDecoration(labelText: "Emirate *"),
                      items: _emirates.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setDialogState(() => _selectedEmirate = val!),
                    ),
                    TextFormField(controller: _areaController, decoration: const InputDecoration(labelText: "Area *"), validator: (v) => v!.isEmpty ? "Required" : null),
                    TextFormField(controller: _buildingController, decoration: const InputDecoration(labelText: "Building Name *"), validator: (v) => v!.isEmpty ? "Required" : null),
                    TextFormField(controller: _flatController, decoration: const InputDecoration(labelText: "Flat / Apartment Number *"), validator: (v) => v!.isEmpty ? "Required" : null),
                    TextFormField(controller: _landmarkController, decoration: const InputDecoration(labelText: "Landmark *"), validator: (v) => v!.isEmpty ? "Required" : null),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    final newAddress = AddressModel(
                      id: addressToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      fullName: _nameController.text.trim(),
                      mobileNumber: _mobileController.text.trim(),
                      emirate: _selectedEmirate,
                      area: _areaController.text.trim(),
                      buildingName: _buildingController.text.trim(),
                      flatNumber: _flatController.text.trim(),
                      landmark: _landmarkController.text.trim(),
                      isDefault: addressToEdit?.isDefault ?? false,
                    );

                    if (index == null) {
                      userAddresses.add(newAddress);
                      selectedAddressIndex = userAddresses.length - 1;
                    } else {
                      userAddresses[index] = newAddress;
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _areaController.dispose();
    _buildingController.dispose();
    _flatController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout Validation")),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          if (cartState is! CartLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. ADDRESS MANAGEMENT SECTION (Requirement 7)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Delivery Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () => _openAddressFormDialog(),
                      icon: const Icon(Icons.add_location_alt),
                      label: const Text("Add New"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                userAddresses.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                        child: const Text("Please add a delivery address to continue.", style: TextStyle(color: Colors.red)),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userAddresses.length,
                        itemBuilder: (context, idx) {
                          final addr = userAddresses[idx];
                          final isSelected = idx == selectedAddressIndex;
                          return Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              onTap: () => setState(() => selectedAddressIndex = idx),
                              leading: Radio<int>(
                                value: idx,
                                groupValue: selectedAddressIndex,
                                onChanged: (val) => setState(() => selectedAddressIndex = val!),
                              ),
                              title: Text("${addr.fullName} (${addr.mobileNumber})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: Text(addr.fullAddressText, style: const TextStyle(fontSize: 12)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: () => _openAddressFormDialog(addressToEdit: addr, index: idx)),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        userAddresses.removeAt(idx);
                                        selectedAddressIndex = userAddresses.isNotEmpty ? 0 : -1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                const Divider(height: 32),

                // 2. CART SUMMARY COMPONENT (Requirement 8)
                const Text("Items Summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartState.items.length,
                  itemBuilder: (context, index) {
                    final item = cartState.items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text("${item.title} x${item.quantity}", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13))),
                          Text("AED ${(item.price * item.quantity).toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 32),

                // 3. PAYMENT SELECTION PANEL (Requirement 8 - Cash, Card, Wallet)
                const Text("Select Payment Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...["Cash on Delivery", "Card Payment", "Wallet"].map((method) => RadioListTile<String>(
                      title: Text(method),
                      value: method,
                      groupValue: selectedPaymentMethod,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => selectedPaymentMethod = val!),
                    )),
                const Divider(height: 32),

                // 4. PRICE ACCOUNTING AND FINAL PLACE ORDER INITIATION
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Subtotal"), Text("AED ${cartState.subtotal.toStringAsFixed(2)}")]),
                      const SizedBox(height: 6),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("VAT (5%)"), Text("AED ${cartState.vat.toStringAsFixed(2)}")]),
                      const SizedBox(height: 6),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Delivery"), Text("AED ${cartState.deliveryCharge.toStringAsFixed(2)}")]),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Grand Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("AED ${cartState.total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Requirement 8: Place Order verification execution loop
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (userAddresses.isEmpty || selectedAddressIndex < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error: Valid delivery address required!"), backgroundColor: Colors.red),
                        );
                        return;
                      }

                      // ROUTING STEP TO REQUIREMENT 9 (Order Success Breakdown View)
                      final activeAddr = userAddresses[selectedAddressIndex];
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          icon: const Icon(Icons.check_circle, color: Colors.green, size: 50),
                          title: const Text("Order Confirmed!"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order ID: #EC-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text("Total Paid: AED ${cartState.total.toStringAsFixed(2)}"),
                              const SizedBox(height: 4),
                              Text("Method: $selectedPaymentMethod"),
                              const SizedBox(height: 4),
                              const Text("Estimated Delivery: 2-3 Working Days", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 10),
                              Text("Shipping to:\n${activeAddr.fullName}\n${activeAddr.buildingName}, ${activeAddr.area}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.popUntil(context, (route) => route.isFirst);
                              },
                              child: const Text("Continue Shopping"),
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text("Place Order", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}