import 'package:flutter/material.dart';

class AllSFPinCodes extends StatefulWidget {
  final List<Widget> pinCodes;
  final List<List<Color>> colors;

  const AllSFPinCodes(this.pinCodes, this.colors, {super.key});

  @override
  State<AllSFPinCodes> createState() => _AllSFPinCodesState(); // Change the return type here
  // _AllSFPinCodesState createState() => _AllSFPinCodesState();

  @override
  String toStringShort() => 'All';
}

class _AllSFPinCodesState extends State<AllSFPinCodes>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          ...widget.pinCodes.asMap().entries.map((item) {
            final fromColor = widget.colors[item.key + 1].first;
            return Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(color: fromColor.withValues(alpha: .4)),
              child: item.value,
            );
          }),
          const Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              autofillHints: [AutofillHints.oneTimeCode],
              decoration: InputDecoration(
                labelText: 'Standard TextField for Testing',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
