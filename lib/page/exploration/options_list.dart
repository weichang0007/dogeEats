part of 'options_page.dart';

class OptionMenu extends StatefulWidget {
  final Map product;
  const OptionMenu({Key key, this.product}) : super(key: key);
  @override
  State<OptionMenu> createState() => _OptionMenuState();
}

class _OptionMenuState extends State<OptionMenu> {
  List<Map> _radioButtonPool = [];
  List<Map> _checkBoxPool = [];
  List<Widget> _item = [];

  List<Widget> _buildOption(BuildContext context) {
    List<Widget> result = [];
    for (Map option in widget.product['options']) {
      if (option['option_type'].toString() == 'radio') {
        result.addAll(_buildRadioOption(context, option));
      } else if (option['option_type'].toString() == 'checkbox') {
        result.addAll(_buildCheckOption(context, option));
      }
    }
    return result;
  }

  List<Widget> _buildRadioOption(BuildContext context, Map option) {
    Map valueReference = _radioButtonPool
        .firstWhere((radio) => radio['option_id'] == option['id']);
    List<Widget> result = [ListTile(title: Text(option['name']))];
    for (Map radio in option['details']) {
      result.add(
        ListTile(
          onTap: () => setState(() => valueReference['value'] = radio['id']),
          leading: Radio(
            value: radio['id'],
            groupValue: valueReference['value'],
            onChanged: (value) =>
                setState(() => valueReference['value'] = value),
          ),
          title: Text(radio['option']),
          trailing: Text("+NT\$ ${radio['price'].toString()}"),
        ),
      );
    }
    return result;
  }

  List<Widget> _buildCheckOption(BuildContext context, Map option) {
    List<Widget> result = [ListTile(title: Text(option['name']))];
    for (Map checkBox in option['details']) {
      Map valueReference = _checkBoxPool.firstWhere((check) =>
          check['option_id'] == option['id'] && check['id'] == checkBox['id']);
      result.add(ListTile(
        onTap: null,
        leading: Checkbox(
          value: valueReference['value'],
          onChanged: (value) => setState(
            () => valueReference['value'] = value,
          ),
        ),
        title: Text(checkBox['option']),
        trailing: Text("+NT\$ ${checkBox['price'].toString()}"),
      ));
    }
    return result;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _radioButtonPool.clear();
    _checkBoxPool.clear();
    for (Map option in widget.product['options']) {
      if (option['option_type'].toString() == 'radio') {
        _radioButtonPool.add(
            {"option_id": option['id'], "value": option['details'][0]['id']});
      } else if (option['option_type'].toString() == 'checkbox') {
        for (Map checkBox in option['details']) {
          _checkBoxPool.add({
            "option_id": option['id'],
            "id": checkBox['id'],
            "value": false,
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: _buildOption(context));
    /*return Scaffold(
        body: Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            RadioListTile<int>(
              value: 0,
              title: Text('正常糖'),
              groupValue: _selectedNum,
              onChanged: (value) {
                setState(() {
                  _selectedNum = value;
                });
              },
            ),
            RadioListTile<int>(
              value: 1,
              title: Text('少糖'),
              groupValue: _selectedNum,
              onChanged: (value) {
                setState(() {
                  _selectedNum = value;
                });
              },
            ),
            RadioListTile<int>(
              value: 2,
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
          children: <Widget>[
            Text(
              "加料選擇",
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
          trailing: Text("+\$0"),
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
          trailing: Text("+\$0"),
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
          trailing: Text("+\$0"),
        ),
      ],
    ));*/
  }
}
