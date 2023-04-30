import 'package:flutter/material.dart';

class NationalMenu extends StatefulWidget {
  const NationalMenu({super.key, required this.title});
  final String title;

  @override
  State<NationalMenu> createState() => _NationalMenuState();
}

class _NationalMenuState extends State<NationalMenu> {
  List<String> _years = ['2020', '2021', '2022'];
  List<String> _portugalCategories = ['Portugal', 'Category 2', 'Category 3'];
  List<String> _userCategories = ['My Data', 'category 2', 'category 3'];
  String _selectedPortugalCategory = 'Portugal';
  String _selectedUserCategory = 'My Data';

  @override
  Widget build(BuildContext context) {
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
            key: Key("Home"),
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
            Column(
              children: [
                SizedBox(height: 20,),
                Table(
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
                        _buildCell(year),
                        _buildCell('Total for $_selectedPortugalCategory'),
                        _buildCell('Total for $_selectedUserCategory'),
                      ]),

                  ],
                )
              ],
            ));
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
        )
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
        borderRadius:BorderRadius.only(topLeft: Radius.circular(10.0)),
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
      decoration: BoxDecoration(
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
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.only(topRight: Radius.circular(10.0)),
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
