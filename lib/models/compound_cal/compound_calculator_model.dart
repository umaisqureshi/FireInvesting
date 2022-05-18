class CompoundCalculatorModel{
  double initialInvestment;
  double interestRate;
  int yearToMonths;
  int months;
  int interval;
  double initialAmount;
  String name;

  @override
  String toString() {
    return 'CompoundCalculatorModel{name : $name, initialInvestment: $initialInvestment, interestRate: $interestRate, yearToMonths: $yearToMonths, months: $months, interval: $interval, initialAmount: $initialAmount}';
  }

  CompoundCalculatorModel.name({this.initialInvestment, this.interestRate,
      this.yearToMonths, this.name, this.months, this.interval, this.initialAmount});

  int get getTotalMonths => yearToMonths+months;
}