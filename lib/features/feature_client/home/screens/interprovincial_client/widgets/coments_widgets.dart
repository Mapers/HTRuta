import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/comnts_driver_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/comments_drive_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComentsWirdgets extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  ComentsWirdgets({Key key,@required this.availablesRoutesEntity}) : super(key: key);

  @override
  _ComentsWirdgetsState createState() => _ComentsWirdgetsState();
}

class _ComentsWirdgetsState extends State<ComentsWirdgets> {

  @override
  void initState() {
    //! Ver por que solo una ves entra al bloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CommentsDriveBloc>(context).add(GetCommentsDriveEvent(availablesRoutesEntity: widget.availablesRoutesEntity ));
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title:Text('Calificaciones del Chofer'),
        content: Container(
          height: 200,
          child: BlocBuilder<CommentsDriveBloc, CommentsDriveState>(
            builder: (context, state) {
              DataCommentsDriveState param = state;
              if(param.commentsDriver == null ){
                return Center(
                  child: CircularProgressIndicator() ,
                );
              }else if(param.commentsDriver.isEmpty){
                return Center(
                  child: Text('Sin comentarios') ,
                );
              }
              return ListView.builder(
              itemCount: param.commentsDriver.length,
              itemBuilder: (BuildContext context, int index) {
                return Estructure(
                  commentsDriver: param.commentsDriver[index],
                );
              },
            );
            }
          ),
        ),
        actions: [],
      ),
    );
  }
}

class Estructure extends StatelessWidget {
  final CommentsDriverEntity commentsDriver;
  const Estructure({Key key, this.commentsDriver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(commentsDriver.passenger_name,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text( commentsDriver.comment ,style: TextStyle(fontSize: 15),),
        ),
        Text(commentsDriver.registered_at.day.toString() +'/'+ commentsDriver.registered_at.month.toString()+ '/' + commentsDriver.registered_at.year.toString(), style: TextStyle(fontSize: 15,color: Colors.grey )),
      ],
    );
  }
}