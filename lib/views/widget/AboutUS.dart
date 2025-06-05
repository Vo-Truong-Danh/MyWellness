import 'package:flutter/material.dart';
class AboutAppDialog extends StatefulWidget {
  const AboutAppDialog({super.key});

  @override
  State<AboutAppDialog> createState() => _AboutAppDialogState();
}

class _AboutAppDialogState extends State<AboutAppDialog> {
  String _appVersion = "1.0.0";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    // Để sử dụng PackageInfo, bạn cần thêm package_info_plus vào pubspec.yaml
    // và import 'package:package_info_plus/package_info_plus.dart';
    // try {
    //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //   if (mounted) {
    //     setState(() {
    //       _appVersion = packageInfo.version;
    //     });
    //   }
    // } catch (e) {
    //   print("Lỗi không thể lấy phiên bản ứng dụng: $e");
    //   if (mounted) { setState(() { _appVersion = "N/A"; }); }
    // }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 6.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary, // Màu chủ đạo
        ),
      ),
    );
  }

  Widget _buildParagraph(BuildContext context, String text, {TextAlign textAlign = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[800]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.white,
      // Sử dụng title là Text thay vì Image cho dialog "About Us"
      titlePadding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.primary, size: 28),
          const SizedBox(width: 10),
          const Text(
            'Về MyWellness',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      // Đặt chiều cao cố định cho content và cho phép cuộn
      content: SizedBox(
        width: double.maxFinite, // Chiếm tối đa chiều rộng dialog cho phép
        height: 300, // Chiều cao cố định cho vùng nội dung, bạn có thể điều chỉnh
        child: SingleChildScrollView( // Cho phép cuộn nếu nội dung dài
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  "Phiên bản $_appVersion",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
              const Divider(height: 24, thickness: 0.5),

              _buildSectionTitle(context, 'Sứ Mệnh'),
              _buildParagraph(context,
                  'MyWellness đồng hành cùng bạn trên hành trình chăm sóc và nâng cao sức khỏe mỗi ngày, hướng tới một cuộc sống khỏe mạnh và hạnh phúc hơn.'),

              _buildSectionTitle(context, 'Tính Năng Chính'),
              _buildParagraph(context, '• Theo dõi chỉ số sức khỏe (nhịp tim, cân nặng, Kcal).\n'
                  '• Nhật ký dinh dưỡng & luyện tập.\n'
                  '• Xây dựng các thói quen lành mạnh.'),

              _buildSectionTitle(context, 'Liên Hệ & Góp Ý'),
              _buildParagraph(context,
                  'Mọi thắc mắc và đóng góp xin gửi về email: support@mywellness.dev (địa chỉ email ví dụ).'),

              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Cảm ơn bạn đã sử dụng MyWellness!",
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[700]),
                ),
              )
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom( // Sửa lại cách lấy style
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary, // Màu nút từ theme
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)
          ),
          child: const Text('Đóng', style: TextStyle(fontSize: 15)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}