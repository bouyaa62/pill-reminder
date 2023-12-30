import 'package:my_pill/models/erros.dart';
import 'package:my_pill/models/medecine_type.dart';
import 'package:rxdart/rxdart.dart';

class NewEntryBloc {
  BehaviorSubject<MedecineType>? _selectedMedecineType$;
  ValueStream<MedecineType>? get selectedMedecineType =>
      _selectedMedecineType$!.stream;

  BehaviorSubject<int>? _selectedInterval$;
  BehaviorSubject<int>? get selectedIntervals => _selectedInterval$;

  BehaviorSubject<String>? _selectedTimeOfDay$;
  BehaviorSubject<String>? get selectedTimeOfDay => _selectedTimeOfDay$;

  BehaviorSubject<EntryError>? _errorState$;
  BehaviorSubject<EntryError>? get errorState => _errorState$;

  NewEntryBloc() {
    _selectedMedecineType$ =
        BehaviorSubject<MedecineType>.seeded(MedecineType.none);

    _selectedTimeOfDay$ = BehaviorSubject<String>.seeded('none');
    _selectedInterval$ = BehaviorSubject<int>.seeded(0);
    _errorState$ = BehaviorSubject<EntryError>();
  }

  void dispose() {
    _selectedMedecineType$!.close();
    _selectedInterval$!.close();
    selectedTimeOfDay!.close();
  }

  void submitError(EntryError error) {
    _errorState$!.add(error);
  }

  void updateInterval(int interval) {
    _selectedInterval$!.add(interval);
  }

  void updateTime(String time) {
    _selectedTimeOfDay$!.add(time);
  }

  void updateSelectedMedecineType(MedecineType type) {
    MedecineType _tempType = _selectedMedecineType$!.value;
    if (type == _tempType) {
      _selectedMedecineType$!.add(MedecineType.none);
    } else {
      _selectedMedecineType$!.add(type);
    }
  }
}
