import 'package:credit_card_number_validator/credit_card_number_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CreditCardInputForm extends StatefulWidget {
  final CreditCardModel creditCardModel;

  CreditCardInputForm(this.creditCardModel);

  @override
  State<StatefulWidget> createState() => _CreditCardInputFormState();
}

class _CreditCardInputFormState extends State<CreditCardInputForm> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  void initState() {
    widget.creditCardModel.cvvCode = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.grey),
          onPressed: () {
            Map<String, dynamic> cardData = CreditCardValidator.getCard(
                widget.creditCardModel.cardNumber.replaceAll(" ", ""));
            if (!cardData[CreditCardValidator.isValidCard] ||
                cvvCode.isEmpty ||
                cardHolderName.isEmpty ||
                expiryDate.isEmpty) widget.creditCardModel.cardNumber = "";
            Navigator.of(context).pop();
          },
        ),
        title: Text("信用卡設定", style: TextStyle(fontSize: 48.sp)),
      ),
      bottomSheet: Container(
        alignment: Alignment.center,
        height: 140.h,
        color: Colors.green,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        child: ListTile(
          onTap: () {
            Map<String, dynamic> cardData = CreditCardValidator.getCard(
                widget.creditCardModel.cardNumber.replaceAll(" ", ""));
            if (!cardData[CreditCardValidator.isValidCard] ||
                cvvCode.isEmpty ||
                cardHolderName.isEmpty ||
                expiryDate.isEmpty) {
              Alert(
                context: context,
                type: AlertType.error,
                style: AlertStyle(
                  descStyle: TextStyle(color: Colors.grey[600]),
                ),
                title: "信用卡無法辨識",
                desc: "我們無法辨識您的信用卡, 請檢查您輸入的信用卡資訊!",
                buttons: [
                  DialogButton(
                    child: Text(
                      "了解",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    width: 120,
                  )
                ],
              ).show();
            } else {
              Navigator.of(context).pop();
            }
          },
          contentPadding: EdgeInsets.zero,
          title: Text(
            "保存設定",
            style: TextStyle(
              color: Colors.white,
              fontSize: 42.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: CreditCardWidget(
                  height: 500.h,
                  cardNumber: widget.creditCardModel.cardNumber,
                  expiryDate: widget.creditCardModel.expiryDate,
                  cardHolderName: widget.creditCardModel.cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                ),
              ),
              SingleChildScrollView(
                child: CreditCardForm(
                  onCreditCardModelChange: onCreditCardModelChange,
                  cardNumber: widget.creditCardModel.cardNumber,
                  expiryDate: widget.creditCardModel.expiryDate,
                  cardHolderName: widget.creditCardModel.cardHolderName,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 140.h))
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
      widget.creditCardModel.cardNumber = cardNumber;
      widget.creditCardModel.expiryDate = expiryDate;
      widget.creditCardModel.cardHolderName = cardHolderName;
      widget.creditCardModel.cvvCode = cvvCode;
      widget.creditCardModel.isCvvFocused = isCvvFocused;
    });
  }
}

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;

  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.updateText(cardNumber);
    _expiryDateController.text = expiryDate;
    _cardHolderNameController.text = cardHolderName;

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: TextFormField(
                controller: _cardNumberController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '信用卡卡號',
                  hintText: 'xxxx xxxx xxxx xxxx',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _expiryDateController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '有效期限',
                    hintText: 'MM/YY'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextField(
                focusNode: cvvFocusNode,
                controller: _cvvCodeController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '末三碼',
                  hintText: 'XXX',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (String text) {
                  setState(() {
                    cvvCode = text;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '信用卡持卡人',
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
