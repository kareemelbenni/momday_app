import 'package:flutter/material.dart';
import 'package:momday_app/momday_localizations.dart';
import 'package:momday_app/styles/momday_colors.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final Widget widgetTitle;
  final PopupMenuButton menuButton;

  PageHeader({this.title, this.widgetTitle, this.menuButton});

  @override
  Widget build(BuildContext context) {
    var title = this.title != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                this.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.display3,
              ),
            ],
          )
        : widgetTitle;

    return Container(
      decoration: BoxDecoration(
        color: MomdayColors.MomdayGray,
      ),
      child: Stack(
        children: <Widget>[
          Navigator.of(context).canPop()
              ? Positioned(
                  top: 0.0,
                  bottom: 0.0,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        getLocalizedBackwardArrowIcon(context),
                        size: 24.0,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: title,
          ),
          menuButton != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [menuButton])
              : Container(),
        ],
      ),
    );
  }
}

class PageHeader2 extends StatelessWidget {
  final String title;

  PageHeader2({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: MomdayColors.Momdaypink, width: 3.0))),
      child: Stack(
        children: <Widget>[
          Navigator.of(context).canPop()
              ? Positioned(
                  top: 0.0,
                  bottom: 0.0,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        getLocalizedBackwardArrowIcon(context),
                        size: 24.0,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
