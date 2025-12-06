import 'package:flutter/material.dart';
import 'package:twynk_frontend/models/snap.dart';

class VisibilityModal extends StatefulWidget {
  final SnapVisibility currentVisibility;
  final Function(SnapVisibility) onVisibilityChanged;

  const VisibilityModal({
    super.key,
    required this.currentVisibility,
    required this.onVisibilityChanged,
  });

  @override
  State<VisibilityModal> createState() => _VisibilityModalState();
}

class _VisibilityModalState extends State<VisibilityModal> {
  late SnapVisibility _selectedVisibility;

  @override
  void initState() {
    super.initState();
    _selectedVisibility = widget.currentVisibility;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;
    final isTablet = screenSize.width >= 768 && screenSize.width < 1024;
    
    // Define largura máxima baseada no tamanho da tela
    double modalWidth;
    double horizontalPadding;
    double verticalPadding;
    
    if (isMobile) {
      modalWidth = screenSize.width * 0.95;
      horizontalPadding = 16;
      verticalPadding = 16;
    } else if (isTablet) {
      modalWidth = screenSize.width * 0.8;
      horizontalPadding = 24;
      verticalPadding = 20;
    } else {
      modalWidth = 480; // Largura fixa para desktop
      horizontalPadding = 24;
      verticalPadding = 24;
    }

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 24,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: modalWidth,
          maxHeight: screenSize.height * 0.8,
          minWidth: isMobile ? screenSize.width * 0.9 : 320,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.cardColor,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      color: colorScheme.primary,
                      size: isMobile ? 20 : 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Configurar Visibilidade',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 12 : 16),
                Text(
                  'Escolha quem pode ver este snap:',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 16),
            ...SnapVisibility.values.map((visibility) {
              final isSelected = _selectedVisibility == visibility;
              return Padding(
                padding: EdgeInsets.only(bottom: isMobile ? 8 : 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        _selectedVisibility = visibility;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 16,
                        vertical: isMobile ? 10 : 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : theme.dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            visibility == SnapVisibility.public
                                ? Icons.public
                                : Icons.lock,
                            color: isSelected
                                ? colorScheme.primary
                                : theme.iconTheme.color,
                            size: isMobile ? 20 : 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  visibility.displayName,
                                  style: TextStyle(
                                    fontSize: isMobile ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? colorScheme.primary
                                        : theme.textTheme.titleMedium?.color,
                                  ),
                                ),
                                SizedBox(height: isMobile ? 2 : 4),
                                Text(
                                  visibility == SnapVisibility.public
                                      ? 'Qualquer pessoa pode ver este snap'
                                      : 'Apenas você pode ver este snap',
                                  style: TextStyle(
                                    fontSize: isMobile ? 12 : 14,
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: isMobile ? 20 : 24,
                            height: isMobile ? 20 : 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? colorScheme.primary
                                    : theme.dividerColor,
                                width: 2,
                              ),
                              color: isSelected
                                  ? colorScheme.primary
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: isMobile ? 14 : 16,
                                    color: colorScheme.onPrimary,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: isMobile ? 16 : 20),
            if (isMobile)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedVisibility != widget.currentVisibility
                          ? () {
                              widget.onVisibilityChanged(_selectedVisibility);
                              Navigator.of(context).pop();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _selectedVisibility != widget.currentVisibility
                        ? () {
                            widget.onVisibilityChanged(_selectedVisibility);
                            Navigator.of(context).pop();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      minimumSize: const Size(120, 48),
                    ),
                    child: Text(
                      'Salvar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}
