import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../services/product_service.dart';
import '../../models/event_model.dart';
import '../../models/product_model.dart';
import '../../utils/constants.dart';
import '../../widgets/event_card.dart';
import '../../widgets/product_card.dart';
import '../events/event_detail_screen.dart';
import '../admin/admin_panel_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _eventService = EventService();
  final _productService = ProductService();
  
  List<EventModel> _events = [];
  List<ProductModel> _featuredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final events = await _eventService.getEvents();
    final products = await _productService.getFeaturedProducts();
    
    setState(() {
      _events = events;
      _featuredProducts = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final currentUser = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.directions_run, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('달려라 방방'),
          ],
        ),
        actions: [
          if (currentUser?.isAdmin ?? false)
            IconButton(
              icon: Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
                );
              },
            ),
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                currentUser?.fullName?.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.person),
                    const SizedBox(width: 8),
                    Text('프로필'),
                  ],
                ),
                onTap: () {
                  // 프로필 화면으로 이동
                },
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    const SizedBox(width: 8),
                    Text('로그아웃'),
                  ],
                ),
                onTap: () async {
                  await authService.signOut();
                },
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 환영 메시지
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '안녕하세요, ${currentUser?.fullName ?? '러너'}님!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '오늘도 힘차게 달려볼까요? 🏃‍♂️',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 대회 정보 섹션
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '🏃 대회 정보',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // 전체 대회 목록으로 이동
                          },
                          child: Text('더보기'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (_events.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            '등록된 대회 정보가 없습니다',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _events.take(3).length,
                        itemBuilder: (context, index) {
                          return EventCard(
                            event: _events[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EventDetailScreen(
                                    event: _events[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    
                    const SizedBox(height: 32),
                    
                    // 런닝 용품 섹션
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '🛍️ 추천 제품',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // 전체 제품 목록으로 이동
                          },
                          child: Text('더보기'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (_featuredProducts.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            '추천 제품이 없습니다',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _featuredProducts.take(4).length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: _featuredProducts[index],
                            onTap: () async {
                              final url = _featuredProducts[index].productUrl;
                              if (url != null && url.isNotEmpty) {
                                final uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              }
                            },
                          );
                        },
                      ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }
}
