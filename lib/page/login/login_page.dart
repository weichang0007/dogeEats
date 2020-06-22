import 'package:dogeeats/bloc/blocs.dart';
import 'package:dogeeats/model/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _registerFormKey = GlobalKey<FormState>();
  String _email = "", _password = "";
  bool _passwordVisible = true;
  bool _hasCheckLoginStatus = false;

  @override
  void initState() {
    super.initState();
    _hasCheckLoginStatus = false;
    _checkLoginStatus();
  }

  void _screenInit(BuildContext context) {
    ScreenUtil.init(context,
        width: 1080, height: 1920, allowFontScaling: false);
  }

  Future<void> _checkLoginStatus() async {
    Setting setting = await Setting.instance;
    if (setting.token.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed("/home");
    } else
      setState(() {
        _hasCheckLoginStatus = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    _screenInit(context);
    final form = Form(
      key: _registerFormKey,
      child: Column(children: _buildFormWidget()),
    );
    return _hasCheckLoginStatus
        ? Scaffold(
            body: BlocListener<LoginBloc, LoginState>(
              listener: _loginMessageHandler,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(130.w),
                  child: Center(child: form),
                ),
              ),
            ),
          )
        : Center();
  }

  List<Widget> _buildFormWidget() {
    return [
      Image.asset('assets/images/logo.png', height: 450.h, width: 450.w),
      Padding(padding: EdgeInsets.all(30)),
      _buildEmailInput(),
      Padding(padding: EdgeInsets.all(10)),
      _buildPasswordInput(),
      Padding(padding: EdgeInsets.all(20)),
      _buildActionButton(),
    ];
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
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      validator: _valid,
      onSaved: _setPassword,
    );
  }

  String _validEmail(String value) {
    // RFC2822 Email Validation
    Pattern pattern =
        r'''[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?''';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? "不合法的 Email" : null;
  }

  Widget _buildActionButton() {
    return Row(
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.fromLTRB(100.w, 0, 100.w, 0),
          color: Theme.of(context).primaryColor,
          child: Text("LOG IN",
              style: TextStyle(fontSize: 36.sp, color: Colors.white)),
          onPressed: _submit,
        ),
        Spacer(),
        FlatButton(
          padding: EdgeInsets.fromLTRB(100.w, 0, 100.w, 0),
          child: Text("SIGN UP",
              style: TextStyle(
                  fontSize: 36.sp, color: Theme.of(context).primaryColor)),
          onPressed: () => Navigator.pushReplacementNamed(context, "/register"),
        ),
      ],
    );
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

  void _submit() async {
    _registerFormKey.currentState.save();
    if (_registerFormKey.currentState.validate()) {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonClickEvent(_email, _password),
      );
    }
  }

  void _loginMessageHandler(context, state) async {
    final scaffold = Scaffold.of(context);
    scaffold.hideCurrentSnackBar();
    if (state is LoginFailed)
      _showLoginFailedMessage(scaffold, state.props[0]);
    else if (state is LoginWaiting)
      _showLoginWaitingMessage(scaffold);
    else if (state is LoginSucceeded) {
      _showLoginSuccessMessage(scaffold);
      Phoenix.rebirth(context);
    }
  }

  void _showLoginSuccessMessage(ScaffoldState scaffold) {
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("登入成功"), Icon(Icons.done_all)],
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
            Text("登入中..."),
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
