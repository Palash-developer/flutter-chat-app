import 'package:image_picker/image_picker.dart';

class ImgService {
  static Future<XFile?> pickImage() async {
    final pickedImg = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImg == null) {
      return null;
    }
    return pickedImg;
  }
}
