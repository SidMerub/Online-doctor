import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation_app/utils/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../utils/colors.dart';


class AppointmentScreen extends StatefulWidget {
  final String patientId; // Define the patientId parameter

  const AppointmentScreen({required this.patientId, Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool isAppointmentSubmitted = false;
  @override
  Widget build(BuildContext context) {
    // Use the provider to get the state
    var appointmentStateProvider = Provider.of<AppointmentScreenStateNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context, appointmentStateProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor:  AppColors.deepLimeGreen,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectTime(context, appointmentStateProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor:  AppColors.deepLimeGreen,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Select Time'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: appointmentStateProvider.enableReminder,
                  onChanged: (value) {
                    appointmentStateProvider.enableReminder = value ?? false;
                    appointmentStateProvider.notifyListeners();
                  },
                ),
                const Text('Enable Reminder'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isAppointmentSubmitted
                  ? null
                  : () {

                  _submitAppointment(appointmentStateProvider);},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepLimeGreen,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text( 'Submit'),

            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, AppointmentScreenStateNotifier provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != provider.selectedDate) {
      provider.selectedDate = picked;
      provider.notifyListeners();
      provider.resetAppointmentSubmitted(); // Reset submission status
    }
  }

  Future<void> _selectTime(BuildContext context, AppointmentScreenStateNotifier provider) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != provider.selectedTime) {
      provider.selectedTime = picked;
      provider.notifyListeners();
      provider.resetAppointmentSubmitted(); // Reset submission status
    }
  }

  void _submitAppointment(AppointmentScreenStateNotifier provider) {
    if (provider.selectedDate != null && provider.selectedTime != null) {
      DateTime selectedDateTime = DateTime(
        provider.selectedDate.year,
        provider.selectedDate.month,
        provider.selectedDate.day,
        provider.selectedTime.hour,
        provider.selectedTime.minute,
      );
      // Convert DateTime to a Firestore Timestamp
      Timestamp appointmentTimestamp = Timestamp.fromDate(selectedDateTime);

      // Combine the appointment data with the patient data
      Map<String, dynamic> appointmentData = {
        'selectedDateTime': appointmentTimestamp,
        'enableReminder': provider.enableReminder,
        // Add other appointment data fields as needed
      };
      final patientCollection = FirebaseFirestore.instance.collection('patients');
      patientCollection.doc(widget.patientId).update(appointmentData).then((_) {
        provider.markAppointmentSubmitted();
        Utils().toasteMessage('Your Appointment is Submitted');


      }).catchError((error) {
        if (kDebugMode) {
         Utils().toasteMessage(error);
        }
      });


    }
  }
}