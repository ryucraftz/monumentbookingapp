import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monumentbookingapp/services/database.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent>
    with SingleTickerProviderStateMixin {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  final List<String> eventcategory = ["Mumbai", "Pune", "Banglore"];
  String? value;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 00);

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat('hh:mm a').format(dateTime);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8.0),
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(15),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Navigator.pop(context),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Color(0xff6351ec),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            "Upload Monument",
                            style: TextStyle(
                              color: Color(0xff6351ec),
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Image Upload Section
                      Center(
                        child: GestureDetector(
                          onTap: getImage,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child:
                                selectedImage != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 50,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Tap to add monument image",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Input Fields
                      _buildInputField(
                        label: "Monument Name",
                        controller: namecontroller,
                        hint: "Enter monument name",
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        label: "Ticket Price",
                        controller: pricecontroller,
                        hint: "Enter price",
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        label: "Location",
                        controller: locationcontroller,
                        hint: "Enter location",
                      ),
                      const SizedBox(height: 20),

                      // Category Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select Category",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  items:
                                      eventcategory.map((item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged:
                                      (value) => setState(() {
                                        this.value = value;
                                      }),
                                  hint: const Text(
                                    "Select Category",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xff6351ec),
                                  ),
                                  value: value,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Date and Time Selection
                      Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              elevation: 2,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: _pickDate,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Color(0xff6351ec),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        DateFormat(
                                          'MMM dd, yyyy',
                                        ).format(selectedDate),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              elevation: 2,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: _pickTime,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: Color(0xff6351ec),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        formatTimeOfDay(selectedTime),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        label: "Monument Details",
                        controller: detailcontroller,
                        hint: "Describe the monument...",
                        maxLines: 4,
                      ),
                      const SizedBox(height: 30),

                      // Upload Button
                      Center(
                        child: Material(
                          color: const Color(0xff6351ec),
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap:
                                _isLoading
                                    ? null
                                    : () async {
                                      if (selectedImage == null ||
                                          namecontroller.text.isEmpty ||
                                          pricecontroller.text.isEmpty ||
                                          locationcontroller.text.isEmpty ||
                                          value == null ||
                                          detailcontroller.text.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Please fill all fields",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() => _isLoading = true);

                                      try {
                                        String id = randomAlphaNumeric(10);
                                        Map<String, dynamic> uploadevent = {
                                          "Image": "",
                                          "Name": namecontroller.text,
                                          "Price": pricecontroller.text,
                                          "Category": value,
                                          "Location": locationcontroller.text,
                                          "Detail": detailcontroller.text,
                                          "Date": DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(selectedDate),
                                          "Time": formatTimeOfDay(selectedTime),
                                        };

                                        await DatabaseMethods().addEvent(
                                          uploadevent,
                                          id,
                                        );

                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Monument uploaded successfully!",
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Error uploading monument",
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isLoading = false);
                                        }
                                      }
                                    },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Center(
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
                                        : const Text(
                                          "Upload Monument",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    namecontroller.dispose();
    pricecontroller.dispose();
    locationcontroller.dispose();
    detailcontroller.dispose();
    super.dispose();
  }
}
