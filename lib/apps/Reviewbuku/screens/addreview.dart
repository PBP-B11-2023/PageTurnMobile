import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pageturn_mobile/apps/Reviewbuku/models/review.dart';
import 'package:pageturn_mobile/components/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewForm extends StatefulWidget {
  const ReviewForm({super.key});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}
class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _review = "";
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}