import 'package:flutter/material.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'generic_text_widget.dart';

class LanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final flag = L10n.getLanguageName(locale);

    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 50,
        child: GenericTextWidget(
          flag,
        ),
      ),
    );
  }
}

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('en');

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale,
        icon: Container(width: 12),
        items: L10n.getAllLanguagesLocale().map((locale) {
            final flag = L10n.getLanguageName(locale);
            return DropdownMenuItem(
              child: Center(
                child: GenericTextWidget(
                  flag,
                ),
              ),
              value: locale,
              onTap: () {
                final provider = Provider.of<LocaleProvider>(context, listen: false);
                provider.setLocale(locale);
              },
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
