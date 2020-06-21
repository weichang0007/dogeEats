part of 'options_page.dart';


class OptionMenu extends StatefulWidget {
  @override
  State<OptionMenu> createState() => _OptionMenuState();
}

// TODO: 實作與接入我的探索
class _OptionMenuState extends State<OptionMenu> {
  bool val1 = false;
  bool val2 = false;
  bool val3 = false;
  int _selectedNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Divider(height: 30.0, color: Colors.white),
            Row(
              children: <Widget>[
                Text(
                  "　甜度選擇",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            ListTile(
              onTap: () => setState(() => _selectedNum = 0),
              leading:Radio(
                value: 0,
                groupValue: _selectedNum,
                onChanged: (v) => setState(() => _selectedNum = v),
              ),
              title: Text("正常糖"),
              trailing: Text("+\$0",
                style: TextStyle(
                  color: Colors.black45,
                ),),
            ),
            ListTile(
              onTap: () => setState(() => _selectedNum = 1),
              leading:Radio(
                value: 1,
                groupValue: _selectedNum,
                onChanged: (v) => setState(() => _selectedNum = v),
              ),
              title: Text("少糖"),
              trailing: Text("+\$0",
                style: TextStyle(
                  color: Colors.black45,
                ),),
            ),
            ListTile(
                onTap: () => setState(() => _selectedNum = 2),
                leading:Radio(
                  value: 2,
                  groupValue: _selectedNum,
                  onChanged: (v) => setState(() => _selectedNum = v),
                ),
                title: Text("半糖"),
                trailing: Text("+\$0",
                  style: TextStyle(
                    color: Colors.black45,
                  ),),
                ),

          ],
        ),
        Divider(height: 30.0, color: Colors.black87),
        Row(
          children: <Widget>[
            Text(
              "　加料選擇",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        ListTile(
          onTap: () {
            setState(() {
              val1 = !val1;
            });
          },
          leading: Checkbox(
            value: val1,
            onChanged: (bool value) {},
          ),
          title: Text("珍珠"),
          trailing: Text("+\$0",
            style: TextStyle(
              color: Colors.black45,
            ),
          ),
        ),
        ListTile(
          onTap: () {
            setState(() {
              val2 = !val2;
            });
          },
          leading: Checkbox(
            value: val2,
            onChanged: (bool value) {},
          ),
          title: Text("椰果"),
          trailing: Text("+\$0",
            style: TextStyle(
              color: Colors.black45,
            ),),
        ),
        ListTile(
          onTap: () {
            setState(() {
              val3 = !val3;
            });
          },
          leading: Checkbox(
            value: val3,
            onChanged: (bool value) {},
          ),
          title: Text("玉米"),
          trailing: Text("+\$0",
            style: TextStyle(
              color: Colors.black45,
            ),),
        ),
      ],
    ));
  }
}
