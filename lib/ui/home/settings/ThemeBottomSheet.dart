import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../Providers/SettingsProvider.dart';

class ThemeBottomSheet extends StatefulWidget {
  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(12),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {
                settingsProvider.changeTheme(ThemeMode.light);
              },
              child: settingsProvider.isDarkEnabled()
                  ? getUnselectedItem(AppLocalizations.of(context)!.light_theme)
                  : getSelectedItem(AppLocalizations.of(context)!.light_theme)),
          SizedBox(
            height: 10,
          ),
          InkWell(
              onTap: () {
                settingsProvider.changeTheme(ThemeMode.dark);
              },
              child: settingsProvider.isDarkEnabled()
                  ? getSelectedItem(AppLocalizations.of(context)!.dark_theme)
                  : getUnselectedItem(AppLocalizations.of(context)!.dark_theme))
        ],
      ),
    );
  }

  Widget getSelectedItem(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary)),
        Icon(
          Icons.check,
          color: Theme.of(context).colorScheme.primary,
        )
      ],
    );
  }

  Widget getUnselectedItem(String text) {
    return Row(
      children: [
        Text(text, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
