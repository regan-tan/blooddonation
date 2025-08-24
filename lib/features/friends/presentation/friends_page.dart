import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';
import '../../../core/widgets/dex_cards.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({super.key});

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  Map<String, dynamic>? _searchResult;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    // Run migration once when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runMigration();
    });
  }

  Future<void> _runMigration() async {
    try {
      final friendsRepository = ref.read(friendsRepositoryProvider);
      
      // Force refresh to clear any cache
      ref.invalidate(userFriendsProvider);
      
      // Run migration
      await friendsRepository.migrateFriendsFromCollectionToArray();
      
      // Force another refresh after migration
      ref.invalidate(userFriendsProvider);
      
      print('Migration completed successfully');
    } catch (e) {
      // Migration failed, but don't show error to user
      print('Migration failed: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUser() async {
    final searchText = _searchController.text.trim();
    if (searchText.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchError = null;
      _searchResult = null;
    });

    try {
      final friendsRepository = ref.read(friendsRepositoryProvider);
      
      // Try email search first
      var result = await friendsRepository.searchUserByEmail(searchText);
      
      // If email search fails, try display name search
      if (result == null) {
        final nameResults = await friendsRepository.searchUserByDisplayName(searchText);
        if (nameResults.isNotEmpty) {
          result = nameResults.first; // Take the first match
        }
      }
      
      setState(() {
        _searchResult = result;
        if (result == null) {
          _searchError = 'No user found with email "$searchText" or display name containing "$searchText"';
        }
      });
    } catch (e) {
      setState(() {
        _searchError = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _addFriend(Map<String, dynamic> userData) async {
    try {
      final friendsRepository = ref.read(friendsRepositoryProvider);
      await friendsRepository.addFriend(
        userData['uid'],
        userData['email'],
        userData['displayName'],
        userData['photoUrl'],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${userData['displayName']} added to your friends!'),
            backgroundColor: DexterTokens.dexGreen,
          ),
        );
        
        setState(() {
          _searchResult = null;
          _searchController.clear();
        });
        
        // Refresh friends list
        ref.invalidate(userFriendsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeFriend(String friendUid, String friendName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Friend'),
        content: Text('Are you sure you want to remove $friendName from your friends?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final friendsRepository = ref.read(friendsRepositoryProvider);
        await friendsRepository.removeFriend(friendUid);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$friendName removed from friends'),
              backgroundColor: Colors.orange,
            ),
          );
          
          // Refresh friends list
          ref.invalidate(userFriendsProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error removing friend: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(userFriendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        elevation: 0,
        actions: [
          // Debug button to force refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              print('Manual refresh triggered');
              ref.invalidate(userFriendsProvider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Friend Section
            DexCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Friend',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Find Friend',
                      hintText: 'Enter email or display name (e.g., "Regan Tan")',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      suffixIcon: _isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.person_search),
                              onPressed: _searchUser,
                            ),
                    ),
                    onSubmitted: (_) => _searchUser(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Result
                  if (_searchError != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _searchError!,
                              style: TextStyle(color: Colors.red[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  if (_searchResult != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: DexterTokens.dexGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: DexterTokens.dexGreen.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: DexterTokens.dexGreen,
                            backgroundImage: _searchResult!['photoUrl'] != null
                                ? NetworkImage(_searchResult!['photoUrl'])
                                : null,
                            child: _searchResult!['photoUrl'] == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _searchResult!['displayName'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  _searchResult!['email'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 36,
                            child: ElevatedButton(
                              onPressed: () => _addFriend(_searchResult!),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: const Text('Add'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Friends List Section
            const Text(
              'Your Friends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            friendsAsync.when(
              data: (friends) {
                if (friends.isEmpty) {
                  return DexCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: DexterTokens.dexGreen.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.group_add,
                              size: 48,
                              color: DexterTokens.dexGreen,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No Friends Yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Start building your blood donation network!\nSearch for friends by their email address.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.lightbulb_outline, color: Colors.blue[600]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Add friends to create group bookings and donate blood together!',
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: friends.map((friend) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DexCard(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: DexterTokens.dexGreen,
                              backgroundImage: friend.photoUrl != null
                                  ? NetworkImage(friend.photoUrl!)
                                  : null,
                              child: friend.photoUrl == null
                                  ? const Icon(Icons.person, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    friend.displayName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    friend.email,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'remove',
                                  child: Row(
                                    children: [
                                      Icon(Icons.person_remove, color: Colors.red[600]),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Remove Friend',
                                        style: TextStyle(color: Colors.red[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'remove') {
                                  _removeFriend(friend.uid, friend.displayName);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => DexCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(DexterTokens.dexGreen),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Loading your friends...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stack) => DexCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.wifi_off,
                          size: 48,
                          color: Colors.orange[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Connection Issue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Unable to load your friends list.\nPlease check your internet connection.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 44,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Refresh friends list
                            ref.invalidate(userFriendsProvider);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DexterTokens.dexGreen,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
