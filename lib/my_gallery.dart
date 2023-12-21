import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyGalleryScreen extends StatefulWidget {
  const MyGalleryScreen({super.key});

  @override
  State<MyGalleryScreen> createState() => _MyGalleryScreenState();
}

class _MyGalleryScreenState extends State<MyGalleryScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile>? _imageFileList;

  @override
  void initState() {
    _loadImages();

    super.initState();
  }

  Future<void> _loadImages() async {
    _imageFileList = await _imagePicker.pickMultiImage();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('전자액자'),
      ),
      body: _imageFileList == null
          ? const Center(child: Text('불러온 데이터가 없습니다'))
          : FutureBuilder(
              future: _imageFileList![0].readAsBytes(),
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null || snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Image.memory(
                  data,
                  width: double.infinity,
                );
              }),
    );
  }
}
