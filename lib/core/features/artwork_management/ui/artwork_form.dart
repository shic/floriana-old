import 'package:flutter/material.dart';
import 'package:myguide/core/features/artwork_management/all.dart';
import 'package:myguide/core/features/author_management/domain.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/form/app_form.dart';
import 'package:myguide/ui/input/image.dart';
import 'package:myguide/ui/input/input.dart';
import 'package:myguide/ui/input/option.dart';
import 'package:myguide/ui/input/size.dart';
import 'package:myguide/ui/input/text.dart';
import 'package:myguide/ui/spacers.dart';

const _ffName = 'name';
const _ffDescription = 'description';
const _ffImages = 'images';
const _ffMaterial = 'material';
const _ffSize = 'size';
const _ffStatus = 'status';
const _ffAuthor = 'author';
const _ffPlace = 'place';
const _ffYear = 'year';
const _ffOpenSeaURL = 'open_sea_url';

extension ArtworkFormValue on FormValue {
  set name(String? n) => this[_ffName] = n;

  String? get name => this[_ffName];

  set description(String? d) => this[_ffDescription] = d;

  String? get description => this[_ffDescription];

  set images(List<String?> i) => this[_ffImages] = i;

  List<String?> get images => this[_ffImages]!;

  set material(String? m) => this[_ffMaterial] = m;

  String? get material => this[_ffMaterial];

  set size(ArtworkSize s) => this[_ffSize] = s;

  ArtworkSize get size => this[_ffSize]!;

  set status(ArtworkStatus s) => this[_ffStatus] = s;

  ArtworkStatus get status => this[_ffStatus]!;

  set author(String? a) => this[_ffAuthor] = a;

  String? get author => this[_ffAuthor];

  set place(String? p) => this[_ffPlace] = p;

  String? get place => this[_ffPlace];

  set year(String? y) => this[_ffYear] = y;

  String? get year => this[_ffYear];

  set openSeaURL(String? o) => this[_ffOpenSeaURL] = o;

  String? get openSeaURL => this[_ffOpenSeaURL];
}

class ArtworkForm extends StatefulWidget {
  ArtworkForm({
    super.key,
    required this.authors,
    String? name,
    String? description,
    List<String?>? images,
    String? material,
    ArtworkSize? size,
    ArtworkStatus? status,
    String? author,
    String? place,
    String? year,
    String? openSeaURL,
    this.onSubmit,
  }) : value = {
          _ffName: name,
          _ffDescription: description,
          _ffImages: List.generate(
            5,
            (index) {
              if (images == null) return null;
              if (images.length <= index) return null;
              return images[index];
            },
          ),
          _ffMaterial: material,
          _ffSize: size ?? const ArtworkSize(),
          _ffStatus: status ?? ArtworkStatus.invisible,
          _ffAuthor: author,
          _ffPlace: place,
          _ffYear: year,
          _ffOpenSeaURL: openSeaURL,
        };

  final Iterable<Author> authors;
  final FormValue value;
  final ValueChanged<FormValue>? onSubmit;

  @override
  State<ArtworkForm> createState() => _ArtworkFormState();
}

class _ArtworkFormState extends State<ArtworkForm> {
  late final GlobalKey<AppFormState> formKey;
  late FormValue value;

  @override
  void initState() {
    super.initState();
    value = Map.from(widget.value);
    formKey = GlobalKey();
  }

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
          initialValue: widget.value.name,
          hint: copy.artworkName,
          onChanged: (n) => value.name = n,
        ),
        AppDescriptionField(
          initialValue: widget.value.description,
          onChanged: (d) => value.description = d,
        ),
        AppCreationPlaceField(
          initialValue: widget.value.place,
          onChanged: (p) => value.place = p,
        ),
        AppCreationYearField(
          initialValue: widget.value.year,
          onChanged: (y) => value.year = y,
        ),
        AppArtworkSizeField(
          initialValue: widget.value.size,
          onChanged: (s) => value.size = s,
        ),
        OptionFormField(
          label: copy.visibilitySelect,
          initialValue: widget.value.status,
          onChanged: (s) => value.status = s,
          options: [
            Option(label: copy.visible, value: ArtworkStatus.visible),
            Option(label: copy.notVisible, value: ArtworkStatus.invisible),
          ],
        ),
        ScreenOptionFormField(
          label: copy.authorSelect,
          initialValue: widget.value.author,
          onChanged: (a) => value.author = a,
          options: widget.authors.map((author) {
            return Option(label: author.name, value: author.id);
          }).toList(),
        ),
        AppMaterialField(
          initialValue: widget.value.material,
          onChanged: (m) => value.material = m,
        ),
        AppURLField(
          initialValue: widget.value.openSeaURL,
          hint: copy.openSeaURL,
          onChanged: (o) => value.openSeaURL = o,
        ),
        Input(
          label: copy.images,
          child: Wrap(
            spacing: AppSize.m,
            runSpacing: AppSize.m,
            children: List.generate(
              widget.value.images.length,
              (i) {
                return AppImageFormField(
                  initialValue: widget.value.images[i],
                  onChanged: (url) => value.images[i] = url,
                );
              },
            ),
          ),
        ),
        ElevatedButton(
          onPressed: widget.onSubmit == null ? null : onSubmit,
          child: Text(copy.confirm),
        ),
      ],
    );
  }
}
