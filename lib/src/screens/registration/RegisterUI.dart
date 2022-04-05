import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lokania/src/helpers/localization.dart';
import 'package:lokania/src/helpers/modal.dart';
import 'package:lokania/src/helpers/navigation.dart';
import 'package:lokania/src/helpers/toast.dart';
import 'package:lokania/src/screens/dashboard/DashboardUI.dart';
import 'package:lokania/src/screens/login/LoginUI.dart';
import 'package:lokania/src/utils/sizes.dart';
import 'package:lokania/src/widgets/buttons.dart';
import 'package:lokania/src/widgets/inputs.dart';

class RegisterUI extends StatefulWidget {
  @override
  _RegisterUIState createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _obscurePassword = true;
  Country _selectedFilteredDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('90');

  Widget _buildDialogItem(Country country, {bool showCountryName = true}) =>
      Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          showCountryName ? Flexible(child: Text(country.name)) : Container()
        ],
      );

  void _openFilteredCountryPickerDialog() => showDialog(
      context: context,
      builder: (context) {
        var lang = AppLocalizations.of(context);
        return Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(
              hintText: "${lang.translate('screen.register.searchPhoneHint')}",
            ),
            isSearchable: true,
            title: Text(
              "${lang.translate('screen.register.selectPhoneText')}",
            ),
            onValuePicked: (Country country) =>
                setState(() => _selectedFilteredDialogCountry = country),
            itemFilter: (c) =>
                ['AR', 'DE', 'GB', 'CN', 'ID', 'US', 'MY'].contains(c.isoCode),
            itemBuilder: _buildDialogItem,
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("${lang.translate('screen.register.appBar')}"),
        elevation: 0,
        actions: <Widget>[
          TextButton(
            onPressed: () => openRemovePage(context, DashboardUI()),
            child: Text(
              "${lang.translate('screen.register.skip')}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(Sizes.s15, Sizes.s15, Sizes.s15, 0),
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "${lang.translate('screen.register.title')}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: FontSize.s20,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "${lang.translate('screen.register.subtitle')}",
                  style: TextStyle(
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
              SizedBox(
                height: Sizes.s25,
              ),
              Image.asset(
                "assets/images/misc/receptionist.png",
                height: Sizes.s100,
              ),
              SizedBox(
                height: Sizes.s25,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: OutlineTextField(
                      hintText:
                          "${lang.translate('screen.register.firstNameHint')}",
                      labelText:
                          "${lang.translate('screen.register.firstNameLabel')}",
                      hintStyle: TextStyle(fontSize: FontSize.s14),
                      labelStyle: TextStyle(fontSize: FontSize.s14),
                    ),
                  ),
                  SizedBox(
                    width: Sizes.s10,
                  ),
                  Expanded(
                    flex: 1,
                    child: OutlineTextField(
                      hintText:
                          "${lang.translate('screen.register.lastNameHint')}",
                      labelText:
                          "${lang.translate('screen.register.lastNameLabel')}",
                      hintStyle: TextStyle(fontSize: FontSize.s14),
                      labelStyle: TextStyle(fontSize: FontSize.s14),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Sizes.s15,
              ),
              OutlineTextField(
                hintText: "${lang.translate('screen.register.emailHint')}",
                labelText: "${lang.translate('screen.register.emailLabel')}",
                hintStyle: TextStyle(fontSize: FontSize.s14),
                labelStyle: TextStyle(fontSize: FontSize.s14),
              ),
              SizedBox(
                height: Sizes.s15,
              ),
              OutlineTextField(
                obscureText: _obscurePassword,
                hintText: "${lang.translate('screen.register.passwordHint')}",
                labelText: "${lang.translate('screen.register.passwordLabel')}",
                hintStyle: TextStyle(fontSize: FontSize.s14),
                labelStyle: TextStyle(fontSize: FontSize.s14),
                suffixIcon: IconButton(
                  icon: _obscurePassword
                      ? Icon(FlutterIcons.eye_fea)
                      : Icon(FlutterIcons.eye_off_fea),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = _obscurePassword ? false : true;
                    });
                  },
                ),
              ),
              SizedBox(
                height: Sizes.s20,
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: _openFilteredCountryPickerDialog,
                    child: _buildDialogItem(
                      _selectedFilteredDialogCountry,
                      showCountryName: false,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: OutlineTextField(
                      hintText:
                          "${lang.translate('screen.register.phoneHint')}",
                      labelText:
                          "${lang.translate('screen.register.phoneLabel')}",
                      hintStyle: TextStyle(fontSize: FontSize.s14),
                      labelStyle: TextStyle(fontSize: FontSize.s14),
                      textInputType: TextInputType.number,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Sizes.s20,
              ),
              Container(
                height: Sizes.s40,
                child: GradientButton(
                  title: "${lang.translate('screen.register.registerButton')}",
                  onTap: () async {
                    showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isDismissible: false,
                      builder: (BuildContext context) {
                        return CustomModal.loading(
                          context,
                          "Processing Registration..",
                        );
                      },
                    );
                    await Future.delayed(
                      Duration(milliseconds: 2500),
                      () => Navigator.pop(context),
                    );
                    showToast(_scaffoldKey, "Registration Successfuly");
                  },
                  fontSize: FontSize.s14,
                ),
              ),
              SizedBox(
                height: Sizes.s20,
              ),
              Text("${lang.translate('screen.register.registerAlt')}"),
              SizedBox(
                height: Sizes.s10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(right: Sizes.s5),
                      child: ButtonWithIcon(
                        title: "Google",
                        onTap: () =>
                            showToast(_scaffoldKey, "Login with Google"),
                        icon: FlutterIcons.google_faw,
                        color: Color(0xffFF6347),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: Sizes.s5),
                      child: ButtonWithIcon(
                        title: "Facebook",
                        onTap: () =>
                            showToast(_scaffoldKey, "Login with facebook"),
                        icon: FlutterIcons.facebook_f_faw,
                        color: Color(0xff083d8d),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Sizes.s30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${lang.translate('screen.register.accountAlt')}"),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => openPage(context, LoginUI()),
                      child: Text(
                        "${lang.translate('screen.register.loginButton')}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: Sizes.s20),
            ],
          ),
        ),
      ),
    );
  }
}
