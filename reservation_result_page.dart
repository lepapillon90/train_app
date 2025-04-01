import 'package:flutter/material.dart';

class ReservationResultPage extends StatelessWidget {
  final String departureStation;
  final String arrivalStation;
  final String selectedSeats;
  final int totalPrice;
  final String selectedTime;
  final String bookedTime; // 예약 시간 추가

  const ReservationResultPage({
    super.key,
    required this.departureStation,
    required this.arrivalStation,
    required this.selectedSeats,
    required this.totalPrice,
    required this.selectedTime,
    required this.bookedTime,  // 예약 시간 받기
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 예매 내역'), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade700, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple, width: 2),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.departure_board, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(departureStation, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.arrow_forward, color: Colors.purple), // 수정된 부분
                      const SizedBox(width: 8),
                      Text(arrivalStation, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.schedule, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(selectedTime, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text('예약 시간', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(bookedTime, style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text('선택 좌석', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(selectedSeats, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text('총 결제 금액', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text('₩$totalPrice', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('예매 취소'),
                              content: const Text('정말 예매를 취소하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // 예매 취소 로직
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('예매 취소'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('다시 예매하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
