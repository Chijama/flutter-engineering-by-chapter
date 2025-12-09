import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void main() {
  // Initialize Flutter bindings first
  WidgetsFlutterBinding.ensureInitialized();

  // Then ensure semantics tree is built (useful for custom widgets & testing)
  SemanticsBinding.instance.ensureSemantics();

  runApp(const AccessibilityPlaygroundRoot());
}

class AccessibilityPlaygroundRoot extends StatefulWidget {
  const AccessibilityPlaygroundRoot({super.key});

  @override
  State<AccessibilityPlaygroundRoot> createState() =>
      _AccessibilityPlaygroundRootState();
}

class _AccessibilityPlaygroundRootState
    extends State<AccessibilityPlaygroundRoot> {
  bool _showSemanticsDebugger = false;

  void _toggleSemanticsDebugger(bool value) {
    setState(() => _showSemanticsDebugger = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chapter 21 Accessibility Playground',
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: _showSemanticsDebugger,
      home: AccessibilityPlaygroundPage(
        onToggleSemanticsDebugger: _toggleSemanticsDebugger,
        showSemanticsDebugger: _showSemanticsDebugger,
      ),
    );
  }
}

class AccessibilityPlaygroundPage extends StatefulWidget {
  const AccessibilityPlaygroundPage({
    super.key,
    this.onToggleSemanticsDebugger,
    this.showSemanticsDebugger = false,
  });

  final Function(bool)? onToggleSemanticsDebugger;
  final bool showSemanticsDebugger;

  @override
  State<AccessibilityPlaygroundPage> createState() =>
      _AccessibilityPlaygroundPageState();
}

class _AccessibilityPlaygroundPageState
    extends State<AccessibilityPlaygroundPage>
    with SingleTickerProviderStateMixin {
  bool _termsAccepted = false;
  double _sliderValue = 40;
  bool _reducedMotion = false;
  bool _itemMoved = false;
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Get initial reduced motion flag from platform
    final features =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    _reducedMotion = features.reduceMotion || features.disableAnimations;

    // Initialize animation controller with appropriate duration
    _controller = AnimationController(
      vsync: this,
      duration: _reducedMotion ? Duration.zero : const Duration(seconds: 1),
    );

    // Only start animation if motion is not reduced
    if (!_reducedMotion) {
      _controller.repeat(reverse: true);
    }

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Listen for system accessibility feature changes
    WidgetsBinding.instance.platformDispatcher.onAccessibilityFeaturesChanged =
        () {
          final newFeatures =
              WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
          final newReducedMotion =
              newFeatures.reduceMotion || newFeatures.disableAnimations;

          if (_reducedMotion != newReducedMotion) {
            setState(() {
              _reducedMotion = newReducedMotion;

              if (_reducedMotion) {
                // Stop animation and reset
                _controller.stop();
                _controller.value = 1.0; // Reset to normal scale
              } else {
                // Start animation
                _controller.duration = const Duration(seconds: 1);
                _controller.repeat(reverse: true);
              }
            });
          }
        };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _announce(String message) {
    SemanticsService.announce(
      message,
      TextDirection.ltr,
      assertiveness: Assertiveness.assertive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter 21 Accessibility Playground'),
        actions: [
          // Show semantics debugger toggle in app bar
          IconButton(
            icon: Icon(
              widget.showSemanticsDebugger
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            tooltip: widget.showSemanticsDebugger
                ? 'Hide Semantics'
                : 'Show Semantics',
            onPressed: () {
              widget.onToggleSemanticsDebugger?.call(
                !widget.showSemanticsDebugger,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =============================
              // Global Demo Controls
              // =============================
              _buildCard(
                context,
                title: 'Global Demo Controls',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Toggle the semantics debugger using the eye icon in the app bar.',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Reduced motion:'),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(_reducedMotion ? 'ON (system)' : 'OFF'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 1. Basic Semantics Widget
              // =============================
              _buildCard(
                context,
                title: '1. Semantics Widget with Icon',
                description:
                    'Icon button with semantic label for screen readers. '
                    'The liveRegion property makes it announce immediately.',
                child: Center(
                  child: Semantics(
                    label: 'Play Button',
                    button: true,
                    liveRegion: true,
                    child: IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Play button pressed')),
                        );
                        _announce('Play button pressed');
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 2. MergeSemantics Widget
              // =============================
              _buildCard(
                context,
                title: '2. MergeSemantics Widget',
                description:
                    'Combines multiple widgets into a single semantic node. '
                    'Screen readers will read: "Accept Terms, checkbox".',
                child: MergeSemantics(
                  child: Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() => _termsAccepted = value ?? false);
                        },
                      ),
                      const Text('Accept Terms'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 3. ExcludeSemantics Widget
              // =============================
              _buildCard(
                context,
                title: '3. ExcludeSemantics Widget',
                description:
                    'Excludes decorative widgets from the semantics tree. '
                    'Screen readers will skip this purely visual element.',
                child: Row(
                  children: [
                    Expanded(
                      child: ExcludeSemantics(
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.auto_awesome,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'This decorative box is excluded from semantics.',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 4. BlockSemantics Widget
              // =============================
              _buildCard(
                context,
                title: '4. BlockSemantics Widget',
                description:
                    'Blocks semantics of widgets behind modal dialogs. '
                    'Ensures focus stays on the important element.',
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BlockSemantics(
                            blocking: true,
                            child: AlertDialog(
                              title: const Text('Important'),
                              content: const Text(
                                'This dialog blocks semantics of widgets behind it.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Show Modal Dialog'),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 5. Tooltip Widget
              // =============================
              _buildCard(
                context,
                title: '5. Tooltip Widget',
                description:
                    'Provides additional information on hover/long-press. '
                    'excludeFromSemantics: false includes it for screen readers.',
                child: Center(
                  child: Tooltip(
                    excludeFromSemantics: false,
                    message: 'Tap to open settings',
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Settings opened')),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 6. TextButton Widget
              // =============================
              _buildCard(
                context,
                title: '6. TextButton with Semantic Label',
                description:
                    'TextButton automatically includes semantic labels. '
                    'isSemanticButton controls "button" announcements.',
                child: Center(
                  child: TextButton(
                    isSemanticButton: true,
                    key: Key('playButton'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form submitted')),
                      );
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 7. Slider Widget
              // =============================
              _buildCard(
                context,
                title: '7. Slider Widget Accessibility',
                description:
                    'Provides accessible slider with value indicators. '
                    'Screen readers announce current value and divisions.',
                child: Column(
                  children: [
                    Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: _sliderValue.round().toString(),
                      onChanged: (value) {
                        setState(() => _sliderValue = value);
                      },
                    ),
                    Center(
                      child: Text('Value: ${_sliderValue.toStringAsFixed(0)}'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 8. ListView with Semantics
              // =============================
              _buildCard(
                context,
                title: '8. ListView with Semantic Indexes',
                description:
                    'addSemanticIndexes provides item positions. '
                    'semanticChildCount helps screen readers announce total items.',
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    addSemanticIndexes: true,
                    semanticChildCount: 10,
                    itemCount: 10,
                    itemBuilder: (context, index) =>
                        ListTile(title: Text('Item ${index + 1}')),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 9. CustomScrollView Widget
              // =============================
              _buildCard(
                context,
                title: '9. CustomScrollView with Slivers',
                description:
                    'Supports Talkback/VoiceOver with scroll announcements. '
                    'Use IndexedSemantics for accurate semantic information.',
                child: SizedBox(
                  height: 200,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => IndexedSemantics(
                            index: index,
                            child: ListTile(
                              title: Text('Sliver Item ${index + 1}'),
                            ),
                          ),
                          childCount: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 10. Text.rich Widget
              // =============================
              _buildCard(
                context,
                title: '10. Text.rich() for Styled Text',
                description:
                    'Allows multiple text styles. Enhances readability '
                    'for important information with bold/emphasis.',
                child: const Text.rich(
                  TextSpan(
                    text: 'Do not forget to ',
                    children: [
                      TextSpan(
                        text: 'save',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' your work!'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 11. Readability - Font Selection
              // =============================
              _buildCard(
                context,
                title: '11. Readability - Clear Fonts',
                description:
                    'Use clear, readable fonts like Roboto. '
                    'Standard fonts are preferred for accessibility.',
                child: const Text(
                  'This text uses the Roboto font for maximum readability.',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 12. High Contrast Text
              // =============================
              _buildCard(
                context,
                title: '12. High Contrast Text',
                description:
                    'Ensures text is legible with sufficient contrast ratio. '
                    'WCAG recommends 4.5:1 for normal text.',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.black,
                  child: const Text(
                    'High contrast white text on black background',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 13. Dynamic Font Sizing
              // =============================
              _buildCard(
                context,
                title: '13. Dynamic Font Sizing',
                description:
                    'Text automatically adapts to user\'s system font size. '
                    'Try changing text size in device settings.',
                child: Text(
                  'This text scales with system font size settings.',
                  style: TextStyle(fontSize: 16 * textScaler.scale(1.0)),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 14. Semantic Labels for Icons
              // =============================
              _buildCard(
                context,
                title: '14. Semantic Labels for Icons',
                description:
                    'Non-textual elements need descriptive labels. '
                    'Screen readers can\'t interpret icons without labels.',
                child: Center(
                  child: Semantics(
                    label: 'Settings Icon',
                    child: const Icon(Icons.settings, size: 40),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 15. Flexible Text - Wrap Widget
              // =============================
              _buildCard(
                context,
                title: '15. Constrained Text with Flexible',
                description:
                    'Flexible allows text to wrap and adjust to available space. '
                    'Prevents overflow when font size increases.',
                child: Row(
                  children: [
                    Flexible(
                      child: const Text(
                        'This is a very long text that might need to wrap '
                        'or adjust based on available space and font size settings.',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 16. Focus Traversal Order
              // =============================
              _buildCard(
                context,
                title: '16. Screen Reader Order with sortKey',
                description:
                    'Control reading order with sortKey. '
                    'Visual order can differ from semantic order.',
                child: Column(
                  children: [
                    Semantics(
                      sortKey: const OrdinalSortKey(2),
                      child: const TextField(
                        decoration: InputDecoration(
                          labelText: 'Second in screen reader order',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Semantics(
                      sortKey: const OrdinalSortKey(1),
                      child: const TextField(
                        decoration: InputDecoration(
                          labelText: 'First in screen reader order',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 17. Custom Semantics Actions
              // =============================
              _buildCard(
                context,
                title: '17. Custom Actions and Hints',
                description:
                    'Provide hints and custom actions to guide screen reader users. '
                    'Makes complex interactions more accessible.',
                child: Center(
                  child: Semantics(
                    label: 'Play',
                    hint: 'Double tap to play',
                    child: IconButton(
                      icon: const Icon(Icons.play_circle_filled, size: 50),
                      onPressed: () {
                        _announce('Playing audio');
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 18. Simple Gesture Detector
              // =============================
              _buildCard(
                context,
                title: '18. GestureDetector - Accessible Gestures',
                description:
                    'Simple gestures are more accessible than complex ones. '
                    'Provide alternatives for multi-finger gestures.',
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Single tap detected')),
                      );
                      _announce('Single tap detected');
                    },
                    onDoubleTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Double tap detected')),
                      );
                      _announce('Double tap detected');
                    },
                    child: Semantics(
                      label: 'Gesture demo area',
                      hint: 'Tap once or double tap to trigger feedback',
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blueAccent),
                        ),
                        child: const Text(
                          'Tap or double-tap here',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 19. Drag & Drop Alternative
              // =============================
              _buildCard(
                context,
                title: '19. Drag & Drop with Button Alternative',
                description:
                    'Not everyone can drag. Always provide button alternatives. '
                    'Makes the feature accessible to motor-impaired users.',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (!_itemMoved)
                          LongPressDraggable<String>(
                            data: 'Dragged!',
                            onDragCompleted: () {
                              setState(() => _itemMoved = true);
                              _announce('Item moved to target area');
                            },
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Dragging…',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'Long-press & drag',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue),
                                color: Colors.blue[50],
                              ),
                              child: const Text('Long-press & drag'),
                            ),
                          ),
                        if (!_itemMoved) const SizedBox(width: 8),
                        DragTarget<String>(
                          onAcceptWithDetails: (details) {
                            setState(() => _itemMoved = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Item dropped in target!'),
                              ),
                            );
                            _announce('Item dropped in target area');
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: candidateData.isNotEmpty
                                      ? Colors.green
                                      : Colors.grey,
                                  width: 2,
                                ),
                                color: _itemMoved
                                    ? Colors.green[100]
                                    : candidateData.isNotEmpty
                                    ? Colors.green[50]
                                    : Colors.grey[100],
                              ),
                              child: Text(
                                _itemMoved ? 'Item here!' : 'Drop here',
                                style: TextStyle(
                                  color: _itemMoved
                                      ? Colors.green[900]
                                      : Colors.grey[700],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _itemMoved
                              ? null
                              : () {
                                  setState(() => _itemMoved = true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Item moved using button alternative',
                                      ),
                                    ),
                                  );
                                  _announce('Item moved to target area');
                                },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Move without drag'),
                        ),
                        const SizedBox(width: 8),
                        if (_itemMoved)
                          IconButton(
                            onPressed: () {
                              setState(() => _itemMoved = false);
                            },
                            icon: const Icon(Icons.refresh),
                            tooltip: 'Reset',
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =============================
              // 20. Reduced Motion Animation
              // =============================
              _buildCard(
                context,
                title: '20. Reduced Motion Animations',
                description:
                    'Respects system reduce motion setting (reduceMotion || disableAnimations). '
                    'Animation stops completely when enabled. Check platform accessibility settings.',
                child: Column(
                  children: [
                    Center(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _reducedMotion ? 1.0 : _pulseAnimation.value,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _reducedMotion
                                    ? Colors.grey
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.accessibility_new,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _reducedMotion
                          ? '✓ Reduce motion ON → Animation stopped'
                          : '○ Reduce motion OFF → Pulsing animation active',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _reducedMotion
                            ? Colors.green[700]
                            : Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How to test:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.amber[900],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '• Android: Settings → Accessibility → Remove animations\n'
                            '• iOS: Settings → Accessibility → Motion → Reduce Motion',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.amber[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    String? description,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
