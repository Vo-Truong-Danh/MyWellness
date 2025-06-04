import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wellness/src/screens/authentication/LoginPage.dart';
// Import các màn hình cần thiết khác (ví dụ: EditProfileScreen, PrivacyPolicyScreen)
// import 'package:my_wellness/src/screens/settings/EditProfileScreen.dart';
// import 'package:my_wellness/src/screens/settings/PrivacyPolicyScreen.dart';


class AccountSetting extends StatefulWidget {
  @override
  _Account_SetState createState() => _Account_SetState();
}

class _Account_SetState extends State<AccountSetting> {
  bool _isLoading = false;
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .get();

        if (userDoc.exists) {
          _userData = userDoc.data() as Map<String, dynamic>;
        } else {
          // Xử lý trường hợp không tìm thấy tài liệu người dùng
          print('User document does not exist for UID: ${user?.uid}');
          _userData = {}; // Đặt lại dữ liệu nếu không tìm thấy
        }
      } else {
        print('User is not logged in.');
        _userData = {};
      }
    } catch (e) {
      print('Error loading user data: $e');
      // Hiển thị thông báo lỗi thân thiện hơn cho người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải dữ liệu người dùng. Vui lòng thử lại!')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng xuất thất bại. Vui lòng thử lại!')),
      );
    }
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Chưa cập nhật';
    DateTime date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  // Widget chung cho tiêu đề phần
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Widget chung cho các mục thông tin có thể nhấn
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            Icon(icon, color: Colors.teal, size: 30),
            if (showBadge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.black54, fontSize: 13),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        onTap: onTap,
      ),
    );
  }

  // Widget chung cho các mục thông tin chỉ hiển thị
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    String? unit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),
          if (unit != null)
            Text(
              ' $unit',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  // Widget chung cho các mục cài đặt
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: iconColor ?? Colors.teal, size: 30),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.black87,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: TextStyle(color: Colors.black54, fontSize: 13),
        )
            : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF30C9B7), // Màu nền xanh ngọc
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Nền trong suốt
        elevation: 0,
        title: Text(
          'Hồ sơ của tôi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light, // Đặt màu thanh trạng thái
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 4,
        ),
      )
          : SingleChildScrollView(
        physics: BouncingScrollPhysics(), // Hiệu ứng cuộn nảy
        child: Column(
          children: [
            // Phần hồ sơ người dùng (ở trên)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                bottom: 40, // Tăng khoảng cách dưới để tạo không gian
              ),
              child: Column(
                children: [
                  // Ảnh đại diện
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 65, // Tăng kích thước ảnh
                          backgroundColor: Colors.white,
                          backgroundImage: user?.photoURL != null && user!.photoURL!.isNotEmpty
                              ? NetworkImage(user!.photoURL!) as ImageProvider
                              : AssetImage('assets/images/brlogin.gif') as ImageProvider, // Đảm bảo đường dẫn đúng
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Material(
                          color: Colors.teal.shade700, // Màu teal đậm hơn
                          shape: CircleBorder(),
                          elevation: 4, // Tăng đổ bóng
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tính năng thay đổi ảnh đang phát triển')),
                              );
                              // TODO: Implement image picker and Firebase Storage upload
                            },
                            customBorder: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0), // Tăng padding
                              child: Icon(Icons.camera_alt, color: Colors.white, size: 22), // Tăng kích thước icon
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 25),

                  // Tên người dùng
                  Text(
                    user?.displayName ?? _userData['name'] ?? 'Người dùng',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26, // Tăng kích thước chữ
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  // Email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email_outlined, color: Colors.white70, size: 18),
                      SizedBox(width: 8),
                      Flexible( // Sử dụng Flexible để tránh tràn chữ
                        child: Text(
                          user?.email ?? _userData['email'] ?? 'Email chưa cập nhật',
                          overflow: TextOverflow.ellipsis, // Cắt bớt nếu quá dài
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Phần nội dung chính (card màu trắng)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 15, // Tăng blur
                    offset: Offset(0, -5), // Di chuyển đổ bóng lên trên
                  ),
                ],
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28), // Tăng padding tổng thể
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thông tin cá nhân
                    _buildSectionHeader('Thông tin cơ bản'),

                    _buildInfoCard(
                      icon: Icons.person_outline, // Thay đổi icon
                      title: 'Hồ sơ của tôi',
                      subtitle: 'Chỉnh sửa thông tin cá nhân',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tính năng chỉnh sửa hồ sơ đang phát triển')),
                        );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => EditProfileScreen(userData: _userData),
                        //   )
                        // ).then((_) => _loadUserData()); // Load lại dữ liệu khi quay về
                      },
                      showBadge: _userData['name'] == null || _userData['name'].isEmpty, // Hiện badge nếu thông tin chưa đầy đủ
                    ),
                    SizedBox(height: 10), // Khoảng cách giữa các card

                    _buildInfoItem(
                      icon: Icons.height, // Icon chiều cao
                      title: 'Chiều cao',
                      value: _userData['height'] != null ? '${_userData['height']}' : 'Chưa cập nhật',
                      unit: 'cm',
                    ),
                    Divider(height: 1, color: Colors.grey.shade200), // Đường phân cách
                    _buildInfoItem(
                      icon: Icons.line_weight, // Icon cân nặng
                      title: 'Cân nặng',
                      value: _userData['weight'] != null ? '${_userData['weight']}' : 'Chưa cập nhật',
                      unit: 'kg',
                    ),
                    Divider(height: 1, color: Colors.grey.shade200),
                    _buildInfoItem(
                      icon: Icons.calendar_today,
                      title: 'Ngày sinh',
                      value: _formatDate(_userData['dateOfBirth'] as Timestamp?),
                    ),
                    Divider(height: 1, color: Colors.grey.shade200),
                    _buildInfoItem(
                      icon: _userData['gender'] == 'Nam' ? Icons.male : (_userData['gender'] == 'Nữ' ? Icons.female : Icons.wc), // Icon giới tính
                      title: 'Giới tính',
                      value: _userData['gender'] ?? 'Chưa cập nhật',
                    ),

                    // ---
                    // Phần Cài đặt chung
                    _buildSectionHeader('Cài đặt chung'),
                    _buildSettingItem(
                      icon: Icons.lock_outline,
                      title: 'Bảo mật tài khoản',
                      subtitle: 'Thay đổi mật khẩu, quản lý phiên đăng nhập',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tính năng bảo mật đang phát triển')),
                        );
                        // TODO: Navigate to SecuritySettingsScreen
                      },
                    ),
                    _buildSettingItem(
                      icon: Icons.notifications_none,
                      title: 'Thông báo',
                      subtitle: 'Quản lý cài đặt thông báo',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tính năng thông báo đang phát triển')),
                        );
                        // TODO: Navigate to NotificationSettingsScreen
                      },
                    ),
                    _buildSettingItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Chính sách bảo mật',
                      subtitle: 'Tìm hiểu về cách chúng tôi bảo vệ dữ liệu của bạn',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tính năng chính sách bảo mật đang phát triển')),
                        );
                        // TODO: Navigate to PrivacyPolicyScreen
                      },
                    ),

                    // ---
                    // Phần Hỗ trợ và Đăng xuất
                    _buildSectionHeader('Hỗ trợ và Đăng xuất'),
                    _buildSettingItem(
                      icon: Icons.help_outline,
                      title: 'Trợ giúp & Phản hồi',
                      subtitle: 'Liên hệ hỗ trợ, gửi phản hồi',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tính năng trợ giúp đang phát triển')),
                        );
                        // TODO: Navigate to HelpAndFeedbackScreen
                      },
                    ),
                    _buildSettingItem(
                      icon: Icons.logout,
                      title: 'Đăng xuất',
                      subtitle: 'Thoát khỏi tài khoản của bạn',
                      onTap: logOut,
                      iconColor: Colors.redAccent, // Đổi màu icon đăng xuất
                      textColor: Colors.redAccent, // Đổi màu chữ đăng xuất
                    ),
                    SizedBox(height: 20), // Khoảng trống cuối cùng
                    Center(
                      child: Text(
                        'Phiên bản 1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}