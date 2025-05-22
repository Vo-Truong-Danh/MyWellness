import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Canhbaohr extends StatelessWidget {
  final double HR;

  const Canhbaohr({Key? key, required this.HR}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.white,
      title: Image(
        image: AssetImage('assets/images/warning.gif'),
        width: 50,
        height: 50,
      ),
      content: SizedBox(
        height: 280,
        width: double.maxFinite,
        child: Column(
          spacing: 20,
          children: [
            Text(
              'Cảnh Báo Nhịp Tim Hơi Cao!',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            Text(
              'Nhịp tim của bạn hiện tại là : ',
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              '${HR.toInt()} bpm',
              style: TextStyle(
                color: Colors.deepOrangeAccent,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            Text(
              'Đây là mức hơi cao khi nghỉ ngơi. Hãy cố gắng thư giãn và theo dõi thêm.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[720],
                height: 1.4,
              ),
            ),
            Text(
              'Nếu tình trạng này kéo dài hoặc bạn cảm thấy có triệu chứng bất thường (như đau ngực, khó thở, chóng mặt), vui lòng tham khảo ý kiến bác sĩ.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.deepOrangeAccent,
              foregroundColor: Colors.white,
            ),
            autofocus: true,
            child: Text('Đã hiểu'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}


class NguyHiemHR extends StatelessWidget {
  final double HR;

  const NguyHiemHR({Key? key, required this.HR}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.white,
      title: Image(
        image: AssetImage('assets/images/danger.gif'),
        width: 50,
        height: 50,
      ),
      content: SizedBox(
        height: 300,
        width: double.maxFinite,
        child: Column(
          spacing: 20,
          children: [
            Text(
              'Cảnh Báo Nhịp Tim Rất Cao!',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            Text(
              'Nhịp tim của bạn hiện tại là : ',
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              '${HR.toInt()} bpm',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            Text(
              'Đây là mức nhịp tim RẤT CAO và có thể tiềm ẩn nguy cơ cho sức khỏe của bạn, đặc biệt khi bạn đang nghỉ ngơi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[720],
                height: 1.4,
              ),
            ),
            Text(
              'Cần liên hệ hoặc đến gặp bác sĩ càng sớm càng tốt để kiểm tra. Xin đừng chủ quan. Sức khỏe của bạn là quan trọng nhất!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
            ),
            autofocus: true,
            child: Text('Đã hiểu'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

