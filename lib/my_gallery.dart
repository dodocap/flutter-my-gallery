import 'dart:async';

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
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    _loadImages();

    super.initState();
  }

  Future<void> _loadImages() async {
    _imageFileList = await _imagePicker.pickMultiImage();

    if (_imageFileList != null) {
      Timer.periodic(const Duration(seconds: 5), (timer) {
        _currentPage++;

        if (_currentPage > _imageFileList!.length - 1) {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      });
    }

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
          : PageView(
              controller: _pageController,
              children: _imageFileList!.map((image) {
                return FutureBuilder(
                    future: image.readAsBytes(),
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      if (data == null || snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Image.memory(
                        data,
                        width: double.infinity,
                      );
                    });
              }).toList(),
            ),
    );
  }
}
