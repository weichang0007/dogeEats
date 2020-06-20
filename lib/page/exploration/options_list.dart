part of 'options_page.dart';

class OptionMenu extends StatefulWidget {
  @override
  State<OptionMenu> createState() => _OptionMenuState();
}

// TODO: 實作與接入我的探索
class _OptionMenuState extends State<OptionMenu> {

  @override
  Widget build(BuildContext context) {


    bool Val1 = false;
    bool Val2 = false;
    bool Val3 = false;

    return Scaffold(
        body: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("正常糖"),
                Checkbox(
                  value: Val1,
                  onChanged: (bool value) {
                    setState(() {
                      Val1 = value;
                    });
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("少糖"),
                Checkbox(
                  value: Val2,
                  onChanged: (bool value) {
                    setState(() {
                      Val2 = value;
                    });
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("半糖"),
                Checkbox(
                  value: Val3,
                  onChanged: (bool value) {
                    setState(() {
                      Val3 = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );

  }
}