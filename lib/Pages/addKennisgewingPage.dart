import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projek/Theme/appColors.dart';
import 'package:projek/Widgets/customBottomNavBar.dart';
import 'package:projek/Widgets/customDialog.dart';
import 'package:projek/Widgets/grayContainer.dart';
import 'package:projek/Widgets/grayInputContainer.dart';
import 'package:projek/services/firestore.dart';
import 'package:projek/services/logleer.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Naam:Alden 
// Van: Peach
// Studente Nr: 2023010376

// DOEL VAN DIE PAGE
// ################################################################
// % Editing en Creating %
// Laat toe dat:
// - 'n Gebruiker NUWE kennisgewings kan maak (Create mode)
// - Ou kennisgewings kan redigeer of opdateer. (Editing mode)
// Gebruik die boolean isEditingMode om tussen verskillende modes te "swap".
//
// % Verifieer data %
// Verifieer dat:
// - Die data nie te lank is nie , bv. titel wat nie moet en elk geval nie lank hoef te wees nie 
//  ,want anders breek dit UI elemente en maak dat elemente sleg lyk.
// - Dat textfield nie leeg is nie.
//
// % Log maak van editing
// As kennisgewing suksesvol geredigeer word, dan stoor die log file die ou en nuwe titel, 
// dat hy ge-edit is en die tydstempel wanneer dit gebeur.
// 
// NB: logleer is onder dienste en hou die logika om na 'n teksleer toe te skryf en lees.

class Addkennisgewingpage extends StatefulWidget {
  final String? id;
  final String? titel;
  final String? teks;
  final String? skrywer;
  final String? kategorie;
  final String? datum;
  final bool isDarkMode;

  const Addkennisgewingpage({
    this.id,
    this.titel,
    this.teks,
    this.skrywer,
    this.kategorie,
    this.datum,
    required this.isDarkMode,
    super.key,
  });

  @override
  State<Addkennisgewingpage> createState() => _AddkennisgewingpageState();
}

class _AddkennisgewingpageState extends State<Addkennisgewingpage> {

  Logleer logleer = Logleer();
  Firestore firestore = Firestore();

  final List<String> options = ['akademie', 'velore goed', 'ander'];
  String? selectedValue;

  // Later geinitialise
  late TextEditingController _titelController;
  late TextEditingController _teksController;
  late TextEditingController _skrywerController;
  String? _selectedKategorie;

  

  bool _isDarkMode = false;
  // As parameters gegee word wysig dit in textfield indien wys dat textfield leeg is
  @override
  void initState() {
    super.initState();
    _titelController = TextEditingController(text: widget.titel ?? '');
    _teksController = TextEditingController(text: widget.teks ?? '');
    _skrywerController = TextEditingController(text: widget.skrywer ?? '');
    _selectedKategorie = widget.kategorie ?? 'akademie'; 
    _loadMode();
    
  }

  Future<void> _loadMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  // ACTIVATE EDITING MODE AS HY 'N ID IN SY PARAMATERS KRY
  // Sit page in editing mode
  bool get isEditingMode => widget.id != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Kennisgewing")),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              _isDarkMode
                  ? 'assets/background_black.svg'
                  : 'assets/background_white.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Vertoon al die textfields
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      kToolbarHeight, 
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, 
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        child: Text("Titel" ,style: TextStyle(color:Theme.of(context).primaryColor, )),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: greyContainer(context),
                        child: TextField(
                          decoration: grayInputContainer(context),
                          controller: _titelController,
                          ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        child: Text("Skrywer" ,style: TextStyle(color:Theme.of(context).primaryColor, )),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: greyContainer(context),
                        child: TextField(
                          decoration: grayInputContainer(context),
                          controller: _skrywerController,

                          ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        child: Text("Kategorie" ,style: TextStyle(color:Theme.of(context).primaryColor, )),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: greyContainer(context),
                        child: DropdownButtonFormField<String>(
                          value: selectedValue,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          hint: Text('Kies een van die opsies'),
                          items:
                              options.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        child: Text("Teks" ,style: TextStyle(color:Theme.of(context).primaryColor, ) ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: greyContainer(context),
                        child: TextField(
                          decoration: grayInputContainer(context),
                          controller: _teksController,
                          minLines: 3,
                          maxLines: null,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                ),
                                backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).primaryColorDark,
                                ),
                                foregroundColor: WidgetStatePropertyAll(AppColors.white)
                              ),
                              onPressed: () {
                                String? titel = _titelController.text;  
                                String? teks = _teksController.text;
                                String? skrywer = _skrywerController.text; 
                                String? kategorie = selectedValue;
                                
                                // Validering word gedoen
                                if(titel.isEmpty || teks.isEmpty || skrywer.isEmpty || kategorie == null){
                                  showCustomDialog(context, "Vul in al die velde." , "Error");
                                }else if(skrywer.length > 35 || teks.length > 1000 || titel.length > 19){
                                  showCustomDialog(context, "Skrywer(35) , teks(1000) of titel(19) is te lank" , "Error");
                                }
                                // Kyk of die teks in edit mode is of nie
                                 else{
                                  if(isEditingMode){
                                    // Vertoon boodskap afhangend van watter mode die toepassing is 
                                  showCustomDialog(context, "Kennisgewing met die titel is suksesvol opgedateer", "Opgedateer");
                                  // opdateer die kennisgewing op firestore
                                  firestore.opdateerKennisgewing(titel: titel, teks: teks, kategorie: kategorie, datum: widget.datum!, skrywer: skrywer, id: widget.id!);
                                  // Voeg 'n inskrywing in die logs.txt
                                  logleer.logKennisgewing("Nuwe naam: $titel", "EDIT: oorspronklike naam: ${widget.titel}");
                                  }
                                  else{
                                  showCustomDialog(context, "Kennisgewing met die titel $titel is suksesvol opgelaai", "Sukses");
                                  
                                  firestore.addKennisgewing(titel, teks, skrywer, kategorie);
                                  
                                  }
                                  // "clear" text en dropdownlist
                                  _titelController.clear();
                                  _teksController.clear();
                                  _skrywerController.clear();
                                  setState(() {
                                    selectedValue = null;
                                  });
                                }
                              },
                              child: Text(isEditingMode ? "Submit Edit":"Create"),
                            ),
                            
                          ],
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
    );
  }
}

// fake pr
