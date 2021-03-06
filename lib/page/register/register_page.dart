import 'package:dogeeats/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  String _fullName = "", _email = "", _password = "";
  bool _passwordVisible = true;

  void _screenInit(BuildContext context) {
    ScreenUtil.init(context,
        width: 1080, height: 1920, allowFontScaling: false);
  }

  @override
  Widget build(BuildContext context) {
    _screenInit(context);
    final form = Form(
      key: _registerFormKey,
      child: Column(children: _buildFormWidget()),
    );
    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: _registerMessageHandler,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(130.w),
            child: Center(child: form),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormWidget() {
    return [
      Image.asset('assets/images/logo.png', height: 450.h, width: 450.w),
      Padding(padding: EdgeInsets.all(30)),
      _buildFullNameInput(),
      Padding(padding: EdgeInsets.all(10)),
      _buildEmailInput(),
      Padding(padding: EdgeInsets.all(10)),
      _buildPasswordInput(),
      Padding(padding: EdgeInsets.all(10)),
      _buildPasswordConfirmInput(),
      Padding(padding: EdgeInsets.all(20)),
      _buildActionButton(),
    ];
  }

  Widget _buildFullNameInput() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Full Name"),
      validator: _valid,
      onSaved: _setFullName,
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      decoration: InputDecoration(labelText: "E-mail Address"),
      validator: _validEmail,
      onSaved: _setAccount,
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      obscureText: _passwordVisible,
      decoration: InputDecoration(
        labelText: "Password",
        suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible)),
      ),
      validator: _valid,
      onSaved: _setPassword,
    );
  }

  Widget _buildPasswordConfirmInput() {
    return TextFormField(
      obscureText: _passwordVisible,
      decoration: InputDecoration(labelText: "Confirm Password"),
      validator: _validConfirmPassword,
    );
  }

  Widget _buildActionButton() {
    return Row(
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.fromLTRB(100.w, 0, 100.w, 0),
          color: Theme.of(context).primaryColor,
          child: Text("SIGN UP",
              style: TextStyle(fontSize: 36.sp, color: Colors.white)),
          onPressed: _submit,
        ),
        Spacer(),
        FlatButton(
          padding: EdgeInsets.fromLTRB(100.w, 0, 100.w, 0),
          child: Text("LOG IN",
              style: TextStyle(
                  fontSize: 36.sp, color: Theme.of(context).primaryColor)),
          onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
        ),
      ],
    );
  }

  void _setFullName(value) {
    _fullName = value.toString().trim();
  }

  void _setAccount(value) {
    _email = value.toString().trim();
  }

  void _setPassword(value) {
    _password = value.toString();
  }

  String _valid(value) {
    return value == "" ? "不可為空" : null;
  }

  String _validConfirmPassword(value) {
    return _password.isEmpty || value != _password ? "密碼確認失敗" : null;
  }

  String _validEmail(String value) {
    // RFC2822 Email Validation
    Pattern pattern =
        r'''[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?''';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? "不合法的 Email" : null;
  }

  void _submit() async {
    _registerFormKey.currentState.save();
    if (_registerFormKey.currentState.validate()) {
      BlocProvider.of<RegisterBloc>(context).add(RegisterButtonClickEvent(
        _fullName,
        _email,
        _password,
      ));
    }
  }

  void _registerMessageHandler(context, state) async {
    final scaffold = Scaffold.of(context);
    scaffold.hideCurrentSnackBar();
    if (state is RegisterFailed)
      _showLoginFailedMessage(scaffold, state.props[0]);
    else if (state is RegisterWaiting)
      _showLoginWaitingMessage(scaffold);
    else if (state is RegisterSucceeded) {
      _showLoginSuccessMessage(scaffold);
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("註冊成功", style: TextStyle(color: Colors.grey)),
          content: Text("感謝您的註冊!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/login");
              },
              child: Text("確認"),
            ),
          ],
        ),
      );
    }
  }

  void _showLoginSuccessMessage(ScaffoldState scaffold) {
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("註冊成功"), Icon(Icons.done_all)],
        ),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  void _showLoginWaitingMessage(ScaffoldState scaffold) {
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("註冊中..."),
            Container(
              child: CircularProgressIndicator(strokeWidth: 3.0),
              height: 30,
              width: 30,
            )
          ],
        ),
      ),
    );
  }

  void _showLoginFailedMessage(ScaffoldState scaffold, String message) {
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(message), Icon(Icons.error_outline)],
        ),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}
