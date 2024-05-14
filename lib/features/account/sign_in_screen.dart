import 'package:admin_have_a_meal/features/qr/ticket_qr_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = "signIn";
  static const routeURL = "/";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _idController = TextEditingController();
  final FocusNode _idFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _pwFocusNode = FocusNode();

  bool _rememberMe = false;
  final bool _simpleLogin = false;
  bool _isSubmitted = true;

  // id 정규식
  final RegExp _idRegExp = RegExp(r'^\d{8}$');
  // 비밀번호 정규식
  final RegExp _passwordRegExp =
      RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$');

  String? _idErrorText; // 아이디 오류 메시지
  String? _passwordErrorText; // 비밀번호 오류 메시지

  void _validateIdStudentNumber(String value) {
    if (value.isEmpty) {
      setState(() {
        _idErrorText = '아이디를 입력하세요.';
      });
    } else if (!_idRegExp.hasMatch(value)) {
      setState(() {
        _idErrorText = '8자리 숫자를 입력하세요.';
      });
    } else {
      setState(() {
        _idErrorText = null; // 오류가 없을 경우 null로 설정
      });
      _checkSubmitted();
    }
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordErrorText = '비밀번호를 입력하세요.';
      });
    } else if (!_passwordRegExp.hasMatch(value)) {
      setState(() {
        _passwordErrorText = '영문자와 숫자, 특수기호를 포함한 8자 이상 입력하세요.';
      });
    } else {
      setState(() {
        _passwordErrorText = null; // 오류가 없을 경우 null로 설정
      });
      _checkSubmitted();
    }
  }

  void _checkSubmitted() {
    setState(() {
      _isSubmitted =
          (_idController.text.trim().isNotEmpty && _idErrorText == null) &&
              (_passwordController.text.trim().isNotEmpty &&
                  _passwordErrorText == null);
    });
  }

  void _handleLogin() async {
    // final url = Uri.parse("${HttpIp.httpIp}/marine/users/auth");
    // final headers = {'Content-Type': 'application/json'};
    // final data = {
    //   'userId': _idController.text.trim(),
    //   'password': _passwordController.text.trim(),
    // };
    // final response =
    //     await http.post(url, headers: headers, body: jsonEncode(data));

    // if (response.statusCode >= 200 && response.statusCode < 300) {

    // } else {
    //   if (!mounted) return;
    //   HttpIp.errorPrint(
    //     context: context,
    //     title: "통신 오류",
    //     message: response.body,
    //   );
    // }
    context.replaceNamed(TicketQrAuthScreen.routeName);
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _idFocusNode.dispose();
    _pwFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _idFocusNode.unfocus();
        _pwFocusNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade200,
                Colors.white,
                Colors.white,
                Colors.blue.shade200,
              ], // 시작과 끝 색상 지정
            ),
          ),
          child: Column(
            children: [
              const Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Have-A-Meal",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    const Gap(10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            // spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _idController,
                            focusNode: _idFocusNode,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.grey.shade600,
                              ),
                              labelText: '아이디',
                              counterText: '', // 글자수 제한 표시 없애기
                              errorText: _idErrorText, // 아이디 오류 메시지 표시
                              labelStyle: TextStyle(
                                color: _idErrorText == null
                                    ? Colors.black
                                    : Colors.red,
                              ),
                            ),
                            onChanged:
                                _validateIdStudentNumber, // 입력 값이 변경될 때마다 검증
                          ),
                          const Gap(10),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _pwFocusNode,
                            obscureText: true,
                            autofocus: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.grey.shade600,
                              ),
                              labelText: '비밀번호',
                              errorText: _passwordErrorText, // 비밀번호 오류 메시지 표시
                              labelStyle: TextStyle(
                                color: _passwordErrorText == null
                                    ? Colors.black
                                    : Colors.red,
                              ),
                            ),
                            onChanged: _validatePassword, // 입력 값이 변경될 때마다 검증
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox.adaptive(
                                      value: _rememberMe,
                                      activeColor: Colors.blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value!;
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_rememberMe) {
                                          _rememberMe = false;
                                        } else {
                                          _rememberMe = true;
                                        }
                                        setState(() {});
                                      },
                                      child: const Text('로그인 정보 저장'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          ElevatedButton(
                            style: const ButtonStyle(),
                            onPressed:
                                _isSubmitted ? () => _handleLogin() : null,
                            child: const Text('식권 인증 시작'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
