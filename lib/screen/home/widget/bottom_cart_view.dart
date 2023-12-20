import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:voter_finder/data/model/area_model.dart';
import 'package:voter_finder/data/model/votar_model.dart';

import '../../../data/helper/database_helper.dart';
import '../../../data/model/word_model.dart';
import '../../../utill/color_resources.dart';
import '../../votar/votar_list_screen.dart';

class BottomCartView extends StatefulWidget {
  const BottomCartView({Key? key}) : super(key: key);

  @override
  State<BottomCartView> createState() => _BottomCartViewState();
}

class _BottomCartViewState extends State<BottomCartView> {
  int selectedIndex = -1; // -1 indicates no selection
  double devicePixelRatio = 0.0;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    devicePixelRatio = mediaQuery.devicePixelRatio;
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).hintColor,
            blurRadius: .5,
            spreadRadius: .1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildItem(0, Icons.account_box, 'নাম অনুসন্ধান'),
          buildItem(1, Icons.date_range, 'জন্ম তারিখ'),
          buildItem(2, Icons.align_vertical_bottom, 'হোল্ডিং নং'),
          buildItem(3, Icons.format_list_numbered, 'সিরিয়াল নং'),
        ],
      ),
    );
  }

  Widget buildItem(int index, IconData icon, String text) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        // Show corresponding bottom sheet
        showTopSheet(context, index);
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : null,
            size: 25,
          ),
          Text(
            text,
            style: TextStyle(color: isSelected ? Colors.blue : null,
                fontSize: 16 / MediaQuery.textScaleFactorOf(context)/devicePixelRatio*2.8 ),
          ),
        ],
      ),
    );
  }

  void showTopSheet(BuildContext context, int index) {
    Widget content;

    switch (index) {
      case 0:
        content = GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
            child: NameSearchBottomSheet());
        break;
      case 1:
        content = GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: BirthDateBottomSheet());
        break;
      case 2:
        content = GestureDetector(
            onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
            child: HoldingNumberBottomSheet());
        break;
      case 3:
        content = GestureDetector(
            onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
            child: NIDBottomSheet());
        break;
      default:
        content = Container();
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => content,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,// Set the height to cover half of the screen
        isDismissible: false
    );
  }
}

/// name bottom sheet
class NameSearchBottomSheet extends StatefulWidget {
  @override
  _NameSearchBottomSheetState createState() => _NameSearchBottomSheetState();
}

class _NameSearchBottomSheetState extends State<NameSearchBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<VotarDataModel> _nameWiseList = [];
  List<WordDataModel> _wordList = [];
  List<AreaDataModel> _areaList = [];
  List<AreaDataModel> _filteredAreaList = [];
  String? selectedGender;
  String? selectedWord;
  String? selectedWordName;
  String? selectedArea;
  String? selectedAreaName;
  final List<String> genderOptions = ['', 'পুরুষ', 'মহিলা', 'হিজড়া'];

  TextEditingController nameController = TextEditingController();

  Future<void> _loadNameWiseData(String name, String selectedGender, String selectedWord, String selectedArea) async {
    final nameData = await DatabaseHelper.instance.getNameWiseData(name, selectedGender, selectedWord, selectedArea);
    setState(() {
      _nameWiseList = nameData.toList();
      print("name_data_length: " + _nameWiseList.length.toString());
      print("name_data: " + _nameWiseList.map((votar) => votar.info).join(', '));

      _nameWiseList.length > 0
          ? Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VotarListScreen(_nameWiseList),
      ))
          : Get.snackbar(
        'দুঃখিত বার্তা!',
        'কোন ভোতার পাওয়া যায় নি !',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
    });
  }

  Future<void> _loadWordData() async {
    final wordData = await DatabaseHelper.instance.getWordData();
    setState(() {
      _wordList = wordData.toList();
      _filteredAreaList = getFilteredAreaList(selectedWord ?? '');
      print("wordData_length: " + _wordList.length.toString());
      print("wordData: " + wordData.toString());
    });
  }

  Future<void> _loadAreaData() async {
    final areaData = await DatabaseHelper.instance.getAllAreaData();
    setState(() {
      _areaList = areaData.toList();
      _filteredAreaList = getFilteredAreaList(selectedWord ?? '');
      print("areaData_length: " + _areaList.length.toString());
      print("areaData: " + areaData.toString());
    });
  }

  List<AreaDataModel> getFilteredAreaList(String selectedWord) {
    return _areaList.where((area) => area.word_id.toString() == selectedWord).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadWordData();
    _loadAreaData();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'নাম অনুসন্ধান',
                  style: TextStyle(fontSize: 24 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'নাম',
                    labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
                items: genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender.isEmpty ? 'পুরুষ/মহিলা' : gender, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'পুরুষ/মহিলা', labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedWord,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWord = newValue;
                    selectedWordName = _wordList
                        .firstWhere((word) => word.id.toString() == selectedWord, orElse: () => WordDataModel(name: ''))
                        .name;
                    _filteredAreaList = getFilteredAreaList(selectedWord!);
                    selectedArea = _filteredAreaList.isNotEmpty ? _filteredAreaList.first.id.toString() : null;
                    selectedAreaName = _filteredAreaList.isNotEmpty ? _filteredAreaList.first.name : null;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text('ওয়ার্ড বাছাই', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  ),
                  ..._wordList.map((WordDataModel word) {
                    return DropdownMenuItem<String>(
                      value: word.id.toString(),
                      child: Text(word.name, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context))),
                    );
                  }).toList(),
                ],
                decoration: InputDecoration(
                  labelText: 'ওয়ার্ড বাছাই', labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedArea,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedArea = newValue;
                    selectedAreaName = _filteredAreaList
                        .firstWhere((area) => area.id.toString() == selectedArea, orElse: () => AreaDataModel(name: ''))
                        .name;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text('এরিয়া বাছাই', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context))),
                  ),
                  ..._filteredAreaList.map((AreaDataModel area) {
                    return DropdownMenuItem<String>(
                      value: area.id.toString(),
                      child: Text(area.name, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context))),
                    );
                  }).toList(),
                ],
                decoration: InputDecoration(
                  labelText: 'এরিয়া বাছাই',labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('Name: ${nameController.text}, Gender: $selectedGender, Word: $selectedWordName, Area: $selectedAreaName');
                      _loadNameWiseData(nameController.text, selectedGender ?? '', selectedWordName ?? '', selectedAreaName ?? '');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: accent, // Change to your desired color
                  ),
                  child: Text('Search', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// birthday bottom sheet
class BirthDateBottomSheet extends StatefulWidget {
  @override
  _BirthDateBottomSheetState createState() => _BirthDateBottomSheetState();
}

class _BirthDateBottomSheetState extends State<BirthDateBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String date = '';
  List<VotarDataModel> _dateWiseList = [];
  List<WordDataModel> _wordList = [];
  List<AreaDataModel> _areaList = [];
  List<AreaDataModel> _filteredAreaList = [];
  String? selectedGender;
  String? selectedWord;
  String? selectedWordName;
  String? selectedArea;
  String? selectedAreaName;
  final List<String> genderOptions = ['', 'পুরুষ', 'মহিলা', 'হিজড়া'];


  // Controllers for day, month, and year fields
  TextEditingController dateController = TextEditingController();
  String convertToBanglaNumber(String englishNumber) {
    Map<String, String> numberMap = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };

    String banglaNumber = '';
    for (int i = 0; i < englishNumber.length; i++) {
      String digit = englishNumber[i];
      if (numberMap.containsKey(digit)) {
        banglaNumber += numberMap[digit]!;
      } else {
        banglaNumber += digit;
      }
    }

    return banglaNumber;
  }
  Future<void> _loadDateWiseData(String date, String selectedGender, String selectedWord, String selectedArea) async {
    String date_formate = convertToBanglaNumber(date);
    final dateData = await DatabaseHelper.instance.getDateWiseData(date_formate, selectedGender, selectedWord, selectedArea);
    setState(() {
      _dateWiseList = dateData.toList();
      print("name_data_length: " + _dateWiseList.length.toString());
      print("name_data: " + _dateWiseList.map((votar) => votar.info).join(', '));

      _dateWiseList.length > 0
          ? Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VotarListScreen(_dateWiseList),
      ))
          : Get.snackbar(
        'দুঃখিত বার্তা!',
        'কোন ভোতার পাওয়া যায় নি !',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
    });
  }

  Future<void> _loadWordData() async {
    final wordData = await DatabaseHelper.instance.getWordData();
    _wordList = wordData.toList();
    _filteredAreaList = getFilteredAreaList(selectedWord ?? '');
    print("wordData_length: " + _wordList.length.toString());
    print("wordData: " + wordData.toString());
    setState(() {

    });
  }

  Future<void> _loadAreaData() async {
    final areaData = await DatabaseHelper.instance.getAllAreaData();
    _areaList = areaData.toList();
    _filteredAreaList = getFilteredAreaList(selectedWord ?? '');
    print("areaData_length: " + _areaList.length.toString());
    print("areaData: " + areaData.toString());
    setState(() {

    });
  }

  List<AreaDataModel> getFilteredAreaList(String selectedWord) {
    return _areaList.where((area) => area.word_id.toString() == selectedWord).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadWordData();
    _loadAreaData();
  }

  // @override
  // void dispose() {
  //   // Dispose controllers to prevent memory leaks
  //   dateController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'জন্ম তারিখ অনুসন্ধান',
                  style: TextStyle(fontSize: 24 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child:  TextFormField(
                  style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  controller: dateController,
                  decoration: InputDecoration(
                      labelText: 'জন্ম তারিখ',labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                      hintText: 'জন্ম তারিখ (দিন/মাস/বছর : ০১/১২/১৯৯৪)', hintStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(height: 20),
              // Add the dropdown button
              DropdownButtonFormField<String>(
                value: selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
                items: genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender.isEmpty ? 'পুরুষ/মহিলা' : gender, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'পুরুষ/মহিলা', labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedWord,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWord = newValue;
                    selectedWordName = _wordList
                        .firstWhere((word) => word.id.toString() == selectedWord, orElse: () => WordDataModel(name: ''))
                        .name;
                    _filteredAreaList = getFilteredAreaList(selectedWord!);
                    selectedArea = _filteredAreaList.isNotEmpty ? _filteredAreaList.first.id.toString() : null;
                    selectedAreaName = _filteredAreaList.isNotEmpty ? _filteredAreaList.first.name : null;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text('ওয়ার্ড বাছাই' ,style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  ),
                  ..._wordList.map((WordDataModel word) {
                    return DropdownMenuItem<String>(
                      value: word.id.toString(),
                      child: Text(word.name, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                    );
                  }).toList(),
                ],
                decoration: InputDecoration(
                  labelText: 'ওয়ার্ড বাছাই', labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedArea,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedArea = newValue;
                    selectedAreaName = _filteredAreaList
                        .firstWhere((area) => area.id.toString() == selectedArea, orElse: () => AreaDataModel(name: ''))
                        .name;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text('এরিয়া বাছাই', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  ),
                  ..._filteredAreaList.map((AreaDataModel area) {
                    return DropdownMenuItem<String>(
                      value: area.id.toString(),
                      child: Text(area.name, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                    );
                  }).toList(),
                ],
                decoration: InputDecoration(
                  labelText: 'এরিয়া বাছাই',labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your button click logic here
                    if (_formKey.currentState!.validate()) {
                      print('Date: ${dateController.text}, Gender: $selectedGender, Word: $selectedWordName, Area: $selectedAreaName');
                      _loadDateWiseData(dateController.text, selectedGender ?? '', selectedWordName ?? '', selectedAreaName ?? '');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: accent, // Set the background color here
                  ),
                  child: Text('Search', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

/// holding bottom sheet
class HoldingNumberBottomSheet extends StatefulWidget {
  @override
  _HoldingNumberBottomSheetState createState() => _HoldingNumberBottomSheetState();
}

class _HoldingNumberBottomSheetState extends State<HoldingNumberBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<VotarDataModel> _holdingWiseList = [];
  List<WordDataModel> _wordList = [];
  List<AreaDataModel> _areaList = [];
  List<AreaDataModel> _filteredAreaList = [];
  String? selectedGender;
  String? selectedWord;
  String? selectedWordName;
  String? selectedArea;
  String? selectedAreaName;
  final List<String> genderOptions = ['', 'পুরুষ', 'মহিলা', 'হিজড়া'];

  TextEditingController holdingNumberController = TextEditingController();

  Future<void> _loadHoldingWiseData(String holding, String selectedGender, String selectedWord, String selectedArea) async {
    final holdingData = await DatabaseHelper.instance.getHoldingWiseData(holding, selectedGender, selectedWord, selectedArea);
    setState(() {
      _holdingWiseList = holdingData.toList();
      print("name_data_length: " + _holdingWiseList.length.toString());
      print("name_data: " + _holdingWiseList.map((votar) => votar.info).join(', '));

      _holdingWiseList.length > 0
          ? Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VotarListScreen(_holdingWiseList),
      ))
          : Get.snackbar(
        'দুঃখিত বার্তা!',
        'কোন ভোতার পাওয়া যায় নি !',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
    });
  }

  Future<void> _loadWordData() async {
    final wordData = await DatabaseHelper.instance.getWordData();
    setState(() {
      _wordList = wordData.toList();
      _filteredAreaList = getFilteredAreaList(selectedWord ?? '');
      print("wordData_length: " + _wordList.length.toString());
      print("wordData: " + wordData.toString());
    });
  }

  Future<void> _loadAreaData() async {
    final areaData = await DatabaseHelper.instance.getAllAreaData();
    setState(() {
      _areaList = areaData.toList();
      _filteredAreaList = getFilteredAreaList(selectedWord ?? '');
      print("areaData_length: " + _areaList.length.toString());
      print("areaData: " + areaData.toString());
    });
  }

  List<AreaDataModel> getFilteredAreaList(String selectedWord) {
    return _areaList.where((area) => area.word_id.toString() == selectedWord).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadWordData();
    _loadAreaData();
  }
  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    holdingNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'হোল্ডিং নং অনুসন্ধান',
                  style: TextStyle(fontSize: 24 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                controller: holdingNumberController,
                decoration: InputDecoration(labelText: 'হোল্ডিং নং', labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              // Add the dropdown button
              DropdownButtonFormField<String>(
                value: selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
                items: genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender.isEmpty ? 'পুরুষ/মহিলা' : gender, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'পুরুষ/মহিলা', labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedWord,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWord = newValue;
                    selectedWordName = _wordList
                        .firstWhere((word) => word.id.toString() == selectedWord, orElse: () => WordDataModel(name: ''))
                        .name;
                    _filteredAreaList = getFilteredAreaList(selectedWord!);
                    selectedArea = _filteredAreaList.isNotEmpty ? _filteredAreaList.first.id.toString() : null;
                    selectedAreaName = _filteredAreaList.isNotEmpty ? _filteredAreaList.first.name : null;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text('ওয়ার্ড বাছাই', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  ),
                  ..._wordList.map((WordDataModel word) {
                    return DropdownMenuItem<String>(
                      value: word.id.toString(),
                      child: Text(word.name, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                    );
                  }).toList(),
                ],
                decoration: InputDecoration(
                  labelText: 'ওয়ার্ড বাছাই',labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedArea,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedArea = newValue;
                    selectedAreaName = _filteredAreaList
                        .firstWhere((area) => area.id.toString() == selectedArea, orElse: () => AreaDataModel(name: ''))
                        .name;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text('এরিয়া বাছাই', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  ),
                  ..._filteredAreaList.map((AreaDataModel area) {
                    return DropdownMenuItem<String>(
                      value: area.id.toString(),
                      child: Text(area.name, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                    );
                  }).toList(),
                ],
                decoration: InputDecoration(
                  labelText: 'এরিয়া বাছাই',labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your button click logic here
                    if(_formKey.currentState!.validate()){
                      print('Name: ${holdingNumberController.text}, Gender: $selectedGender, Word: $selectedWordName, Area: $selectedAreaName');
                      _loadHoldingWiseData(holdingNumberController.text, selectedGender ?? '', selectedWordName ?? '', selectedAreaName ?? '');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: accent, // Set the background color here
                  ),
                  child: Text('Search', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

/// Serial bottom sheet
class NIDBottomSheet extends StatefulWidget {
  @override
  _NIDBottomSheetState createState() => _NIDBottomSheetState();
}

class _NIDBottomSheetState extends State<NIDBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<VotarDataModel> _serialWiseList = [];
  List<WordDataModel> _wordList = [];
  List<AreaDataModel> _areaList = [];
  List<AreaDataModel> _filteredAreaList = [];
  String? selectedGender;
  String? selectedWord;
  String? selectedWordName;
  String? selectedArea;
  String? selectedAreaName;
  final List<String> genderOptions = ['', 'পুরুষ', 'মহিলা', 'হিজড়া'];

  TextEditingController serialController = TextEditingController();
  String convertToBanglaNumber(String englishNumber) {
    Map<String, String> numberMap = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };
    String banglaNumber = '';
    for (int i = 0; i < englishNumber.length; i++) {
      String digit = englishNumber[i];
      if (numberMap.containsKey(digit)) {
        banglaNumber += numberMap[digit]!;
      } else {
        banglaNumber += digit;
      }
    }

    return banglaNumber;
  }
  Future<void> _loadSerialWiseData(String serial, String selectedGender, String selectedWord, String selectedArea) async {
    String serial_formate = convertToBanglaNumber(serial);
    final serialData = await DatabaseHelper.instance.getSerialWiseData(serial_formate, selectedGender, selectedWord, selectedArea);
    setState(() {
      _serialWiseList = serialData.toList();
      print("name_data_length: " + _serialWiseList.length.toString());
      print("name_data: " + _serialWiseList.map((votar) => votar.info).join(', '));

      _serialWiseList.length > 0
          ? Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VotarListScreen(_serialWiseList),
      ))
          : Get.snackbar(
        'দুঃখিত বার্তা!',
        'কোন ভোতার পাওয়া যায় নি !',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
    });
  }

  Future<void> _loadWordData() async {
    final wordData = await DatabaseHelper.instance.getWordData();
    setState(() {
      _wordList = wordData.toList();
      _filteredAreaList = getFilteredAreaList(selectedWord ?? '');
      print("wordData_length: " + _wordList.length.toString());
      print("wordData: " + wordData.toString());
    });
  }

  Future<void> _loadAreaData() async {
    final areaData = await DatabaseHelper.instance.getAllAreaData();
    setState(() {
      _areaList = areaData.toList();
      _filteredAreaList = getFilteredAreaList(selectedWord ?? '');
      print("areaData_length: " + _areaList.length.toString());
      print("areaData: " + areaData.toString());
    });
  }

  List<AreaDataModel> getFilteredAreaList(String selectedWord) {
    return _areaList.where((area) => area.word_id.toString() == selectedWord).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadWordData();
    _loadAreaData();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    serialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'সিরিয়াল নং অনুসন্ধান',
                  style: TextStyle(fontSize: 24 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                controller: serialController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'সিরিয়াল নং',labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
                items: genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender.isEmpty ? 'পুরুষ/মহিলা' : gender, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'পুরুষ/মহিলা',labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedWord,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWord = newValue;
                    selectedWordName = _wordList
                        .firstWhere((word) => word.id.toString() == selectedWord, orElse: () => WordDataModel(name: ''))
                        .name;
                    _filteredAreaList = getFilteredAreaList(selectedWord!);
                    selectedArea = _filteredAreaList.isNotEmpty ? _filteredAreaList.first.id.toString() : null;
                    selectedAreaName = _filteredAreaList.isNotEmpty ? _filteredAreaList.first.name : null;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text('ওয়ার্ড বাছাই', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  ),
                  ..._wordList.map((WordDataModel word) {
                    return DropdownMenuItem<String>(
                      value: word.id.toString(),
                      child: Text(word.name, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                    );
                  }).toList(),
                ],
                decoration: InputDecoration(
                  labelText: 'ওয়ার্ড বাছাই',labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedArea,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedArea = newValue;
                    selectedAreaName = _filteredAreaList
                        .firstWhere((area) => area.id.toString() == selectedArea, orElse: () => AreaDataModel(name: ''))
                        .name;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text('এরিয়া বাছাই', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                  ),
                  ..._filteredAreaList.map((AreaDataModel area) {
                    return DropdownMenuItem<String>(
                      value: area.id.toString(),
                      child: Text(area.name, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                    );
                  }).toList(),
                ],
                decoration: InputDecoration(
                  labelText: 'এরিয়া বাছাই',labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এই ক্ষেত্রটি খালি রাখা যাবে না';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your button click logic here
                    if (_formKey.currentState!.validate()) {
                      print('Name: ${serialController.text}, Gender: $selectedGender, Word: $selectedWordName, Area: $selectedAreaName');
                      _loadSerialWiseData(serialController.text, selectedGender ?? '', selectedWordName ?? '', selectedAreaName ?? '');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: accent, // Set the background color here
                  ),
                  child: Text('Search', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

