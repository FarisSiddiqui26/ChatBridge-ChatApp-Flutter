import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();

  // Removed Firebase Storage-related variables, as we are now using Cloudinary
  CloudStorageService();

  // Cloudinary upload function
  Future<String?> uploadUserImage(File _image) async {
    try {
      String cloudName = dotenv.env["CLOUDINARY_CLOUD_NAME"] ?? '';
      var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");
      var request = http.MultipartRequest("POST", uri);

      var fileBytes = await _image.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: _image.path.split("/").last,
      );

      request.files.add(multipartFile);
      request.fields['upload_preset'] = 'preset-for-file-upload';
      request.fields['resource_type'] = 'raw';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print(responseBody);
      if (response.statusCode == 200) {
        // Extract image URL from the response
        final Map<String, dynamic> responseData = responseBody.isNotEmpty ? await jsonDecode(responseBody) : {};
        return responseData['secure_url'];
      } else {
        print("Upload failed with status ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
