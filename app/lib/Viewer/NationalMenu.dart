import 'package:csv/csv.dart';
import 'package:es/Model/ExpenseModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/quickalert.dart';
import 'package:es/Model/CategoryModel.dart';
import 'package:es/Database/RemoteDBHelper.dart';
import 'package:es/Model/TransactionsModel.dart';

class NationalMenu extends StatefulWidget {
  const NationalMenu({super.key, required this.title, required this.currency});
  final String title;
  final String currency;

  @override
  State<NationalMenu> createState() => _NationalMenuState();
}

class _NationalMenuState extends State<NationalMenu> {
  RemoteDBHelper remoteDBHelper =
  RemoteDBHelper(userInstance: FirebaseAuth.instance);
  bool _initState = true;
  List<List<dynamic>> _portugalList = [];
  final List<dynamic> _years = [];
  final List<dynamic> _portugalCategories = ['Portugal'];
  String _selectedPortugalCategory = 'Portugal';
  final List<String> _userCategories = ['My Data', 'Total'];
  final CategoryModel _selectedUserCategory = CategoryModel(categoryID: '',userID: '',name: 'My Data',color: 0);
  List<TransactionModel> _userList = [];

  String getPortugalValue(String year, String category){
    if (category == 'Portugal') return '';
    int pos = 0;
    for (var cat in _portugalCategories){
      if (cat == category) break;
      pos++;
    }
    for (var line in _portugalList){
      if (line[0].toString() == year){
        return line[pos];
      }
    }
    return '';
  }

  String getUserValue(String year, String category){
    if (category == 'My Data') return '';
    double result = 0;
    for (final transaction in _userList){
      if (transaction is ExpenseModel && (transaction.date.year.toString() == year)){
        result += transaction.total;
      }
    }
    return (result == 0)? '' : ('${result.toStringAsFixed(1).replaceAll('.', ',')} ${widget.currency}');
  }

  void _loadCSV() async {
    final rawData = await rootBundle.loadString("assets/fortuneko.csv");
    List<List<dynamic>> listData =
    const CsvToListConverter(fieldDelimiter: ';').convert(rawData);
    setState(() {
      _portugalCategories.addAll(listData[0].sublist(1));
      for (final line in listData.sublist(1)){
        _years.add(line[0]);
      }
      _portugalList = listData;
    });
  }

  void _loadCategories() async {
    Stream<List<CategoryModel>> stream = remoteDBHelper.readCategories();
    stream.listen((categories) {
      if (mounted) {
        setState!(() {
          for (var category in categories) {
            _userCategories.add(category.name);
          }
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_initState){
      _initState = false;
      _loadCSV();
      _loadCategories();
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
                                  _buildCell(getPortugalValue(year.toString(), _selectedPortugalCategory)),
                                  _buildCell(getUserValue(year.toString(), _selectedUserCategory.name)),
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
          value: _selectedUserCategory.name,
          onChanged: (value) async {
            setState(() {
              _selectedUserCategory.name = value!;
            });
            Stream<List<TransactionModel>> stream;
            if (_selectedUserCategory.name == 'Total') {
              stream = await remoteDBHelper.readTransactions();
            } else {
              stream = await remoteDBHelper.getTransactionsByCategory(_selectedUserCategory.name);
            }
            _userList = await stream.first;
            setState(() {});
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
