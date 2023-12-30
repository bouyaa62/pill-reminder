import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_pill/constants.dart';
import 'package:my_pill/global_bloc.dart';
import 'package:my_pill/models/medicine.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails(this.medicine, {Key? key}) : super(key: key);
  final Medicine medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            MainSection(medicine: widget.medicine),
            ExtendedSection(
              medicine: widget.medicine,
            ),
            const Spacer(),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kSecondaryColor,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  openAlertBox(context, _globalBloc);
                },
                child: Text("Delete",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: kScaffoldColor)),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kScaffoldColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 1.h),
          title: Text("Delete this reminder?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () {
                _globalBloc.removeMedicine(widget.medicine);
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text(
                "OK",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MainSection extends StatelessWidget {
  const MainSection({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;

  Hero makeIcon(double size) {
    if (medicine!.medicineType == 'bottle') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/bottle.svg',
          color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine!.medicineType == 'pill') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/pill.svg',
          color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine!.medicineType == 'syringe') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/syringe.svg',
          color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine!.medicineType == 'tablet') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/tablet.svg',
          color: kOtherColor,
          height: 7.h,
        ),
      );
    }
    return Hero(
      tag: medicine!.medicineName! + medicine!.medicineType!,
      child: Icon(
        Icons.error,
        color: kOtherColor,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        makeIcon(7.h),
        SizedBox(width: 2.w),
        Column(
          children: [
            Hero(
              tag: medicine!.medicineName!,
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                    fieldTitle: "Medicine Name",
                    fieldInfo: medicine!.medicineName!),
              ),
            ),
            MainInfoTab(
              fieldTitle: "Dosage",
              fieldInfo: medicine!.dosage == 0
                  ? 'Not specified'
                  : "${medicine!.dosage} mg",
            ),
          ],
        )
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab(
      {Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 10.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fieldTitle, style: Theme.of(context).textTheme.titleSmall),
            SizedBox(
              height: 0.3.h,
            ),
            Text(fieldInfo, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: "Medicine Type",
          fieldInfo: medicine!.medicineType! == 'None'
              ? 'Not specified'
              : medicine!.medicineType!,
        ),
        ExtendedInfoTab(
          fieldTitle: "Dose Interval",
          fieldInfo:
              "Every ${medicine!.interval} hours  |  ${medicine!.interval == 24 ? "One time a day" : "${(24 / medicine!.interval!).floor()} times a day"}",
        ),
        ExtendedInfoTab(
          fieldTitle: "Start Time",
          fieldInfo:
              "${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}",
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab(
      {Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              fieldTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: kTextColor),
            ),
          ),
          Text(
            fieldInfo,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: kSecondaryColor),
          ),
        ],
      ),
    );
  }
}
