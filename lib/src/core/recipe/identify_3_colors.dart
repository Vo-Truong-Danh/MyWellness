
import 'dart:ui';

import 'package:flutter/material.dart';


Color identify_3_colors(double GiaTriCanXet, List<double> KhoanAnToan, List<double> KhoanCanhBao, List<double> KhoanNguyHiem)
{
  if(GiaTriCanXet >= KhoanAnToan[0] && GiaTriCanXet <= KhoanAnToan[1])
    return Colors.green ;
  else if(GiaTriCanXet >= KhoanCanhBao[0] && GiaTriCanXet <= KhoanCanhBao[1])
    return Colors.orange ;
  else if(GiaTriCanXet >= KhoanNguyHiem[0] && GiaTriCanXet <= KhoanNguyHiem[1])
    return Colors.red ;
  else
    return Colors.white ;
}

Color identify_3_colors_exception(double GiaTriCanXet, List<double> KhoanAnToan, List<double> KhoanCanhBao, List<double> KhoanNguyHiem, List<double> KhoanMoRong, Color MauKhoanMoRong,Color MauTHConLai)
{
  if(GiaTriCanXet >= KhoanAnToan[0] && GiaTriCanXet <= KhoanAnToan[1])
    return Colors.green ;
  else if(GiaTriCanXet >= KhoanCanhBao[0] && GiaTriCanXet <= KhoanCanhBao[1])
    return Colors.orange ;
  else if(GiaTriCanXet >= KhoanNguyHiem[0] && GiaTriCanXet <= KhoanNguyHiem[1])
    return Colors.red ;
  else if(GiaTriCanXet >= KhoanMoRong[0] && GiaTriCanXet <= KhoanMoRong[1])
    return MauKhoanMoRong ;
  else
    return MauTHConLai ;
}
