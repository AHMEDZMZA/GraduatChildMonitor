import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:io';

class ProfileAvatarSection extends StatelessWidget {
  final String imagePath;
  final String userName;
  final File? imageFile;
  final String? profileImageUrl;
  final bool showEditIcon;
  final int? loadedTimestamp;

  const ProfileAvatarSection({
    super.key,
    required this.imagePath,
    required this.userName,
    this.imageFile,
    this.profileImageUrl,
    this.showEditIcon = true,
    this.loadedTimestamp,
  });

  String _getFullUrl(String url) {
    String fullUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      // ApiConfig.baseUrl defaults to 'http://192.168.1.5:8086/api/'
      // We want 'http://192.168.1.5:8086/'
      String rootUrl = ApiConfig.baseUrl;
      if (rootUrl.endsWith('/api/')) {
        rootUrl = rootUrl.substring(0, rootUrl.length - 4);
      } else if (rootUrl.endsWith('/api')) {
        rootUrl = rootUrl.substring(0, rootUrl.length - 3);
      }
      
      if (url.startsWith('/')) {
        fullUrl = rootUrl + url.substring(1);
      } else {
        fullUrl = rootUrl + url;
      }
    }
    
    if (loadedTimestamp != null) {
      return '$fullUrl?v=$loadedTimestamp';
    }
    return fullUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 88.w,
              height: 88.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.lightGray,
              ),
              child: ClipOval(
                child: imageFile != null
                    ? Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      )
                    : (profileImageUrl != null && profileImageUrl!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: _getFullUrl(profileImageUrl!),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
              ),
            ),
            if (showEditIcon)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 22.w,
                  width: 22.w,
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorManager.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 14,
                    color: ColorManager.primaryBlue,
                  ),
                ),
              ),
          ],
        ),
        if (userName.isNotEmpty) ...[
          SizedBox(height: 12.h),
          CustomText(text: userName, style: AppTextStyles.nunito20w900Black),
        ],
      ],
    );
  }
}
