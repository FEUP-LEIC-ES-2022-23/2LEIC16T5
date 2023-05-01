import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';

class NationalMenu extends StatefulWidget {
  const NationalMenu({super.key, required this.title});
  final String title;

  @override
  State<NationalMenu> createState() => _NationalMenuState();
}

class _NationalMenuState extends State<NationalMenu> {
  bool _initState = true;
  List<List<dynamic>> _list = [];
  final List<dynamic> _years = [];
  final List<dynamic> _portugalCategories = ['Portugal'];
  String _selectedPortugalCategory = 'Portugal';

  String getValue(String year, String category){
    if (category == 'Portugal') return '';
    int pos = 0;
    for (var cat in _portugalCategories){
      if (cat == category) break;
      pos++;
    }
    for (var line in _list){
      if (line[0].toString() == year){
        return line[pos];
      }
    }
    return '';
  }

  void _loadCSV() async {
    _initState = false;
    final rawData = await rootBundle.loadString("assets/fortuneko.csv");
    List<List<dynamic>> listData =
    const CsvToListConverter(fieldDelimiter: ';').convert(rawData);
    setState(() {
      _portugalCategories.addAll(listData[0].sublist(1));
      for (final line in listData.sublist(1)){
        _years.add(line[0]);
      }
      _list = listData;
    });
  }

  List<String> _userCategories = ['My Data', 'category 2', 'category 3'];
  String _selectedUserCategory = 'My Data';


  @override
  Widget build(BuildContext context) {
    if (_initState){
      _loadCSV();
    }
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 12, 18, 50),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(widget.title,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
          centerTitle: true,
          leading: IconButton(
            key: const Key("Home"),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);}
            },
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
        ),
        body:
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(0.8),
                              1: FlexColumnWidth(2.0),
                              2: FlexColumnWidth(2.0),
                            },
                            children: [
                              TableRow(
                                  children: [
                                    _buildHeaderCell('Year'),
                                    _buildPortugalHeaderCell(),
                                    _buildUserHeaderCell()
                                  ]
                              ),
                              for (var year in _years)
                                _buildTableRow([
                                  _buildCell(year.toString()),
                                  _buildCell(getValue(year.toString(), _selectedPortugalCategory)),
                                  _buildCell('Total for $_selectedUserCategory'),
                                ]),

                            ],
                          )),
                      const SizedBox(height: 20.0),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue, // set the background color of the button
                        ),
                        onPressed: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            title: 'WARNING',
                            text: 'This data was retrieved from PORDATA on the 1st of May, 2023',
                            confirmBtnColor: Colors.lightBlue,
                          );
                        },
                        icon: const Icon(
                          Icons.warning_rounded,
                          size: 24.0,
                          color: Colors.white,
                        ),
                        label: const Text('Disclaimer', style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.normal),),
                      ),
                    ],
                  )
              ),
            )
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Text(text),
      )
    );
  }

  TableRow _buildTableRow(List<Widget> children) {
    return TableRow(
      children: children,
    );
  }

  Widget _buildCell(String text) {
    return Container(
      height: 50.0,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 15
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      height: 50.0,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.lightBlue,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20
        ),
      ),
    );
  }

  Widget _buildPortugalHeaderCell() {
    return Container(
      height: 50.0,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.lightBlue,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DropdownButton<String>(
          underline: Container(),
          dropdownColor: Colors.lightBlue,
          iconEnabledColor: Colors.white,
          value: _selectedPortugalCategory,
          onChanged: (value) {
            setState(() {
            _selectedPortugalCategory = value!;
          });
        },
        items: _portugalCategories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
                category,
                style: const TextStyle(
                color: Colors.white,
                fontSize: 20
            ),),
          );
        }).toList(),
      )),
    );
  }

  Widget _buildUserHeaderCell() {
    return Container(
      height: 50.0,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.lightBlue,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DropdownButton<String>(
          underline: Container(),
          dropdownColor: Colors.lightBlue,
          iconEnabledColor: Colors.white,
          value: _selectedUserCategory,
          onChanged: (value) {
            setState(() {
              _selectedUserCategory = value!;
            });
          },
          items: _userCategories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
