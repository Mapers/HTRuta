import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class UserIndicator extends StatefulWidget {
  @override
  _UserIndicatorState createState() => _UserIndicatorState();
}

class _UserIndicatorState extends State<UserIndicator> {
  final Session _session = Session();

  UserSession sessionLoaded;

  @override
  Widget build(BuildContext context) {
    return sessionLoaded == null ? FutureBuilder<UserSession>(
      future: _session.get(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            final data = snapshot.data;
            sessionLoaded = data;
            return Container(
              width: 50,
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    backgroundImage: sessionLoaded.imageUrl.isEmpty ? AssetImage('assets/image/empty_user_photo.png') : 
                    CachedNetworkImageProvider(
                      sessionLoaded.imageUrl,
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 1.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle
                    ),
                  )
                ],
              ),
            );
          }else{
            return Container();
          }
        }else{
          return Container();
        }
      }
    ) : Container(
      width: 50,
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.transparent,
            backgroundImage: sessionLoaded.imageUrl.isEmpty ? AssetImage('assets/image/empty_user_photo.png') : 
              CachedNetworkImageProvider(
                sessionLoaded.imageUrl,
              ),
            ),
          /* Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: sessionLoaded.imageUrl.isEmpty ? AssetImage('assets/image/empty_user_photo.png') : 
                CachedNetworkImageProvider(
                  sessionLoaded.imageUrl,
                ),
                fit: BoxFit.fitWidth
              )
            ),
          ), */
          Container(
            height: 20,
            width: 1.0,
            color: Theme.of(context).primaryColor,
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle
            ),
          )
        ],
      ),
    ); 
  }
}