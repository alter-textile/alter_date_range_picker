import 'alter_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// `AlterDateRangePicker({
///   Key? key,
///   this.initialStartDate,
///   this.initialEndDate,
///   required this.onApplyClick,
///   this.barrierDismissible = true,
///   required this.minimumDate,
///   required this.maximumDate,
///   required this.onCancelClick,
/// }`
class AlterDateRangePicker extends StatefulWidget {
  final DateTime minimumDate;

  final DateTime maximumDate;

  final bool barrierDismissible;

  final DateTime? initialStartDate;

  final DateTime? initialEndDate;

  final Color foregroundColor;

  final Color backgroundColor;

  final Color textColor;

  final Function(DateTime?, DateTime?) onApplyClick;

  final Function() onClearClick;

  final bool selectRange;

  const AlterDateRangePicker({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onApplyClick,
    required this.selectRange,
    this.barrierDismissible = true,
    required this.minimumDate,
    required this.maximumDate,
    required this.onClearClick,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  AlterDateRangePickerState createState() => AlterDateRangePickerState();
}

class AlterDateRangePickerState extends State<AlterDateRangePicker>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (widget.barrierDismissible) Navigator.pop(context);
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(4, 4),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (widget.selectRange)
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'FROM',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: widget.textColor.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    startDate != null
                                        ? DateFormat('EEE, dd MMM')
                                            .format(startDate!)
                                        : '--/-- ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: widget.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 74,
                              width: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'TO',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: widget.textColor.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    endDate != null
                                        ? DateFormat('EEE, dd MMM')
                                            .format(endDate!)
                                        : '--/-- ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: widget.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      const Divider(
                        height: 1,
                      ),
                      AlterCalender(
                        selectRange: widget.selectRange,
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        initialEndDate: widget.initialEndDate,
                        initialStartDate: widget.initialStartDate,
                        foregroundColor: widget.foregroundColor,
                        textColor: widget.textColor,
                        startEndDateChange: (
                          DateTime? startDateData,
                          DateTime? endDateData,
                        ) {
                          setState(() {
                            startDate = startDateData;
                            endDate = endDateData;
                          });
                          if(widget.selectRange == false){
                            widget.onApplyClick(startDate, endDate);
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16, top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24.0),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: TextButton(
                                    onPressed: () {
                                      try {
                                        widget.onClearClick();
                                        Navigator.pop(context);
                                      } catch (_) {}
                                    },
                                    child: Center(
                                      child: Text(
                                        'Clear',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: widget.foregroundColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  try {
                                    if (startDate == null && endDate == null) {
                                      return;
                                    }

                                    widget.onApplyClick(startDate, endDate);
                                    Navigator.pop(context);
                                  } catch (_) {}
                                },
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: widget.foregroundColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.6),
                                        blurRadius: 8,
                                        offset: const Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Apply',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `showFlutterDateRangePicker(
///   BuildContext context, {
///   required bool dismissible,
///   required DateTime minimumDate,
///   required DateTime maximumDate,
///   DateTime? startDate,
///   DateTime? endDate,
///   required Function(DateTime startDate, DateTime endDate) onApplyClick,
///   required Function() onCancelClick,
///   Color? backgroundColor,
///   Color? primaryColor,
///   String? fontFamily,
/// })`
void showFlutterDateRangePicker(
  BuildContext context, {
  required bool dismissible,
  required DateTime minimumDate,
  required DateTime maximumDate,
  bool selectRange = true,
  DateTime? startDate,
  DateTime? endDate,
  required Function(DateTime? startDate, DateTime? endDate) onApplyClick,
  required Function() onClearClick,
  Color foregroundColor = Colors.blue,
  Color backgroundColor = Colors.white,
  Color textColor = Colors.black,
  String? fontFamily,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  showDialog<dynamic>(
    context: context,
    useSafeArea: true,
    builder: (BuildContext context) => AlterDateRangePicker(
      barrierDismissible: true,
      selectRange: selectRange,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      initialStartDate: startDate,
      initialEndDate: endDate,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onApplyClick: onApplyClick,
      onClearClick: onClearClick,
    ),
  );
}
