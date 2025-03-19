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

class _UploadEventState extends State<UploadEvent> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  final List<String> eventcategory = ["Cultural", "Natural", "Mixed"];
  String? value;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

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
      initialDate: DateTime.now(), // Use selectedDate as the initial date
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
      initialTime: TimeOfDay.now(), // Use selectedTime as the initial time
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0, left: 20, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 5.0),
                  const Text(
                    "Upload Monument",
                    style: TextStyle(
                      color: Color(0xff6351ec),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              selectedImage != null
                  ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          selectedImage!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Center(
                      child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    ),
              const SizedBox(height: 30.0),
              const Text(
                "Monument Name",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Monument Name",
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              const Text(
                "Ticket Price",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: pricecontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Price",
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              const Text(
                "Monument Location",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: locationcontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Location",
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Select Category",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items:
                        eventcategory
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() {
                          this.value = value;
                        }),
                    dropdownColor: Colors.white,
                    hint: const Text("Select Category"),
                    iconSize: 36,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: value,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickDate();
                    },
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    DateFormat('yyyy-MM-dd').format(selectedDate!),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: () {
                      _pickTime();
                    },
                    child: Icon(Icons.alarm, color: Colors.blue, size: 30.0),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    formatTimeOfDay(selectedTime!),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              const Text(
                "Monument Detail",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: detailcontroller,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "What is on that monument....?",
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // String addId = randomAlphaNumeric(10);
                    // Reference firebaseStorageRef = FirebaseStorage.instance
                    //     .ref()
                    //     .child("blogImages")
                    //     .child(addId);

                    // final UploadTask task = firebaseStorageRef.putFile(
                    //   selectedImage!,
                    // );

                    // var downloadUrl = await (await task).ref.getDownloadURL();
                    String id = randomAlphaNumeric(10);

                    Map<String, dynamic> uploadevent = {
                      "Image": "",
                      "Name": namecontroller.text,
                      "Price": pricecontroller.text,
                      "Category": value,
                      "Location": locationcontroller.text,
                      "Detail": detailcontroller.text,
                      "Date": DateFormat('yyyy-MM-dd').format(selectedDate!),
                      "Time": formatTimeOfDay(selectedTime!),
                    };
                    await DatabaseMethods().addEvent(uploadevent, id).then((
                      value,
                    ) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "Monument Uploaded Successfully!!",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      );
                      setState(() {
                        namecontroller.text = "";
                        pricecontroller.text = "";
                        detailcontroller.text = "";
                        selectedImage = null;
                      });
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xff6351ec),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 200,
                      child: const Center(
                        child: Text(
                          "Upload",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
}