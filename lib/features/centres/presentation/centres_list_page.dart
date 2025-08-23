import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';
import '../../../core/utils/singapore_time.dart';
import '../../../core/widgets/dex_enhanced_card.dart';
import '../../../core/widgets/dex_status_indicator.dart';
import '../../../core/widgets/dex_gradient_button.dart';
import '../../../core/widgets/dex_search_bar.dart';
import '../../../core/widgets/dex_floating_action_button.dart';
import '../../../core/widgets/dex_info_card.dart';
import '../domain/donation_centre.dart';

class CentresListPage extends ConsumerStatefulWidget {
  const CentresListPage({super.key});

  @override
  ConsumerState<CentresListPage> createState() => _CentresListPageState();
}

class _CentresListPageState extends ConsumerState<CentresListPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

     @override
   Widget build(BuildContext context) {
     // Set system UI overlay style
     SystemChrome.setSystemUIOverlayStyle(
       const SystemUiOverlayStyle(
         statusBarColor: Colors.transparent,
         statusBarIconBrightness: Brightness.dark,
         systemNavigationBarColor: Colors.white,
         systemNavigationBarIconBrightness: Brightness.dark,
       ),
     );
     
     final centresAsync = ref.watch(centresListProvider);

         return Scaffold(
       backgroundColor: DexterTokens.dexIvory.withOpacity(0.3),
              extendBodyBehindAppBar: false,
                       appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              '🩸 Blood Centres',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DexterTokens.dexInk,
              ),
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.98),
          elevation: 2,
          shadowColor: DexterTokens.dexGreen.withOpacity(0.1),
          toolbarHeight: 60,
        ),
                            body: SafeArea(
          child: Column(
            children: [
              // Search bar below AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: DexSearchBar(
                  controller: _searchController,
                  hintText: 'Search centres...',
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  onClear: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
              ),
              // Centres list
              Expanded(
            child: centresAsync.when(
              data: (centres) {
                final filteredCentres = centres.where((centre) {
                  if (_searchQuery.isEmpty) return true;
                  return centre.name.toLowerCase().contains(_searchQuery) ||
                         centre.address.toLowerCase().contains(_searchQuery) ||
                         centre.type.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredCentres.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(centresListProvider);
                  },
                  color: DexterTokens.dexGreen,
                  backgroundColor: DexterTokens.dexIvory,
                  strokeWidth: 3,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCentres.length,
                    itemBuilder: (context, index) {
                      final centre = filteredCentres[index];
                      return _buildCentreCard(context, centre);
                    },
                  ),
                );
              },
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
                     ),
         ],
                ),
       ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DexterTokens.dexIvory.withOpacity(0.4),
                  Colors.white.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
              border: Border.all(
                color: DexterTokens.dexLeaf.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              _searchQuery.isEmpty ? Icons.local_hospital_outlined : Icons.search_off,
              size: 90,
              color: DexterTokens.dexLeaf.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 28),
                     Text(
             _searchQuery.isEmpty 
                 ? 'No Blood Centres Available'
                 : 'No Centres Found',
             style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.bold,
               color: DexterTokens.dexInk,
               letterSpacing: 0.5,
             ),
             textAlign: TextAlign.center,
           ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: DexterTokens.dexIvory.withOpacity(0.3),
              borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
            ),
                         child: Text(
               _searchQuery.isEmpty
                   ? 'We\'re working on adding more donation centres to serve you better. Check back soon!'
                   : 'Try adjusting your search terms or browse all available centres.',
               style: TextStyle(
                 fontSize: 14,
                 color: DexterTokens.dexInk.withOpacity(0.7),
                 height: 1.4,
               ),
               textAlign: TextAlign.center,
             ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 28),
            DexGradientButton(
              text: 'Clear Search & Show All',
              icon: Icons.refresh,
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              isPrimary: false,
              height: 52,
            ),
          ] else ...[
            const SizedBox(height: 28),
            DexGradientButton(
              text: 'Refresh Page',
              icon: Icons.refresh,
              onPressed: () {
                ref.invalidate(centresListProvider);
              },
              height: 52,
            ),
          ],
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
    ).scale(
      begin: const Offset(0.7, 0.7),
      end: const Offset(1.0, 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DexterTokens.dexGreen.withOpacity(0.12),
                  DexterTokens.dexLeaf.withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
              border: Border.all(
                color: DexterTokens.dexGreen.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: SizedBox(
              width: 90,
              height: 90,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(DexterTokens.dexGreen),
              ),
            ),
          ),
          const SizedBox(height: 28),
                     Text(
             'Finding Blood Centres',
             style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.bold,
               color: DexterTokens.dexInk,
               letterSpacing: 0.5,
             ),
           ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: DexterTokens.dexIvory.withOpacity(0.4),
              borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
            ),
                         child: Text(
               'We\'re searching for the best donation centres near you...',
               style: TextStyle(
                 fontSize: 13,
                 color: DexterTokens.dexInk.withOpacity(0.7),
                 height: 1.3,
               ),
               textAlign: TextAlign.center,
             ),
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    ).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
            ),
            child: Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
                     Text(
             'Error loading centres',
             style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.w600,
               color: DexterTokens.dexInk,
             ),
           ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              borderRadius: BorderRadius.circular(DexterTokens.radiusSmall),
              border: Border.all(
                color: Colors.red.withOpacity(0.2),
                width: 1,
              ),
            ),
                         child: Text(
               error,
               textAlign: TextAlign.center,
               style: TextStyle(
                 color: Colors.red.withOpacity(0.8),
                 fontSize: 12,
               ),
             ),
          ),
          const SizedBox(height: 24),
          DexGradientButton(
            text: 'Retry',
            icon: Icons.refresh,
            onPressed: () {
              ref.invalidate(centresListProvider);
            },
            height: 48,
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    ).shake(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

     Widget _buildCentreCard(BuildContext context, dynamic centre) {
     // Beautiful centre card with enhanced UI

    return DexEnhancedCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () => context.push('/centres/${centre.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced header with icon and status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      DexterTokens.dexGreen.withOpacity(0.15),
                      DexterTokens.dexLeaf.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
                  border: Border.all(
                    color: DexterTokens.dexGreen.withOpacity(0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DexterTokens.dexGreen.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_hospital,
                  color: DexterTokens.dexGreen,
                  size: 30,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                         Text(
                       centre.name,
                       style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.bold,
                         color: DexterTokens.dexInk,
                         letterSpacing: 0.3,
                       ),
                     ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: centre.type == 'Blood Bank' 
                                ? DexterTokens.dexLeaf.withOpacity(0.12)
                                : DexterTokens.warning.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(DexterTokens.radiusSmall),
                            border: Border.all(
                              color: centre.type == 'Blood Bank' 
                                  ? DexterTokens.dexLeaf.withOpacity(0.35)
                                  : DexterTokens.warning.withOpacity(0.35),
                              width: 1.2,
                            ),
                          ),
                                                     child: Text(
                             centre.type,
                             style: TextStyle(
                               fontSize: 11,
                               color: centre.type == 'Blood Bank' 
                                   ? DexterTokens.dexLeaf
                                   : DexterTokens.warning,
                               fontWeight: FontWeight.w600,
                               letterSpacing: 0.2,
                             ),
                           ),
                        ),
                        const SizedBox(width: 14),
                                                 DexStatusIndicator(
                           isOpen: SingaporeTime.isCurrentlyOpen(centre.donationTypes['wholeBlood']['openingHours']),
                           label: SingaporeTime.isCurrentlyOpen(centre.donationTypes['wholeBlood']['openingHours']) ? 'Open' : 'Closed',
                           size: 22,
                         ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      DexterTokens.dexGreen.withOpacity(0.12),
                      DexterTokens.dexLeaf.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(DexterTokens.radiusSmall),
                  border: Border.all(
                    color: DexterTokens.dexGreen.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: DexterTokens.dexGreen,
                  size: 22,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Enhanced address section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DexterTokens.dexIvory.withOpacity(0.6),
                  Colors.white.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
              border: Border.all(
                color: DexterTokens.dexLeaf.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        DexterTokens.dexGreen.withOpacity(0.15),
                        DexterTokens.dexLeaf.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(DexterTokens.radiusSmall),
                    border: Border.all(
                      color: DexterTokens.dexGreen.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: DexterTokens.dexGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                                     child: Text(
                     centre.address,
                     style: TextStyle(
                       color: DexterTokens.dexInk.withOpacity(0.85),
                       fontSize: 13,
                       fontWeight: FontWeight.w500,
                       height: 1.3,
                     ),
                   ),
                ),
              ],
            ),
          ),
          
                     const SizedBox(height: 20),
          
          // Enhanced action buttons
          Row(
            children: [
                             Expanded(
                 child: DexGradientButton(
                   text: 'Details',
                   icon: Icons.info_outline,
                   onPressed: () => context.push('/centres/${centre.id}'),
                   isPrimary: false,
                   height: 52,
                 ),
               ),
               const SizedBox(width: 14),
               Expanded(
                 child: DexGradientButton(
                   text: 'Book',
                   icon: Icons.calendar_today,
                   onPressed: () => context.push('/centres/${centre.id}/book'),
                   height: 52,
                 ),
               ),
            ],
          ),
        ],
      ),
    );
  }
}
