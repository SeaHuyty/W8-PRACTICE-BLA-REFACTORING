import 'package:blabla/ui/screens/home/viewmodel/ride_selection_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../utils/animations_util.dart' show AnimationUtils;
import '../../theme/theme.dart';
import 'widgets/ride_preference_modal.dart';
import 'widgets/rides_selection_header.dart';
import 'widgets/rides_selection_tile.dart';

///
///  The Ride Selection screen allows user to select a ride, once ride preferences have been defined.
///  The screen also allow user to:
///   -  re-define the ride preferences
///   -  activate some filters.
///
class RidesSelectionScreen extends StatefulWidget {
  const RidesSelectionScreen({super.key});

  @override
  State<RidesSelectionScreen> createState() => _RidesSelectionScreenState();
}

class _RidesSelectionScreenState extends State<RidesSelectionScreen> {
  void onBackTap() {
    Navigator.pop(context);
  }

  void onFilterPressed() {
    // TODO
  }

  void onRideSelected(Ride ride) {
    // Later
  }

  void onPreferencePressed() async {
    final RideSelectionViewModel rideSelectionAsync = context.read<RideSelectionViewModel>();
    // 1 - Navigate to the rides preference picker
    RidePreference? newPreference = await Navigator.of(context)
        .push<RidePreference>(
          AnimationUtils.createRightToLeftRoute(
            RidePreferenceModal(initialPreference: rideSelectionAsync.currentPreference),
          ),
        );

    if (newPreference != null) {
      rideSelectionAsync.selectPreference(newPreference);
    }
  }

  @override
  Widget build(BuildContext context) {
    final RideSelectionViewModel rideAsync = context.watch<RideSelectionViewModel>();
    final RidePreference? selectedRidePreference = rideAsync.currentPreference;

    if (selectedRidePreference == null) {
      return const Scaffold(
        body: Center(child: Text('No ride preference selected')),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            RideSelectionHeader(
              ridePreference: selectedRidePreference,
              onBackPressed: onBackTap,
              onFilterPressed: onFilterPressed,
              onPreferencePressed: onPreferencePressed,
            ),

            SizedBox(height: 100),

            Expanded(
              child: ListView.builder(
                itemCount: rideAsync.rides.length,
                itemBuilder: (ctx, index) => RideSelectionTile(
                  ride: rideAsync.rides[index],
                  onPressed: () => onRideSelected(rideAsync.rides[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
