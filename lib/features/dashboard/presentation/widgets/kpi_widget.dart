import 'package:flutter/material.dart';

class KpiWidget extends StatelessWidget {
  const KpiWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            showBottomBorder: true,
            border: TableBorder.all(
              color: Colors.black,
              width: 1,
              style: BorderStyle.solid,
            ),
            columns: const [
              DataColumn(label: Text("KPI")),
              DataColumn(
                label: Text("VALUE"),
              ),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text("KPI 1")),
                DataCell(Text("VALUE 1")),
              ]),
              DataRow(cells: [
                DataCell(Text("KPI 2")),
                DataCell(Text("VALUE 2")),
              ]),
              DataRow(cells: [
                DataCell(Text("KPI 3")),
                DataCell(Text("VALUE 3")),
              ]),
              DataRow(cells: [
                DataCell(Text("KPI 4")),
                DataCell(Text("VALUE 4")),
              ]),
              DataRow(cells: [
                DataCell(Text("KPI 5")),
                DataCell(Text("VALUE 5")),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
