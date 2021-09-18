  
import 'package:HTRuta/features/ClientTaxiApp/Provider/app_services_provider.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:provider/provider.dart';

class CustomDropdownClient extends StatefulWidget {

  @override
  _CustomDropdownClientState createState() => _CustomDropdownClientState();
}

class _CustomDropdownClientState extends State<CustomDropdownClient> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;

  @override
  void initState() {
    actionKey = LabeledGlobalKey('serviceClientSelector');
    super.initState();
  }

  void findDropdownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition + height,
        child: DropDown(
          itemHeight: height,
          onItemSelected: (TypeServiceEnum selectedValue){
            BlocProvider.of<ClientServiceBloc>(context).add(ChangeClientServiceEvent(type: selectedValue));
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
        child: BlocBuilder<ClientServiceBloc, ClientServiceState>(
          builder: (ctx, state){
            DataClientServiceState data = state;
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
  DropDown({Key key, this.itemHeight, this.onItemSelected}) : super(key: key);
  AppServicesProvider appServicesProvider;
  @override
  Widget build(BuildContext context) {
    appServicesProvider = Provider.of<AppServicesProvider>(context);
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
              children: loadOptions()
            ),
          ),
        ),
      ],
    );
  }
  List<Widget> loadOptions(){
    List<Widget> values = [];
    if(appServicesProvider.taxiAvailable){
      values.add(
        DropDownItem(
          item: TypeServiceEnum.taxi,
          text: getTextByTypeServiceEnum(TypeServiceEnum.taxi),
          route: getRouteByTypeServiceEnum(TypeServiceEnum.taxi),
          iconData: Icons.add_circle_outline,
          isSelected: false,
          onTap: (TypeServiceEnum value) => onItemSelected(value)
        )
      );
    } 
    if(appServicesProvider.interprovincialAvailable){
      values.add(
        DropDownItem(
          item: TypeServiceEnum.interprovincial,
          text: getTextByTypeServiceEnum(TypeServiceEnum.interprovincial),
          route: getRouteByTypeServiceEnum(TypeServiceEnum.interprovincial),
          iconData: Icons.add_circle_outline,
          isSelected: false,
          onTap: (TypeServiceEnum value) => onItemSelected(value)
        )
      );
    } 
    if(appServicesProvider.heavyLoadAvailable){
      values.add(
        DropDownItem(
          item: TypeServiceEnum.cargo,
          text: getTextByTypeServiceEnum(TypeServiceEnum.cargo),
          route: getRouteByTypeServiceEnum(TypeServiceEnum.cargo),
          iconData: Icons.add_circle_outline,
          isSelected: false,
          onTap: (TypeServiceEnum value) => onItemSelected(value)
        )
      );
    } 
    return values;
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