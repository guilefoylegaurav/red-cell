List<String> check(String bg) {
  List<String> blood_groups = [
    'A+',
    'B+',
    'O+',
    'AB+',
    'A-',
    'B-',
    'O-',
    'AB-'
  ];
  if (bg == "O+" || bg == "O-") {
    return blood_groups;
  } else if (bg == "A+" || bg == "A-") {
    return ['A+', 'AB+', 'A-', 'AB-'];
  } else if (bg == "B+" || bg == "B-") {
    return ['B+', 'AB+', 'B-', 'AB-'];
  } else {
    return ['AB+', 'AB-'];
  }
}
