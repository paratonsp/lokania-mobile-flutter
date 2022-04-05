import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lokania/src/utils/themes.dart';
import 'package:lokania/src/models/CountryOptionModel.dart';
import 'package:lokania/src/utils/sizes.dart';

class CountryTile extends StatelessWidget {
  final CountryOption countryOption;
  final Function onTap;

  CountryTile({
    @required this.countryOption,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            child:
                CountryPickerUtils.getDefaultFlagImage(countryOption.country),
            decoration: BoxDecoration(boxShadow: [customShadow()]),
          ),
          SizedBox(
            width: Sizes.s15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${countryOption.country.name} (${countryOption.lang})",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: FontSize.s15,
                ),
              ),
              Text(
                "${countryOption.currency}",
                style: TextStyle(
                  fontSize: FontSize.s12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Spacer(),
          countryOption.selected ? Icon(Icons.check) : Container()
        ],
      ),
    );
  }
}
