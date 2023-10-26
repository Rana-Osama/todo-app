import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../Providers/SettingsProvider.dart';
import 'LanguageBottomSheet..dart';
import 'ThemeBottomSheet.dart';

class SettingsTab extends StatefulWidget {
  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 64, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.theme,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          //  Text(AppLocalizations.of(context)!.theme),
          InkWell(
            onTap: () {
              showThemeBottomSheet();
            },
            child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(top: 7),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Theme.of(context).dividerColor, width: 1)),
                child: Text(
                  settingsProvider.isDarkEnabled()
                      ? AppLocalizations.of(context)!.dark_theme
                      : AppLocalizations.of(context)!.light_theme,
                  style: Theme.of(context).textTheme.titleMedium,
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Text(AppLocalizations.of(context)!.language,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          InkWell(
            onTap: () {
              showLanguageBottomSheet();
            },
            child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(top: 7),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Theme.of(context).dividerColor, width: 1)),
                child: Text(
                  settingsProvider.currentLocale == 'en'
                      ? 'English'
                      : 'العربية',
                  style: Theme.of(context).textTheme.titleMedium,
                )),
          ),
        ],
      ),
    );
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ThemeBottomSheet();
        });
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return LanguageBottomSheet();
        });
  }
}
