import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'payment_page.dart';

class SeatPage extends StatefulWidget {
  final String departureStation;
  final String arrivalStation;

  const SeatPage({
    super.key,
    required this.departureStation,
    required this.arrivalStation,
  });

  @override
  State<SeatPage> createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
  final List<List<bool>> seats = List.generate(20, (_) => List.generate(4, (_) => false));
  String selectedTime = '08:00';
  final List<String> availableTimes = ['08:00', '10:00', '12:00', '14:00', '16:00'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTimeSelectionDialog());
  }

  // ✅ 기능: 좌석 선택/해제 toggle
  void _toggleSeat(int row, int col) {
    setState(() {
      seats[row][col] = !seats[row][col];
    });
  }

  // ✅ 기능: 예매 확인 다이얼로그 표시 (선택된 좌석이 있을 경우)
  // - 선택된 좌석 리스트를 좌석: 행-열 형태로 구성하여 출력
  void _confirmBooking() {
    final selectedCount = seats.fold(0, (sum, row) => sum + row.where((seat) => seat).length);
    if (selectedCount == 0) return;
    
    final selectedSeatsText = seats.asMap().entries.expand((entry) {
      final row = entry.key;
      return entry.value.asMap().entries.where((e) => e.value).map((e) {
        final seatLabel = String.fromCharCode(65 + e.key); // A, B, C, D
        return '좌석: ${row + 1}-$seatLabel';
      });
    }).join('\n');

    final String bookedTime = DateTime.now().toString().substring(0, 16); // 예: yyyy-MM-dd HH:mm

    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('예매 하시겠습니까?'),
        content: Text(selectedSeatsText),
        actions: [
          CupertinoDialogAction(
            child: const Text('취소', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('확인', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    departureStation: widget.departureStation,
                    arrivalStation: widget.arrivalStation,
                    selectedSeats: selectedSeatsText,
                    selectedTime: selectedTime,
                    bookedTime: bookedTime,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTimeSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('기차 출발 시간을 선택하세요'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: availableTimes.map((time) {
                  final isSelected = time == selectedTime;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedTime = time);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.purple : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected ? Border.all(color: Colors.deepPurple, width: 2) : null,
                        boxShadow: isSelected
                            ? [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 4)]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule, size: 18, color: isSelected ? Colors.white : Colors.black),
                          const SizedBox(width: 6),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인', style: TextStyle(color: Colors.purple)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 공통 스타일: 출발역/도착역 텍스트 스타일 정의
    final stationStyle = const TextStyle(
      fontSize: 30, // 출발/도착역 텍스트 스타일
      fontWeight: FontWeight.bold,
      color: Colors.purple,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('좌석 선택'), // ❶ 앱바 타이틀 - 중앙 정렬, 스타일 없음
        centerTitle: true, // centerTitle 적용 확인
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.departureStation, style: stationStyle), // ❷ 출발역 스타일 (보라색, 30크기, 볼드)
                const SizedBox(width: 60),
                // ❹ 화살표 아이콘 - 아이콘 데이터 및 크기
                const Icon(Icons.arrow_circle_right_outlined, size: 30), // ❹ 아이콘 - 크기 30, 지정 아이콘
                const SizedBox(width: 60),
                Text(widget.arrivalStation, style: stationStyle), // ❸ 도착역 스타일 (보라색, 30크기, 볼드)
              ],
            ),
            const SizedBox(height: 20),
            // ✅ 기능 안내 문구 표시
            const Text('선택된 좌석은 보라색으로 표시됩니다.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // ✅ 좌석 상태 박스 UI 구성 (보라/회색) 및 상태 텍스트 설명
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ), // 좌석 상태 박스 - ❺ 크기/색상/모서리/간격
                const SizedBox(width: 4), // 상태 간 간격
                const Text('선택됨'), 
                const SizedBox(width: 20), // 상태 간 간격
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ), // 좌석 상태 박스
                const SizedBox(width: 4), // 상태 간 간격
                const Text('미선택됨'), 
              ],
            ),
            const SizedBox(height: 20),
            // const Text('기차 출발 시간 선택', style: TextStyle(fontSize: 16)),
            // const SizedBox(height: 8),
            // Wrap(...) 삭제
            // ❻ ABCD 좌석 열 레이블 - 각 좌석 컬럼 위에 정렬
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: Center(child: const Text('A', style: TextStyle(fontSize: 18))), // ❻ ABCD 레이블 - 각 50x50, 폰트 18
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 50,
                  child: Center(child: const Text('B', style: TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 50), // 가운데 좌석 번호 공간
                SizedBox(
                  width: 50,
                  child: Center(child: const Text('C', style: TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 50,
                  child: Center(child: const Text('D', style: TextStyle(fontSize: 18))),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // ❿ 리스트뷰 영역 - 화면 내에서 스크롤 되는 좌석 리스트 (총 20개 행)
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, rowIndex) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ❽ 좌석 위젯 - 크기 50x50, 색상 조건(보라/회색), 모서리 8, 간격 4
                          GestureDetector(
                            onTap: () => _toggleSeat(rowIndex, 0),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: seats[rowIndex][0] ? Colors.purple : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '',
                                    style: const TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _toggleSeat(rowIndex, 1),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: seats[rowIndex][1] ? Colors.purple : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '',
                                    style: const TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // ❼ 행번호 출력 - 각 행 가운데 50x50 컨테이너, 글자 크기 18
                          SizedBox(width: 50, height: 50, child: Center(child: Text('${rowIndex + 1}', style: const TextStyle(fontSize: 18)))),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _toggleSeat(rowIndex, 2),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: seats[rowIndex][2] ? Colors.purple : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '',
                                    style: const TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _toggleSeat(rowIndex, 3),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: seats[rowIndex][3] ? Colors.purple : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '',
                                    style: const TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // 앞뒤 간 간격
                    ],
                  );
                },
              ),
            ), // ❿ 리스트뷰 영역 - 스크롤 가능, 좌석 행 리스트
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '예매 하기', // ❾ 예매 버튼 - 색상/크기/모서리/글자 조건
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
