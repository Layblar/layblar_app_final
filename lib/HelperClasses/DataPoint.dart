class DataPoint {
  final DateTime time;
    final double energyConsumption;


  DataPoint(this.time, this.energyConsumption);
}



double getMaxEngeryConsumtion(List<DataPoint> dataPoints){

  double max = 0;;

  for (var p in dataPoints) {
    if(p.energyConsumption > max){
      max = p.energyConsumption;
    }
  }
  return max;

}