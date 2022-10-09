class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}

class ChartData2 {
  ChartData2(this.x, this.y);
  final String x;
  final double y;
  @override
  String toString() {
    return "$x $y";
  }
}
