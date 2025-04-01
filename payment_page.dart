import 'package:flutter/material.dart';
import 'reservation_result_page.dart';

class PaymentPage extends StatelessWidget {
  final String departureStation;
  final String arrivalStation;
  final String selectedSeats;
  final String bookedTime; // 예약 시간 추가
  final String selectedTime; // 기차 출발 시간 추가

  PaymentPage({
    super.key,
    required this.departureStation,
    required this.arrivalStation,
    required this.selectedSeats,
    required this.selectedTime, // 기차 출발 시간 받기
    required this.bookedTime, // 예약 시간 받기
  });

  final List<String> stations = [
    "수서","동탄","평택지제","천안아산","오송","대전",
    "김천구미","동대구","경주","울산","부산"
  ];

  int calculateDistancePrice(String departure, String arrival) {
    int start = stations.indexOf(departure);
    int end = stations.indexOf(arrival);
    int distance = (end - start).abs();
    return 5000 + (distance * 5000);
  }

  @override
  Widget build(BuildContext context) {
    final selectedSeatList = selectedSeats.split('\n');
    final int seatPrice = calculateDistancePrice(departureStation, arrivalStation);
    final int totalPrice = seatPrice * selectedSeatList.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제하기'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('출발역', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(departureStation, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple)),
                  const SizedBox(height: 10),
                  Text('도착역', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(arrivalStation, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple)),
                  const SizedBox(height: 10),
                  Divider(),
                  const SizedBox(height: 10),
                  Text('선택 좌석', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(selectedSeats, style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Divider(),
                  const SizedBox(height: 10),
                  Text('기차 출발 시간', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)), // 기차 출발 시간 표시
                  Text(selectedTime, style: TextStyle(fontSize: 18)), // 기차 출발 시간 표시
                  const SizedBox(height: 10),
                  Text('좌석당 요금', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text('₩$seatPrice', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('총 결제 금액', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text('₩$totalPrice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationResultPage(
                        departureStation: departureStation,
                        arrivalStation: arrivalStation,
                        selectedSeats: selectedSeats,
                        totalPrice: totalPrice,
                        bookedTime: bookedTime,
                        selectedTime: selectedTime,  // 출발 시간 전달
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('결제하기', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
