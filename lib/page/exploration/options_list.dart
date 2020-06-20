part of 'options_page.dart';
enum CustomNum {a, b, c}

class OptionMenu extends StatefulWidget {
  @override
  State<OptionMenu> createState() => _OptionMenuState();
}

// TODO: 實作與接入我的探索
class _OptionMenuState extends State<OptionMenu> {

  bool val1 = false;
  bool val2 = false;
  bool val3 = false;
  CustomNum _selectedNum;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          children: <Widget>[
            Column(
              children:<Widget>[
                RadioListTile<CustomNum>(
                  value: CustomNum.a,
                  title: Text('正常糖'),
                  groupValue : _selectedNum,
                  onChanged: (value) {
                    setState(() {
                      _selectedNum = value;
                    });
                  },
                ),
              RadioListTile<CustomNum>(
                value: CustomNum.b,
                title: Text('少糖'),
                groupValue: _selectedNum,
                onChanged: (value) {
                  setState(() {
                    _selectedNum = value;
                  });
                },
              ),
              RadioListTile<CustomNum>(
                value: CustomNum.c,
                title: Text('半糖'),
                groupValue: _selectedNum,
                onChanged: (value) {
                  setState(() {
                    _selectedNum = value;
                  });
                },
              ),
/*
*             ListTile(
              onTap: (){
                setState(() {
                  val1 = !val1;
                });
              },
              leading:
              Checkbox(
                value: val1,
                onChanged: (bool value) {

                },
              ),
              title: Text("珍珠"),
              trailing: Text("+\$0"),
            ),
*
*
*
*
*
* */



              ],
            ),








            Divider(height: 30.0, color: Colors.black87),
            Row(
              children:<Widget>[Text(
                "加料選擇",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              ],
            ),
            ListTile(
              onTap: (){
                setState(() {
                  val1 = !val1;
                });
              },
              leading:
              Checkbox(
                value: val1,
                onChanged: (bool value) {

                },
              ),
              title: Text("珍珠"),
              trailing: Text("+\$0"),
            ),
            ListTile(
              onTap: (){
                setState(() {
                  val2 = !val2;
                });
              },
              leading:
              Checkbox(
                value: val2,
                onChanged: (bool value) {

                },
              ),
              title: Text("椰果"),
              trailing: Text("+\$0"),
            ),

            ListTile(

              onTap: (){
                setState(() {
                  val3 = !val3;
                });
              },
              leading:
                Checkbox(
                  value: val3,
                  onChanged: (bool value) {

                  },
                ),
              title: Text("玉米"),
              trailing: Text("+\$0"),
            ),



          ],
        )

      );

  }
}