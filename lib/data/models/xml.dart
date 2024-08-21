import 'dart:developer';

class AreaData {
  final String id;
  final String name;
  final List<ParameterData> parameters;

  AreaData(this.id, this.name, this.parameters);

  @override
  String toString() {
    return 'AreaData(id: $id, name: $name, parameters: $parameters)';
  }
}


class ParameterData {
  final String id;
  final String description;
  final String type;
  final List<TimerangeData> timeranges;

  ParameterData(this.id, this.description, this.type, this.timeranges);

  @override
  String toString() {
    return 'ParameterData(id: $id, description: $description, type: $type, timeranges: $timeranges)';
  }
}

class TimerangeData {
  final String type;
  final String datetime;
  final List<ValueData> values;

  TimerangeData(this.type, this.datetime, this.values);

  @override
  String toString() {
    return 'TimerangeData(type: $type, datetime: $datetime, values: $values)';
  }
}

class ValueData {
  final String value;
  final String unit;

  ValueData(this.value, this.unit);

  @override
  String toString() {
    return 'ValueData(value: $value, unit: $unit)';
  }
}
