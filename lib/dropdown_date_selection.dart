import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DropdownDateSelection extends StatelessWidget {
  final DateTime date;
  final void Function(int? month) onMonthSelect;
  final void Function(int? year) onYearSelect;
  final DateTime maximumDate;
  final DateTime minimumDate;
  final Color foregroundColor;
  final Color textColor;

  const DropdownDateSelection({
    Key? key,
    required this.date,
    required this.onMonthSelect,
    required this.onYearSelect,
    required this.maximumDate,
    required this.minimumDate,
    required this.foregroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MonthSelection(
            currentMonth: date.month,
            onSelect: onMonthSelect,
            foregroundColor: foregroundColor,
            textColor: textColor,
          ),
          const SizedBox(width: 3),
          YearSelection(
            currentYear: date.year,
            minYear: minimumDate.year,
            maxYear: maximumDate.year,
            onSelect: onYearSelect,
            foregroundColor: foregroundColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }
}


class MonthSelection extends StatefulWidget {
  final int currentMonth;
  final void Function(int? selectedMonth) onSelect;
  final Color foregroundColor;
  final Color textColor;

  const MonthSelection({
    super.key,
    required this.currentMonth,
    required this.onSelect,
    required this.foregroundColor,
    required this.textColor,
  });

  @override
  MonthSelectionState createState() => MonthSelectionState();
}

class MonthSelectionState extends State<MonthSelection> {
  final List<String> months = DateFormat
      .MMMM()
      .dateSymbols
      .MONTHS;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: widget.currentMonth,
      items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map((int month) {
        return DropdownMenuItem<int>(
          value: month,
          child: Text(
            months[month - 1].toString(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: widget.currentMonth == month
                  ? widget.foregroundColor
                  : widget.textColor,
            ),
          ),
        );
      }).toList(),
      onChanged: widget.onSelect,
    );
  }
}

class YearSelection extends StatefulWidget {
  final int currentYear;
  final int minYear;
  final int maxYear;
  final void Function(int? selectedYear) onSelect;
  final Color foregroundColor;
  final Color textColor;

  const YearSelection({
    super.key,
    required this.currentYear,
    required this.minYear,
    required this.maxYear,
    required this.onSelect,
    required this.foregroundColor,
    required this.textColor,
  });

  @override
  YearSelectionState createState() => YearSelectionState();
}

class YearSelectionState extends State<YearSelection> {
  List<int> years = [];

  @override
  void initState() {
    super.initState();
    for (int year = widget.minYear; year <= widget.maxYear; year++) {
      years.add(year);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: widget.currentYear,
      items: years.map((int year) {
        return DropdownMenuItem<int>(
          value: year,
          child: Text(
            year.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: widget.currentYear == year
                  ? widget.foregroundColor
                  : widget.textColor,
            ),
          ),
        );
      }).toList(),
      onChanged: widget.onSelect,
    );
  }
}
