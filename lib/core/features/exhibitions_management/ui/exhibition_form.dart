import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:myguide/core/features/artwork_management/all.dart';
import 'package:myguide/core/features/exhibitions_management/domain.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/form/app_form.dart';
import 'package:myguide/ui/input/date.dart';
import 'package:myguide/ui/input/image.dart';
import 'package:myguide/ui/input/input.dart';
import 'package:myguide/ui/input/num.dart';
import 'package:myguide/ui/input/option.dart';
import 'package:myguide/ui/input/select.dart';
import 'package:myguide/ui/input/text.dart';

class ExhibitionFormValue extends Equatable {
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final List<String> artworkIds;
  final String? imageURL;
  final ExhibitionStatus exhibitionStatus;
  final DateTimeRange? dateTimeRange;
  final double? price;

  const ExhibitionFormValue({
    this.name = '',
    this.description = '',
    this.imageURL,
    this.address = '',
    this.phone = '',
    this.email = '',
    this.artworkIds = const [],
    this.exhibitionStatus = ExhibitionStatus.visible,
    this.dateTimeRange,
    this.price = 0,
  });

  ExhibitionFormValue copyWith({
    String? name,
    String? description,
    String? imageURL,
    String? address,
    String? phone,
    String? email,
    List<String>? artworkIds,
    ExhibitionStatus? exhibitionStatus,
    DateTimeRange? dateTimeRange,
    double? price,
  }) {
    return ExhibitionFormValue(
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imageURL: imageURL ?? this.imageURL,
      artworkIds: artworkIds ?? this.artworkIds,
      exhibitionStatus: exhibitionStatus ?? this.exhibitionStatus,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        artworkIds,
        address,
        phone,
        email,
        imageURL,
        exhibitionStatus,
        dateTimeRange,
        price,
      ];
}

typedef ExhibitionFormCallback = Function(ExhibitionFormValue);

class ExhibitionForm extends StatefulWidget {
  const ExhibitionForm({
    super.key,
    required this.artworks,
    this.initialValue = const ExhibitionFormValue(),
    this.onSubmit,
  });

  final Iterable<Artwork> artworks;
  final ExhibitionFormValue initialValue;
  final ExhibitionFormCallback? onSubmit;

  @override
  State<ExhibitionForm> createState() => _ExhibitionFormState();
}

class _ExhibitionFormState extends State<ExhibitionForm> {
  late final GlobalKey<AppFormState> formKey;
  late ExhibitionFormValue value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
    formKey = GlobalKey();
  }

  void updateName(String? n) => value = value.copyWith(name: n);

  void updateDescription(String? d) => value = value.copyWith(description: d);

  void updateAddress(String? a) => value = value.copyWith(address: a);

  void updatePhone(String? p) => value = value.copyWith(phone: p);

  void updateEmail(String? e) => value = value.copyWith(email: e);

  void updateImage(String? i) => value = value.copyWith(imageURL: i);

  void updatePrice(double p) => value = value.copyWith(price: p);

  void updateArtworks(Iterable<String> artworks) =>
      value = value.copyWith(artworkIds: artworks.toList());

  void updateStatus(ExhibitionStatus s) =>
      value = value.copyWith(exhibitionStatus: s);

  void updateDateTimeRange(DateTimeRange d) =>
      value = value.copyWith(dateTimeRange: d);

  void onSubmit() {
    if (formKey.currentState!.validate()) widget.onSubmit!(value);
  }

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppForm(
      key: formKey,
      children: [
        AppNameField(
          initialValue: widget.initialValue.name,
          hint: copy.exhibitionName,
          onChanged: updateName,
        ),
        AppDescriptionField(
          initialValue: widget.initialValue.description,
          onChanged: updateDescription,
        ),
        Input(
          label: copy.imageSelect,
          child: Align(
            alignment: Alignment.centerLeft,
            child: AppImageFormField(
              onChanged: updateImage,
              initialValue: widget.initialValue.imageURL,
            ),
          ),
        ),
        AppDateRangeFormField(
          initialValue: widget.initialValue.dateTimeRange,
          onChanged: updateDateTimeRange,
          hint: copy.select,
          description: copy.rangeSelect,
        ),
        ScreenSelectFormField(
          label: copy.artworkSelect,
          onChanged: updateArtworks,
          initialValue: widget.initialValue.artworkIds,
          options: widget.artworks.map((a) {
            return Option(label: a.name, value: a.id);
          }).toList(),
        ),
        AppNumFormField(
          hint: copy.costInEur,
          initialValue: widget.initialValue.price,
          onChanged: (n) {
            updatePrice(n as double? ?? 0);
          },
        ),
        OptionFormField(
          label: copy.visibilitySelect,
          initialValue: widget.initialValue.exhibitionStatus,
          onChanged: updateStatus,
          options: [
            Option(label: copy.visible, value: ExhibitionStatus.visible),
            Option(label: copy.notVisible, value: ExhibitionStatus.invisible),
          ],
        ),
        AppAddressField(
          initialValue: widget.initialValue.address,
          onChanged: updateAddress,
        ),
        AppEmailField(
          initialValue: widget.initialValue.email,
          onChanged: updateEmail,
          required: false,
        ),
        AppPhoneField(
          initialValue: widget.initialValue.phone,
          onChanged: updatePhone,
        ),
        ElevatedButton(
          onPressed: widget.onSubmit == null ? null : onSubmit,
          child: Text(copy.confirm),
        ),
      ],
    );
  }
}
