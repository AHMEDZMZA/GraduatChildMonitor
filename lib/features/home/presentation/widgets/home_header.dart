import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../../core/network/api_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? childId;
  final String? profileImageUrl;
  final int? loadedTimestamp;
  final VoidCallback? onStatisticsTap;

  const HomeHeader({
    super.key,
    required this.userName,
    this.childId,
    this.profileImageUrl,
    this.loadedTimestamp,
    this.onStatisticsTap,
  });

  String _getFullUrl(String url) {
    String fullUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Hello, $userName',
              style: AppTextStyles.nunito30w900Black,
            ),
          ),
          if (childId != null)
            IconButton(
              onPressed: onStatisticsTap,
              icon: const Icon(
                Icons.bar_chart,
                color: ColorManager.primaryBlue,
              ),
            ),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.lightGray,
            ),
            child: ClipOval(
              child: (profileImageUrl != null && profileImageUrl!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: _getFullUrl(profileImageUrl!),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset(AppAssets.profileIcon, fit: BoxFit.cover),
                    )
                  : Image.asset(AppAssets.profileIcon, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
