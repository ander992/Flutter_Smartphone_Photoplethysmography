import 'package:flutter/material.dart';

class StatPage extends StatefulWidget {
  final int result;
  const StatPage({super.key, required this.result});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  bool isLoaded = false;
  bool male = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() {
        isLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            collapsedHeight: kToolbarHeight,
            expandedHeight: kToolbarHeight + 100,
            backgroundColor: Colors.red,
            automaticallyImplyLeading: true,
            pinned: true,
            stretch: true,
            elevation: 0,
            title: const Text('Your Result'),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Hero(
                    tag: 'BPM_RESULT',
                    child: Material(
                      type: MaterialType.transparency,
                      child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            curve: Curves.easeInOutSine,
                            style: TextStyle(
                                fontSize: isLoaded ? 60 : 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            duration: const Duration(milliseconds: 200),
                            child: Text('${widget.result} BPM'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              stretchModes: const [StretchMode.fadeTitle],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ToggleButtons(
                        fillColor: Colors.red,
                        constraints:
                            const BoxConstraints(maxHeight: 50, minHeight: 30),
                        isSelected: [
                          male,
                          !male,
                        ],
                        onPressed: (index) {
                          setState(() {
                            male = (index == 0);
                          });
                        },
                        selectedColor: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text('Male', style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child:
                                Text('Female', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: !male,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20, top: 30),
                              child: Text("Male Ideal Values",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ),
                            DataTable(
                              rows: [
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Low")),
                                      getDataCell(0, 40),
                                      getDataCell(0, 40),
                                      getDataCell(0, 41),
                                      getDataCell(0, 41),
                                      getDataCell(0, 42),
                                      getDataCell(0, 41),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.redAccent.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Athlete")),
                                      getDataCell(41, 55),
                                      getDataCell(41, 54),
                                      getDataCell(42, 56),
                                      getDataCell(42, 57),
                                      getDataCell(43, 56),
                                      getDataCell(42, 55),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.purple.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Excellent")),
                                      getDataCell(56, 61),
                                      getDataCell(55, 61),
                                      getDataCell(57, 62),
                                      getDataCell(58, 63),
                                      getDataCell(57, 61),
                                      getDataCell(56, 61),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.blue.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Great")),
                                      getDataCell(62, 65),
                                      getDataCell(62, 65),
                                      getDataCell(63, 66),
                                      getDataCell(64, 67),
                                      getDataCell(62, 67),
                                      getDataCell(62, 65),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.cyan.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Good")),
                                      getDataCell(66, 69),
                                      getDataCell(66, 70),
                                      getDataCell(67, 70),
                                      getDataCell(68, 71),
                                      getDataCell(68, 71),
                                      getDataCell(66, 69),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.lightGreen.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Average")),
                                      getDataCell(70, 73),
                                      getDataCell(71, 74),
                                      getDataCell(71, 75),
                                      getDataCell(72, 76),
                                      getDataCell(72, 75),
                                      getDataCell(70, 73),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.yellow.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Below Average")),
                                      getDataCell(74, 81),
                                      getDataCell(75, 81),
                                      getDataCell(76, 82),
                                      getDataCell(77, 83),
                                      getDataCell(76, 81),
                                      getDataCell(74, 79),
                                    ],
                                    color: MaterialStateProperty.all(Colors
                                        .deepOrangeAccent
                                        .withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Poor")),
                                      getDataCell(82, 0),
                                      getDataCell(82, 0),
                                      getDataCell(83, 0),
                                      getDataCell(84, 0),
                                      getDataCell(82, 0),
                                      getDataCell(82, 0),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.red.withOpacity(0.6))),
                              ],
                              dataTextStyle: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              columns: const [
                                DataColumn(label: Text("Age")),
                                DataColumn(label: Text('18-25 yrs')),
                                DataColumn(label: Text('26-35 yrs')),
                                DataColumn(label: Text('36-45 yrs')),
                                DataColumn(label: Text('46-55 yrs')),
                                DataColumn(label: Text('56-65 yrs')),
                                DataColumn(label: Text('65+ yrs')),
                              ],
                              showBottomBorder: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: male,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20, top: 30),
                              child: Text("Female Ideal Values",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ),
                            DataTable(
                              rows: [
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Low")),
                                      getDataCell(0, 45),
                                      getDataCell(0, 45),
                                      getDataCell(0, 45),
                                      getDataCell(0, 45),
                                      getDataCell(0, 45),
                                      getDataCell(0, 45),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.redAccent.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Athlete")),
                                      getDataCell(46, 60),
                                      getDataCell(46, 59),
                                      getDataCell(46, 59),
                                      getDataCell(46, 60),
                                      getDataCell(46, 59),
                                      getDataCell(46, 59),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.purple.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Excellent")),
                                      getDataCell(61, 65),
                                      getDataCell(60, 64),
                                      getDataCell(60, 64),
                                      getDataCell(61, 65),
                                      getDataCell(60, 64),
                                      getDataCell(60, 64),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.blue.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Great")),
                                      getDataCell(66, 69),
                                      getDataCell(65, 68),
                                      getDataCell(65, 69),
                                      getDataCell(66, 69),
                                      getDataCell(65, 68),
                                      getDataCell(65, 68),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.cyan.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Good")),
                                      getDataCell(70, 73),
                                      getDataCell(69, 72),
                                      getDataCell(70, 73),
                                      getDataCell(70, 73),
                                      getDataCell(69, 73),
                                      getDataCell(69, 72),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.lightGreen.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Average")),
                                      getDataCell(74, 78),
                                      getDataCell(73, 76),
                                      getDataCell(74, 78),
                                      getDataCell(74, 77),
                                      getDataCell(74, 77),
                                      getDataCell(73, 76),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.yellow.withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Below Average")),
                                      getDataCell(79, 84),
                                      getDataCell(77, 82),
                                      getDataCell(79, 84),
                                      getDataCell(78, 83),
                                      getDataCell(78, 83),
                                      getDataCell(77, 84),
                                    ],
                                    color: MaterialStateProperty.all(Colors
                                        .deepOrangeAccent
                                        .withOpacity(0.6))),
                                DataRow(
                                    cells: [
                                      const DataCell(Text("Poor")),
                                      getDataCell(85, 0),
                                      getDataCell(83, 0),
                                      getDataCell(85, 0),
                                      getDataCell(84, 0),
                                      getDataCell(84, 0),
                                      getDataCell(85, 0),
                                    ],
                                    color: MaterialStateProperty.all(
                                        Colors.red.withOpacity(0.6))),
                              ],
                              dataTextStyle: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              columns: const [
                                DataColumn(label: Text("Age")),
                                DataColumn(label: Text('18-25 yrs')),
                                DataColumn(label: Text('26-35 yrs')),
                                DataColumn(label: Text('36-45 yrs')),
                                DataColumn(label: Text('46-55 yrs')),
                                DataColumn(label: Text('56-65 yrs')),
                                DataColumn(label: Text('65+ yrs')),
                              ],
                              showBottomBorder: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataCell getDataCell(int start, int end) {
    if (end == 0) end = 456789;
    TextStyle? textStyle;
    if (widget.result >= start && widget.result <= end) {
      textStyle = const TextStyle(
          fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);
    }

    String label = '$start-$end';
    if (end == 456789) {
      label = '$start+';
    } else if (start == 0) {
      label = '< $end';
    }
    return DataCell(Text(label, style: textStyle));
  }
}
