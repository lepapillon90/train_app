import 'package:flutter/material.dart';
import 'station_list_page.dart';
import 'seat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String departureStation = '선택';
  String arrivalStation = '선택';

  final BoxDecoration boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ); // #❸ 출발역/도착역 선택 박스 스타일 - 배경색을 흰색으로 설정하고, 모서리를 둥글게 처리하여 시각적으로 부드러운 느낌을 줌

  final TextStyle labelStyle = const TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ); // #❹ 출발역/도착역 라벨 텍스트 스타일 - 회색으로 설정하고, 굵은 글씨체 및 크기를 16으로 조정하여 가독성을 높임

  final TextStyle stationStyle = const TextStyle(fontSize: 40); // #❺ 선택된 역 텍스트 스타일 - 글자 크기를 40으로 설정하여 강조된 느낌을 줌

  // 출발역/도착역 선택 페이지로 이동하는 함수
  Future<void> _navigateToStationListPage(String type) async {
    final String? selectedStation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationListPage(
          type: type,
          excludeStation: type == '출발역' ? arrivalStation : departureStation,
        ),
      ),
    ); // ✅ UX 기능: 출발역과 도착역이 동일하지 않도록 선택된 상대역을 제외한 리스트 전달

    if (selectedStation?.isNotEmpty ?? false) {
      setState(() {
        if (type == '출발역') {
          departureStation = selectedStation!;
        } else {
          arrivalStation = selectedStation!;
        }
      });
    }
  }
  
  // 좌석 선택 페이지로 이동
  void _navigateToSeatPage() {
    // ✅ 조건 검사: 출발역과 도착역이 모두 선택된 경우에만 SeatPage로 이동
    if (departureStation != '선택' && arrivalStation != '선택') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SeatPage(
            departureStation: departureStation,
            arrivalStation: arrivalStation,
          ),
        ),
      );
    } else {
      // ✅ 예외 처리: 출발역 또는 도착역이 선택되지 않았을 경우 사용자에게 알림 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('출발역과 도착역을 모두 선택해주세요.')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기차 예매'),
        centerTitle: true, // #❶ AppBar 중앙정렬 - 제목을 중앙에 위치시키기 위해 centerTitle을 true로 설정
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // #❷ body 영역 스타일 - 배경색을 기본으로 하고, 모든 방향에 20.0의 패딩을 추가하여 내용이 여백 안에 위치하도록 설정
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 출발역/도착역 선택 영역
            Container(
              height: 200,
              decoration: boxDecoration,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 출발역 영역
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToStationListPage('출발역'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('출발역', style: labelStyle),
                          Text(departureStation, style: stationStyle),
                        ],
                      ),
                    ),
                  ),
                  // 세로선
                  Container(width: 2, height: 50, color: Colors.grey[400]), // #❻ 출발역과 도착역 사이의 세로선 - 너비 2, 높이 50의 회색 선으로 두 구역을 시각적으로 구분
                  // 도착역 영역
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToStationListPage('도착역'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('도착역', style: labelStyle),
                          Text(arrivalStation, style: stationStyle),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // #❼ 좌석 선택 버튼 위 간격 - 버튼과 선택 영역 사이에 20의 간격을 두어 시각적으로 분리
            // 좌석 선택 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToSeatPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ), // #❼ 좌석 선택 버튼 스타일 - 배경색을 보라색으로 설정하고, 수직 12, 수평 80의 패딩을 추가하며, 모서리를 둥글게 처리
                child: const Text(
                  '좌석 선택',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}