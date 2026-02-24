import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ItemFormWidget extends StatefulWidget {
  final Map<String, dynamic> initialValues;
  final String submitLabel;
  final ValueChanged<Map<String, dynamic>> onSubmit;
  final Future<String> Function(XFile file)? onUploadCover;

  const ItemFormWidget({
    super.key,
    required this.initialValues,
    required this.submitLabel,
    required this.onSubmit,
    this.onUploadCover,
  });

  @override
  State<ItemFormWidget> createState() => _ItemFormWidgetState();
}

class _ItemFormWidgetState extends State<ItemFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;

  XFile? _coverImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _formData = Map<String, dynamic>.from(widget.initialValues);
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_coverImage != null && widget.onUploadCover != null) {
        setState(() => _isUploading = true);
        try {
          final url = await widget.onUploadCover!(_coverImage!);
          _formData['cover'] = url;
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload cover: $e')),
            );
          }
          setState(() => _isUploading = false);
          return;
        }
        if (mounted) setState(() => _isUploading = false);
      }

      widget.onSubmit(_formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final magenta = theme.colorScheme.secondary;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        'TITLE',
                        'title',
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildTextField(
                        'AUTHOR',
                        'author',
                        isRequired: true,
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _buildTextField('TITLE', 'title', isRequired: true),
                  const SizedBox(height: 24),
                  _buildTextField('AUTHOR', 'author', isRequired: true),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Description
          _buildTextField(
            'DESCRIPTION',
            'description',
            maxLines: 4,
            isRequired: true,
          ),
          const SizedBox(height: 24),

          // Row 3: Category, Year, Format
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  children: [
                    Expanded(child: _buildCategoryDropdown()),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildTextField(
                        'YEAR',
                        'year',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTextField('FORMAT', 'format')),
                  ],
                );
              }
              return Column(
                children: [
                  _buildCategoryDropdown(),
                  const SizedBox(height: 24),
                  _buildTextField(
                    'YEAR',
                    'year',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField('FORMAT', 'format'),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Row 4: Publisher, Language, Reference
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  children: [
                    Expanded(child: _buildTextField('PUBLISHER', 'publisher')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTextField('LANGUAGE', 'language')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTextField('REFERENCE', 'reference')),
                  ],
                );
              }
              return Column(
                children: [
                  _buildTextField('PUBLISHER', 'publisher'),
                  const SizedBox(height: 24),
                  _buildTextField('LANGUAGE', 'language'),
                  const SizedBox(height: 24),
                  _buildTextField('REFERENCE', 'reference'),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Row 5: Tags and Topic
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    Expanded(child: _buildTagsField()),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTextField('TOPIC', 'topic')),
                  ],
                );
              }
              return Column(
                children: [
                  _buildTagsField(),
                  const SizedBox(height: 24),
                  _buildTextField('TOPIC', 'topic'),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Cover Image
          _buildCoverField(),
          const SizedBox(height: 24),

          // Mark Completed Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _formData['completed'] = !(_formData['completed'] ?? false);
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: _formData['completed'] == true
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.green,
                foregroundColor: _formData['completed'] == true
                    ? Colors.white
                    : Colors.black,
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              child: Text(
                _formData['completed'] == true
                    ? 'MARK UNCOMPLETED'
                    : 'MARK COMPLETED',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: magenta,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                widget.submitLabel.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    final magenta = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: magenta,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String mapKey, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          initialValue: _formData[mapKey]?.toString() ?? '',
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF18181B), // zinc-900
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
          onSaved: (value) {
            _formData[mapKey] = value;
          },
        ),
      ],
    );
  }

  // Tags array field wrapper around the exact same mapping
  Widget _buildTagsField() {
    String initialStr = '';
    if (_formData['tags'] is List) {
      initialStr = (_formData['tags'] as List).join(', ');
    } else {
      initialStr = _formData['tags']?.toString() ?? '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('TAGS'),
        TextFormField(
          initialValue: initialStr,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Comma separated tags...',
            hintStyle: const TextStyle(color: Colors.white30),
            filled: true,
            fillColor: const Color(0xFF18181B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          onSaved: (value) {
            if (value != null && value.trim().isNotEmpty) {
              _formData['tags'] = value
                  .split(',')
                  .map((e) => e.trim())
                  .toList();
            } else {
              _formData['tags'] = <String>[];
            }
          },
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('CATEGORY'),
        DropdownButtonFormField<String>(
          initialValue: _formData['category']?.toString(),
          dropdownColor: const Color(0xFF18181B),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF18181B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'books', child: Text('Books')),
            DropdownMenuItem(value: 'video', child: Text('Video')),
            DropdownMenuItem(value: 'videogames', child: Text('Videogames')),
            DropdownMenuItem(value: 'music', child: Text('Music')),
            DropdownMenuItem(value: 'comics', child: Text('Comics')),
            DropdownMenuItem(value: 'magazines', child: Text('Magazines')),
          ],
          onChanged: (val) {
            setState(() {
              _formData['category'] = val;
            });
          },
          onSaved: (val) {
            _formData['category'] = val;
          },
          validator: (value) => value == null ? 'Selection required' : null,
        ),
      ],
    );
  }

  Widget _buildCoverField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('COVER IMAGE'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _buildTextField('COVER URL (OR PICK IMAGE)', 'cover'),
            ),
            const SizedBox(width: 16),
            if (widget.onUploadCover != null)
              SizedBox(
                height: 56, // matches TextFormField default height roughly
                child: OutlinedButton.icon(
                  onPressed: _isUploading
                      ? null
                      : () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              _coverImage = pickedFile;
                              _formData['cover'] = 'Pending upload...';
                            });
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.image),
                  label: Text(_isUploading ? 'UPLOADING...' : 'PICK IMAGE'),
                ),
              ),
          ],
        ),
        if (_coverImage != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Selected file: ${_coverImage!.name}',
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
