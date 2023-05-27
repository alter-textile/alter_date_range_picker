import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dropdown_date_selection.dart';

/// `const AlterCalendar({
///   Key? key,
///   this.initialStartDate,
///   this.initialEndDate,
///   this.startEndDateChange,
///   this.minimumDate,
///   this.maximumDate,
/// })`
class AlterCalender extends StatefulWidget {
  final DateTime minimumDate;

  final DateTime maximumDate;

  final DateTime? initialStartDate;

  final DateTime? initialEndDate;

  final Function(DateTime?, DateTime?)? startEndDateChange;

  final bool selectRange;

  final Color foregroundColor;

  final Color textColor;

  const AlterCalender({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
    this.startEndDateChange,
    required this.minimumDate,
    required this.maximumDate,
    required this.selectRange,
    required this.foregroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  AlterCalenderState createState() => AlterCalenderState();
}

class AlterCalenderState extends State<AlterCalender> {
  List<DateTime> dateList = <DateTime>[];

  DateTime currentMonthDate = DateTime.now();

  DateTime? startDate;

  DateTime? endDate;
  String? error;

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
      currentMonthDate = widget.initialStartDate!;
    }
    if (widget.initialEndDate != null) {
      endDate = widget.initialEndDate;
    }
    setListOfDate(currentMonthDate);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMothDay = 0;
    if (newDate.weekday < 7) {
      previousMothDay = newDate.weekday;
      for (int i = 1; i <= previousMothDay; i++) {
        dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 4),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24.0),
                      ),
                      onTap: () {
                        if (currentMonthDate.isBefore(
                            widget.minimumDate.add(const Duration(days: 30)))) {
                          return;
                        }
                        setState(() {
                          currentMonthDate = DateTime(
                            currentMonthDate.year,
                            currentMonthDate.month,
                            0,
                          );
                          setListOfDate(currentMonthDate);
                        });
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              DropdownDateSelection(
                date: currentMonthDate,
                maximumDate: widget.maximumDate,
                minimumDate: widget.minimumDate,
                foregroundColor: widget.foregroundColor,
                textColor: widget.textColor,
                onMonthSelect: (int? month) {
                  if (month == null) return;
                  setState(() {
                    currentMonthDate = DateTime(
                      currentMonthDate.year,
                      month + 1,
                      0,
                    );
                  });
                  setListOfDate(currentMonthDate);
                },
                onYearSelect: (int? year) {
                  if (year == null) return;
                  setState(() {
                    currentMonthDate = DateTime(
                      year,
                      currentMonthDate.month + 1,
                      0,
                    );
                    setListOfDate(currentMonthDate);
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24.0),
                      ),
                      onTap: () {
                        if (currentMonthDate.isAfter(
                            widget.maximumDate.add(const Duration(days: 0)))) {
                          return;
                        }
                        setState(() {
                          currentMonthDate = DateTime(
                            currentMonthDate.year,
                            currentMonthDate.month + 2,
                            0,
                          );
                          setListOfDate(currentMonthDate);
                        });
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Center(
              child: Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
          child: Row(children: getDaysNameUI()),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(children: getDaysNoUI()),
        ),
      ],
    );
  }

  List<Widget> getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(
              DateFormat('EEE').format(dateList[i]),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: widget.foregroundColor,
              ),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 2,
                          bottom: 2,
                          left: isStartDateRadius(date) ? 4 : 0,
                          right: isEndDateRadius(date) ? 4 : 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: startDate != null && endDate != null
                                ? getIsItStartAndEndDate(date) ||
                                        getIsInRange(date)
                                    ? widget.foregroundColor.withOpacity(0.4)
                                    : Colors.transparent
                                : Colors.transparent,
                            borderRadius: BorderRadius.only(
                              bottomLeft: isStartDateRadius(date)
                                  ? const Radius.circular(24.0)
                                  : const Radius.circular(0.0),
                              topLeft: isStartDateRadius(date)
                                  ? const Radius.circular(24.0)
                                  : const Radius.circular(0.0),
                              topRight: isEndDateRadius(date)
                                  ? const Radius.circular(24.0)
                                  : const Radius.circular(0.0),
                              bottomRight: isEndDateRadius(date)
                                  ? const Radius.circular(24.0)
                                  : const Radius.circular(0.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        if (currentMonthDate.month == date.month) {
                          final DateTime newminimumDate = DateTime(
                              widget.minimumDate.year,
                              widget.minimumDate.month,
                              widget.minimumDate.day - 1);
                          final DateTime newmaximumDate = DateTime(
                            widget.maximumDate.year,
                            widget.maximumDate.month,
                            widget.maximumDate.day + 1,
                          );
                          if (date.isAfter(newminimumDate) &&
                              date.isBefore(newmaximumDate)) {
                            onDateClick(date);
                          } else {
                            setState(() {
                              error =
                                  "Invalid.\nSelect between ${DateFormat("dd/MM/yyyy").format(widget.minimumDate)} and ${DateFormat("dd/MM/yyyy").format(widget.maximumDate)}";
                            });
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          decoration: BoxDecoration(
                            color: getIsItStartAndEndDate(date)
                                ? widget.foregroundColor
                                : Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32.0)),
                            border: Border.all(
                              color: getIsItStartAndEndDate(date)
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: getIsItStartAndEndDate(date)
                                ? <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      blurRadius: 4,
                                      offset: const Offset(0, 0),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                color: getIsItStartAndEndDate(date)
                                    ? Colors.white
                                    : currentMonthDate.month == date.month
                                        ? widget.textColor
                                        : widget.textColor.withOpacity(0.6),
                                fontSize: 16,
                                fontWeight: getIsItStartAndEndDate(date)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: DateTime.now().day == date.day &&
                                DateTime.now().month == date.month &&
                                DateTime.now().year == date.year
                            ? getIsInRange(date)
                                ? Colors.white
                                : widget.foregroundColor
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        count += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  bool getIsInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool getIsItStartAndEndDate(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month &&
        startDate!.year == date.year) {
      return true;
    } else if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month &&
        endDate!.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool isStartDateRadius(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month) {
      return true;
    } else if (date.weekday == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isEndDateRadius(DateTime date) {
    if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  void onDateClick(DateTime date) {
    if (!widget.selectRange) {
      startDate = date;
    } else {
      if (startDate == null && endDate == null) {
        startDate = date;
      } else if (startDate == null) {
        startDate = date;
      } else if (startDate != date && endDate == null) {
        endDate = date;
      } else if (startDate!.day == date.day && startDate!.month == date.month) {
        startDate = null;
      } else if (endDate!.day == date.day && endDate!.month == date.month) {
        endDate = null;
      }
      if (startDate == null && endDate != null) {
        startDate = endDate;
        endDate = null;
      }
      if (startDate != null && endDate != null) {
        if (!endDate!.isAfter(startDate!)) {
          final DateTime d = startDate!;
          startDate = endDate;
          endDate = d;
        }
        if (date.isBefore(startDate!)) {
          startDate = date;
        }
        if (date.isAfter(endDate!)) {
          endDate = date;
        }
      }
    }

    setState(() => widget.startEndDateChange!(startDate, endDate));
  }
}
