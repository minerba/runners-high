import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../services/product_service.dart';
import '../../utils/constants.dart';
import 'package:provider/provider.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    
    // 관리자 권한 확인
    if (!(authService.currentUser?.isAdmin ?? false)) {
      return Scaffold(
        appBar: AppBar(title: const Text('관리자 패널')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 80,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                '관리자 권한이 필요합니다',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('관리자 패널'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          // 사이드바
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.event),
                label: Text('대회 관리'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_bag),
                label: Text('제품 관리'),
              ),
            ],
          ),
          
          const VerticalDivider(thickness: 1, width: 1),
          
          // 메인 컨텐츠
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                EventManagementPanel(),
                ProductManagementPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 대회 관리 패널
class EventManagementPanel extends StatefulWidget {
  const EventManagementPanel({super.key});

  @override
  State<EventManagementPanel> createState() => _EventManagementPanelState();
}

class _EventManagementPanelState extends State<EventManagementPanel> {
  final _eventService = EventService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  final _imageUrlController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    final error = await _eventService.createEvent(
      title: _titleController.text,
      description: _descriptionController.text,
      eventUrl: _urlController.text,
      imageUrl: _imageUrlController.text,
      eventDate: _selectedDate,
    );

    if (mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('대회 정보가 등록되었습니다'),
            backgroundColor: AppColors.success,
          ),
        );
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _urlController.clear();
    _imageUrlController.clear();
    setState(() => _selectedDate = null);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '대회 정보 등록',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '대회 제목 *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '제목을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: '대회 설명',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: '대회 링크 URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                ),
                hintText: 'https://example.com',
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: '이미지 URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                ),
                hintText: 'https://example.com/image.jpg',
              ),
            ),
            const SizedBox(height: 16),
            
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _selectedDate == null
                    ? '대회 날짜 선택'
                    : '대회 날짜: ${_selectedDate!.year}.${_selectedDate!.month}.${_selectedDate!.day}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                side: BorderSide(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                  ),
                ),
                child: const Text(
                  '등록하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 제품 관리 패널
class ProductManagementPanel extends StatefulWidget {
  const ProductManagementPanel({super.key});

  @override
  State<ProductManagementPanel> createState() => _ProductManagementPanelState();
}

class _ProductManagementPanelState extends State<ProductManagementPanel> {
  final _productService = ProductService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isFeatured = false;

  Future<void> _createProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text);

    final error = await _productService.createProduct(
      name: _nameController.text,
      description: _descriptionController.text,
      productUrl: _urlController.text,
      imageUrl: _imageUrlController.text,
      price: price,
      isFeatured: _isFeatured,
    );

    if (mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('제품이 등록되었습니다'),
            backgroundColor: AppColors.success,
          ),
        );
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _urlController.clear();
    _imageUrlController.clear();
    _priceController.clear();
    setState(() => _isFeatured = false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '제품 등록',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '제품명 *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '제품명을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: '제품 설명',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '가격',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                ),
                prefixText: '₩ ',
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: '제품 링크 URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                ),
                hintText: 'https://example.com/product',
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: '이미지 URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                ),
                hintText: 'https://example.com/image.jpg',
              ),
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: Text('메인 페이지에 노출'),
              value: _isFeatured,
              onChanged: (value) {
                setState(() => _isFeatured = value);
              },
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                side: BorderSide(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                  ),
                ),
                child: const Text(
                  '등록하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
