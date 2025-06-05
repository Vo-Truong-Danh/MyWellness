import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_wellness/views/app.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SignPageUp extends StatefulWidget {
  const SignPageUp({super.key});

  @override
  State<SignPageUp> createState() => _SignPageUpState();
}

class _SignPageUpState extends State<SignPageUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Thêm TextEditingController cho tên hiển thị
  final TextEditingController _displayNameController = TextEditingController();
  bool _isLoading = false;

  Future<void> createUser() async {
    FocusScope.of(context).unfocus();

    // Cập nhật kiểm tra: bao gồm cả displayName
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _displayNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập đầy đủ tên hiển thị, email và mật khẩu.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Tạo người dùng trong Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      User? user = userCredential.user;

      // Kiểm tra nếu user không null (tạo tài khoản Auth thành công)
      if (user != null) {
        // 2. (Tùy chọn) Cập nhật tên hiển thị trong Firebase Auth profile
        // Điều này giúp tên hiển thị có sẵn ngay trong đối tượng user của Firebase Auth
        await user.updateProfile(
          displayName: _displayNameController.text.trim(),
        );
        // Sau khi cập nhật profile, nên reload lại user để thông tin được cập nhật
        await user.reload();
        user =
            FirebaseAuth
                .instance
                .currentUser; // Lấy lại thông tin user mới nhất

        // 3. Lấy UID của người dùng
        String uid = user!.uid; // Đã kiểm tra user != null ở trên

        // 4. Chuẩn bị dữ liệu để lưu vào Firestore
        final userDataToSave = {
          'uid': uid,
          'email': user.email,
          'displayName':
              _displayNameController.text
                  .trim(), // Hoặc user.displayName nếu đã reload
          // ---- Thêm các thông tin mặc định khác cho MyWellness ----
          'height': null, // Đơn vị cm, người dùng có thể cập nhật sau
          'weight': null, // Đơn vị kg, người dùng có thể cập nhật sau
          'dateOfBirth':
              null, // Có thể lưu dưới dạng Timestamp hoặc String (ví dụ: "YYYY-MM-DD")
          'fitnessGoal': '', // Ví dụ: "Giảm cân", "Tăng cơ", "Duy trì sức khỏe"
          'dailyCalorieTarget': 2000, // Một giá trị mặc định
          // Bạn có thể thêm các trường khác như:
          // 'gender': null,
          // 'activityLevel': 'sedentary', // Mức độ hoạt động: sedentary, light, moderate, active
        };

        // 5. Lưu dữ liệu vào Firestore
        // Tham chiếu đến collection 'users' và document có ID là UID của người dùng
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(userDataToSave);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký thành công! Hồ sơ của bạn đã được tạo.'),
              backgroundColor: Colors.green, // Màu xanh cho thành công
            ),
          );
          // Điều hướng đến trang chính của ứng dụng
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyApp()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        // Trường hợp userCredential.user là null (hiếm khi xảy ra nếu createUserWithEmailAndPassword thành công mà không có lỗi)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Không thể lấy thông tin người dùng sau khi đăng ký.',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Đã có lỗi xảy ra trong quá trình đăng ký.';
      if (e.code == 'weak-password') {
        message = 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Địa chỉ email này đã được sử dụng bởi một tài khoản khác.';
      } else if (e.code == 'invalid-email') {
        message = 'Địa chỉ email không hợp lệ.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi không xác định: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose(); // Nhớ dispose controller mới
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/brlogin.gif",
                ), // Đảm bảo đường dẫn ảnh đúng
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.2)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Tham gia ngay',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Thêm TextField cho Tên hiển thị
                  TextField(
                    controller: _displayNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Tên hiển thị',
                      labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF30C9B7),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : createUser,
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Tạo tài khoản',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Đã có tài khoản? Đăng nhập',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
