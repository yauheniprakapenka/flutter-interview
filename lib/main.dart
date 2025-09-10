// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/qa_model.dart';
import 'questions/complexity.dart';
import 'questions/dart_interview.dart';
import 'questions/flutter_intreview.dart';
import 'questions/git_interview.dart';
import 'questions/oop_interview.dart';
import 'questions/pattern_interview.dart';
import 'questions/websocket.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    runZoned(() {});
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuestionScreen(
        qa: [
          ...complex,
          ...dartInterviewQuestions,
          ...flutterInterview,
          ...gitInterview,
          ...oopQuestions,
          ...patternQuestions,
          ...websocket,
        ],
      ),
    );
  }
}

class QuestionScreen extends StatefulWidget {
  final List<QA> qa;

  const QuestionScreen({required this.qa});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<QA> _availableQuestions = [];
  QA? _currentQuestion;

  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    _availableQuestions = List.from(widget.qa);
    _selectRandomQuestion();
  }

  void _selectRandomQuestion() {
    showAnswer = false;
    if (_availableQuestions.isEmpty) {
      setState(() {
        _currentQuestion = null;
      });
      return;
    }

    final randomIndex = Random().nextInt(_availableQuestions.length);
    setState(() {
      _currentQuestion = _availableQuestions.removeAt(randomIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вопросы')),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              // Действие при нажатии стрелки вправо
              _selectRandomQuestion();
            } else if (event.logicalKey == LogicalKeyboardKey.space) {
              if (showAnswer) {
                _selectRandomQuestion();
              } else {
                _showAnswer();
              }
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              _currentQuestion != null
                  ? Column(
                    children: [
                      // Счетчик вопросов
                      Text(
                        'Осталось вопросов: ${_availableQuestions.length}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      // Вопрос с кнопкой копирования
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _currentQuestion!.q,
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              copyToClipboard(_currentQuestion!.q);
                            },
                            icon: const Icon(Icons.copy, color: Colors.blue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Кнопки управления
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _showAnswer();
                            },
                            child: const Text('Показать ответ'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _selectRandomQuestion,
                            child: const Text('Далее'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Область для ответа
                      if (showAnswer)
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: SingleChildScrollView(
                              child: SelectableText(
                                _currentQuestion!.a,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                  : const Center(
                    child: Text(
                      'Вопросы закончились',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
        ),
      ),
    );
  }

  void _showAnswer() {
    setState(() {
      showAnswer = true;
    });
  }
}

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}
