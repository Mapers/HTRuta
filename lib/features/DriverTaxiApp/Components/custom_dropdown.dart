  
import 'package:flutter/material.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:HTRuta/app/colors.dart';

class CustomDropdown extends StatefulWidget {

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;

  @override
  void initState() {
    actionKey = LabeledGlobalKey('serviceSelector');
    super.initState();
  }

  void findDropdownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
    print(height);
    print(width);
    print(xPosition);
    print(yPosition);
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition + height,
        // height: 4 * height + 40,
        child: DropDown(
          itemHeight: height,
          onItemSelected: (TypeServiceEnum selectedValue){
            BlocProvider.of<DriverServiceBloc>(context).add(ChangeDriverServiceEvent(type: selectedValue));
            print(selectedValue);
            setState(() {
              if (isDropdownOpened) {
                floatingDropdown.remove();
              } else {
                findDropdownData();
                floatingDropdown = _createFloatingDropdown();
                Overlay.of(context).insert(floatingDropdown);
              }
              isDropdownOpened = !isDropdownOpened;
            });
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 42,
      child: GestureDetector(
        key: actionKey,
        onTap: () {
          setState(() {
            if (isDropdownOpened) {
              floatingDropdown.remove();
            } else {
              findDropdownData();
              floatingDropdown = _createFloatingDropdown();
              Overlay.of(context).insert(floatingDropdown);
            }
            isDropdownOpened = !isDropdownOpened;
          });
        },
        child: BlocBuilder<DriverServiceBloc, DriverServiceState>(
          builder: (ctx, state){
            DataDriverServiceState data = state;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25),
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 10
                  )
                ]
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    getTextByTypeServiceEnum(data.typeService),
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  final double itemHeight;
  final Function(TypeServiceEnum) onItemSelected;
  const DropDown({Key key, this.itemHeight, this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipPath(
              clipper: ArrowClipper(),
              child: Container(
                height: 20,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[200]
                ),
              ),
            ),
          ],
        ),
        Material(
          elevation: 20,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              children: <Widget>[
                ...TypeServiceEnum.values.map((e) => DropDownItem(
                    item: e,
                    text: getTextByTypeServiceEnum(e),
                    route: getRouteByTypeServiceEnum(e),
                    iconData: Icons.add_circle_outline,
                    isSelected: false,
                    onTap: (TypeServiceEnum value) => onItemSelected(value)
                  ),
                ).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DropDownItem extends StatelessWidget {
  final TypeServiceEnum item;
  final String text;
  final IconData iconData;
  final bool isSelected;
  final String route;
  final bool isFirstItem;
  final bool isLastItem;
  final Function(TypeServiceEnum) onTap;

  const DropDownItem({Key key, this.item, this.text, this.route, this.iconData, this.isSelected = false, this.isFirstItem = false, this.isLastItem = false, this.onTap})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(item),
      title: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
      ),
      trailing: Image.asset(
        route,
        width: 50,
        height: 25,
      )
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}