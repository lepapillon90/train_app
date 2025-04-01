import 'package:flutter/material.dart';

class StationListPage extends StatelessWidget {
  final String type;
  final String? excludeStation; // ✅ UX 향상: 출발역/도착역 중복 선택 방지를 위해 제외할 역 처리
  const StationListPage({super.key, required this.type, this.excludeStation});

  static const List<String> stations = [
    "수서", "동탄", "평택지제", "천안아산", "오송",
    "대전", "김천구미", "동대구", "경주", "울산", "부산"
  ];

  @override
  Widget build(BuildContext context) {
    final filteredStations = excludeStation == null
        ? stations.toSet().toList()
        : stations.where((s) => s != excludeStation).toSet().toList(); // ✅ UX 향상: 출발역/도착역 중복 선택 방지를 위해 제외할 역 처리

    return Scaffold(
      appBar: AppBar(
        title: Text(type),
        centerTitle: true,
      ), // ❶ 앱바 타이틀 - 별도 스타일 지정 없이 중앙 정렬만 적용
      body: ListView.separated(
        itemCount: filteredStations.length, // 변경된 부분
        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final station = filteredStations[index]; // 변경된 부분
          return Container( // ❹ 기차역 감싸는 영역 - 높이: 50, 아래 테두리 색상: Colors.grey[300]!
            height: 50,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: ListTile(
              title: Text(
                station,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ), // ❸ 기차역 이름 - 글자 크기: 18, 글자 두께: bold
              onTap: () {
                Navigator.pop(context, station);
              },
            ),
          );
        },
      ),
    );
  }
}
