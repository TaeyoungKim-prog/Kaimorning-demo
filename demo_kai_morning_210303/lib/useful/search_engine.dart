class SearchEngine{
  static isContainSuchContent({String base, String key}){
    if(base == null || key == null){
      return false;
    }
    else{
      if (base.contains(key))
        return true;
      else return false;
    }
  }

  static isSameDay(DateTime day1, DateTime day2){

    int year = day1.year;
    int month = day1.month;
    int day = day1.day;

    if(day2.year == year && day2.month == month && day2.day == day)
      return true;
    else
      return false;
  }

}