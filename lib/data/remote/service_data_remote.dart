import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';


class ServiceDataRemote{
  final http.Client client;
  ServiceDataRemote({@required this.client});

  Future<ServiceInCourseEntity> getServiceInCourse() async{
    return null;
  }

}