import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/comnts_driver_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/comments_drive_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ComentsWirdgets extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  ComentsWirdgets({Key key,@required this.availablesRoutesEntity}) : super(key: key);

  @override
  _ComentsWirdgetsState createState() => _ComentsWirdgetsState();
}

class _ComentsWirdgetsState extends State<ComentsWirdgets> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CommentsDriveBloc>(context).add(GetCommentsDriveEvent(availablesRoutesEntity: widget.availablesRoutesEntity ));
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title:Text('Comentarios', style: TextStyle(fontSize: 18),),
        content: Container(
          height: 250,
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
        Row(
          children: [
            commentsDriver.imgUrl ==null?
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                  'https://us.123rf.com/450wm/thesomeday123/thesomeday1231712/thesomeday123171200009/91087331-icono-de-perfil-de-avatar-predeterminado-para-hombre-marcador-de-posición-de-foto-gris-vector-de-ilu.jpg?ver=6',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
              ),
            ):
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                  commentsDriver.imgUrl,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commentsDriver.passenger_name,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(commentsDriver.registered_at.day.toString() +'/'+ commentsDriver.registered_at.month.toString()+ '/' + commentsDriver.registered_at.year.toString(), style: TextStyle(fontSize: 10,color: Colors.grey ,fontStyle: FontStyle.italic)),
                    SizedBox(width: 10,),
                    RatingBar.builder(
                      initialRating: commentsDriver.start,
                      allowHalfRating: true,
                      itemSize: 18,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text( commentsDriver.comment ,style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic ),),
        ),
        Divider()
      ],
    );
  }
}