import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Colors.blue 부분을 수정하여 테마의 색상을 바꿀수 있습니다
        primarySwatch: Colors.blue,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final wordPair = WordPair.random(); // 랜덤 단어쌍 변수
  final _list = <WordPair>[]; // 단어쌍을 저장할 list
  final TextStyle _textStyle = const TextStyle(fontSize: 18); // 단어쌍들의 TextStyle
  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.list), // List 아이콘 추가
            onPressed: _pushSaved, // 터치시 작동할 이벤트
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            // Odd 홀수 , i가 홀수이면 Divider 구분선 반환
            return Divider(thickness: 2); //thickness 구분선 굵기
          }
          final int index = i ~/ 2;
          if (index >= _list.length) {
            _list.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_list[index]);
        });
  }

  // _buildRow 함수에서 단어의 즐겨찾기 여부를 확인합니다
  Widget _buildRow(WordPair wordPair) {
    final alreadySaved = _saved.contains(wordPair);
    // contains 메소드는 찾고자하는 자료가 집합에있는지 여부(불리언 타입반환)
    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: _textStyle,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          // _saved 집합에 상호작용한? 단어가 있으면 제거 없으면 추가
          if (alreadySaved) {
            _saved.remove(wordPair);
          } else {
            _saved.add(wordPair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    // of(context) , builder , buildContext 는 이해를 못했음
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      // map 메소드는 반복되는 값을 다른형태로 변환하는 방법을 제공한다.
      final tiles = _saved.map((WordPair wordPair) => ListTile(
            title: Text(
              wordPair.asPascalCase,
              style: _textStyle,
            ),
          ));
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();
      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }
}
