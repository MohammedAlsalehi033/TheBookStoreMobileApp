import 'package:cr_file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileManager {
  static Future download2(Dio dio, String url, File savePath) async {
    try {
      Response response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      var raf = savePath.openSync(mode: FileMode.write);
      // response.data is List<int> type
      await raf.writeFrom(response.data);
      await raf.close();

      // Explicitly wait for the file to be written
      await savePath.exists();
    } catch (e) {
      throw Error();
    }
  }



  static downLoadFile(String bookName, String URLpdf) async {
    var externalDir = await getExternalStorageDirectory();
    String fileName = '$bookName.pdf';
    String fullPath = '${externalDir!.path}/$fileName';

    // Ensure the directory exists before attempting to save the file
    if (!await Directory(externalDir.path).exists()) {
      await Directory(externalDir.path).create(recursive: true);
    }

    // Create an empty file if it doesn't exist
    File file = File(fullPath);
    if (!await file.exists()) {
      await file.create();
    }

    try {
      // Save the file using CRFileSaver to create an empty file
      final savedFilePath = await CRFileSaver.saveFile(
        fullPath,
        destinationFileName: fileName,
      );

      // Check if the file was saved successfully
      if (savedFilePath != null) {
        print('Empty file saved to: $savedFilePath');

        // Download the PDF content
        await FileManager.download2(
          Dio(),
          URLpdf,
          file,
        );

        // Check if the file size is greater than 0 after download
        if (await file.length() > 0) {
          print('File downloaded successfully');
          print(await file.length());
          // Add additional logic for success if needed
        } else {
          print('File download failed');
          // Handle the case where downloading the file fails
        }
      } else {
        print('File saving failed');
        // Handle the case where saving the empty file fails
      }
    } catch (e) {
      print('Error during file saving or download: $e');

      // Delete the temporary file in case of an error
      if (await file.exists()) {
        await file.delete();
        print('Temporary file deleted.');
      }
    }
  }

  static Future<bool> doesFileExist(String bookName) async {
    var externalDir = await getExternalStorageDirectory();
    String fullPath = '/storage/emulated/0/Download/${bookName}.pdf';
    File file = File(fullPath);
    print(fullPath);
    return await file.exists();
  }


}
