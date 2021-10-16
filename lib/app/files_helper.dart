/* import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<FileWrapper> getImage() async {
  try{
    final FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if(result != null) {
      return FileWrapper(
        file: File(result.files.single.path),
        error: false
      );  
    } else {
      return FileWrapper(
        error: false
      );  
    }
  }catch(e){
    return FileWrapper(
      error: true
    );
  }
}
class FileWrapper{
  final File file;
  final bool error;
  FileWrapper({this.file, this.error});
} */